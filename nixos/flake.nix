{
  inputs = {
    git-hook-deny-fixme = {
      flake = false;
      url = "path:../.config/git/hooks/deny-fixme.sh";
    };
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    kmonad.url = "github:kmonad/kmonad?dir=nix";
    kmonad-config = {
      flake = false;
      url = "path:../.config/kmonad/config.kbd";  
    };
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    waybar-style = {
      flake = false;
      url = "path:./waybar-style.css";
    };
  };
  outputs = {
    self,
    git-hook-deny-fixme,
    home-manager,
    kmonad,
    kmonad-config,
    nixpkgs,
    nixpkgs-unstable,
    vscode-extensions,
    waybar-style,
    ...
  }@inputs: {
    nixosConfigurations = {
      "ash-thinkpad-p16v" =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
          };
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config = pkgs.config;
          };
          # set zen kernel from unstable
          # let myKernelPackages = pkgs-unstable.linuxPackages_zen;
          # let myKernelPackages = pkgs.linuxPackages_zen;
          # myKernelPackages = pkgs.linuxPackages_6_19;
          myKernelPackages = pkgs.linuxPackages_zen;
          # Make sure to use the correct Bus ID values for your system!
		      amdgpuBusId = "PCI:198:0:0";
		      nvidiaBusId = "PCI:1:0:0";
        in
        nixpkgs.lib.nixosSystem {

        modules = [
          {
            boot = {
              kernelPackages = myKernelPackages;
              extraModulePackages = [ myKernelPackages.nvidia_x11_production ];
            };
          }

          # Import old configuration
          ./configuration.nix

          # Home-manager
          home-manager.nixosModules.home-manager

          # Kmonad module
          kmonad.nixosModules.default

          ({ config, lib, pkgs, ... }: {

            environment.systemPackages = [
              pkgs.exfat
              pkgs.micro
  	          pkgs.tmux
  	          pkgs.wl-clipboard
              pkgs.yubico-pam
  	          pkgs.zsh
            ] ++ [
              myKernelPackages.nvidia_x11_production
            ];

            # Fonts
            fonts = {
              enableDefaultPackages = true;
              /*
              fontconfig = {
                defaultFonts = {
                  serif = [ "Vazirmatn" "Ubuntu" ];
                  sansSerif = [ "Vazirmatn" "Ubuntu" ];
                  monospace = [ "Ubuntu" ];
                };
              };
              */
              packages = with pkgs; [
                fira
                fira-code
                font-awesome
                font-awesome_5
                nerd-fonts.fira-code
                nerd-fonts.fira-mono
                noto-fonts
                noto-fonts-cjk-sans
                noto-fonts-cjk-serif
              ];
            };

            # needed for Ledger
            # groups.plugdev = {};

            # Enable bluetooth
            hardware.bluetooth.enable = true;

            # needed for wayland?
            hardware.graphics = {
              enable = true;
              extraPackages = with pkgs; [
                rocmPackages.clr.icd
              ];
            };

            # enable ledger
            hardware.ledger.enable = true;

            # Use proprietary driver for nvidia GPU
            hardware.nvidia = {
              # Modesetting is required.
              modesetting.enable = true;
              # Must disable to get this to work on stable
              # https://discourse.nixos.org/t/nvidia-the-bane-of-my-existence/51524/3
              nvidiaSettings = false;
              open = true;
              package = myKernelPackages.nvidiaPackages.production;

              prime = {
		            # Make sure to use the correct Bus ID values for your system!
		            amdgpuBusId = amdgpuBusId;
		            nvidiaBusId = nvidiaBusId;
                offload = {
                  enable = true;
                  enableOffloadCmd = true;
		            };
	            };
            };

            # home-manager
            home-manager.users.ash = { config, lib, pkgs, ... }: {
              imports = [
                (import ./ash-home.nix {
                  inherit
                    config
                    git-hook-deny-fixme
                    lib
                    pkgs
                    system
                    vscode-extensions
                    waybar-style;
                })
              ];
              # The state version is required and should stay at the version you
              # originally installed.
              home.stateVersion = "23.05";
            };

            networking.enableIPv6 = false;
            networking.firewall = {
              # Open port for wireguard
              allowedUDPPorts = [ 55603 ];
              # If packets are still dropped, they will show up in dmesg
              logReversePathDrops = true;
              # Wireguard trips rpfilter up
              extraCommands = ''
                ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 55603 -j RETURN
                ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 55603 -j RETURN
              '';
              extraStopCommands = ''
                ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 55603 -j RETURN || true
                ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 55603 -j RETURN || true
              '';
            };

            security.pam.yubico = {
              enable = true;
              # debug = true;
              mode = "challenge-response";
              id = [ "18094515" ];
            };

            # Enable bluetooth
            services.blueman.enable = true;

            # needed for sway?
            services.dbus.enable = true;

            services.kmonad = {
              enable = true;
              # package = import "${kmonad}/nix/nixos-module.nix";
              keyboards.builtin = {
                config = builtins.readFile kmonad-config;
                defcfg = {
                  enable = true;
                  fallthrough = true;
                  # Disable compose key by setting to a key that does not exist
                  compose.key = "f24";
                };
                device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
              };
            };

            # Set up a udev rule to create named symlinks for the pci paths.
            #
            # This is necessary because wlroots splits the DRM_DEVICES on
            # `:`, which is part of the pci path.
            # Adapted from https://github.com/TLATER/dotfiles/blob/master/nixos-modules/nvidia/prime.nix
            services.udev.packages = 
              let
                pciPath =
                  xorgBusId:
                  let
                    components = lib.drop 1 (lib.splitString ":" xorgBusId);
                    toHex = i: lib.toLower (lib.toHexString (lib.toInt i));

                    domain = "0000"; # Apparently the domain is practically always set to 0000
                    bus = lib.fixedWidthString 2 "0" (toHex (builtins.elemAt components 0));
                    device = lib.fixedWidthString 2 "0" (toHex (builtins.elemAt components 1));
                    function = builtins.elemAt components 2; # The function is supposedly a decimal number
                  in
                  "dri/by-path/pci-${domain}:${bus}:${device}.${function}-card";

                igpuPath = pciPath amdgpuBusId;
                dgpuPath = pciPath nvidiaBusId;
              in
              lib.singleton (
                pkgs.writeTextDir "lib/udev/rules.d/61-gpu-offload.rules" ''
                  SYMLINK=="${igpuPath}", SYMLINK+="dri/igpu1"
                  SYMLINK=="${dgpuPath}", SYMLINK+="dri/dgpu1"
                ''
              );

            # Needed for Udiskie
            services.udisks2.enable = true;

            # Enable docker
            virtualisation.docker = {
              enable = true;
              daemon.settings = {
                data-root = "/home/ash/.local/share/docker-data-root";
              };
              rootless = {
                enable = true;
                setSocketVariable = true;
              };
            };

            xdg.portal = {
              enable = true;
              wlr.enable = true;
              # gtk portal needed to make gtk apps happy
              # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
            };

          })  
        ];
        system = system;  
      };
    };
  };
}