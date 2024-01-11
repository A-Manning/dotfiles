{
  inputs = {
    git-hook-deny-fixme = {
      flake = false;
      url = "path:../.config/git/hooks/deny-fixme.sh";
    };
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    kmonad.url = "github:kmonad/kmonad?dir=nix";
    kmonad-config = {
      flake = false;
      url = "path:../.config/kmonad/config.kbd";  
    };
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
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
    vscode-extensions,
    waybar-style,
    ...
  }@inputs: {  
    nixosConfigurations = {
      "ash-thinkpad-p16v" = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
        modules = [
          # Import old configuration
          ./configuration.nix

          # Home-manager
          home-manager.nixosModules.home-manager

          # Kmonad module
          kmonad.nixosModules.default

          ({ pkgs, ... }: {
            environment.systemPackages = with pkgs; [
              exfat
              micro
  	          tmux
  	          wl-clipboard
              yubico-pam
  	          zsh
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
                (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; })
                noto-fonts
                noto-fonts-cjk-sans
                noto-fonts-cjk-serif
              ];
            };

            # needed for Ledger
            # groups.plugdev = {};

            # Enable bluetooth
            hardware.bluetooth.enable = true;

            # enable ledger
            hardware.ledger.enable = true;

            # needed for wayland?
            hardware.opengl.enable = true;

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
                  compose.key = null;
                };
                device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
              };
            };

            # Needed for Udiskie
            services.udisks2.enable = true;

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