{
  config,
  git-hook-deny-fixme,
  lib,
  pkgs,
  system,
  vscode-extensions,
  waybar-style,
  ...
}:

let
  sway-config = import ./sway.nix { inherit lib pkgs; };
in
{
  imports = [];

  # Enable unfree packages for the user
  nixpkgs.config.allowUnfree = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };
    /*
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    */
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };

  home.packages = with pkgs; [
    appimage-run
    brightnessctl
    btop
    direnv
    discord
    fira
    fira-code
    flameshot
    font-awesome
    font-awesome_5
    git
    gocryptfs
    google-chrome
    helvum
    htop
    jless
    kanshi
    mpv
    neofetch
    networkmanagerapplet
    nix-prefetch-git
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nushell
    oh-my-zsh
    qbittorrent
    rustup
    sshfs
    swaynotificationcenter
    telegram-desktop
    tree
    typst
    typstfmt
    typst-lsp
    udiskie
    unzip
    vscodium
    waybar
    wezterm
    wlr-randr
    wmenu
    wttrbar
    zstd
  ];

  # Cursor
  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  home.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    XCURSOR_SIZE = "24";
  };

  # Direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # Foot
  programs.foot = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "yes";
      };
      colors = {
        alpha = 0.95;
      };
    };
  };

  # Git
  programs.git = {
    enable = true;
    aliases = {
      rebase-ic = "-c core.editor='codium -n --wait' rebase -i";
    };
    extraConfig = {
      core = {
        sshCommand = "ssh -i ~/.ssh/github/a-manning_ed25519_sk";
      };
      merge = {
        renameLimit = 4096;
      };
    };
    hooks = {
      pre-commit = git-hook-deny-fixme;
    };
    includes = [
      { condition = "gitdir:~/Dev/"; path = "~/Dev/.gitconfig"; }
    ];
    userName = "Ash Manning";
  };

  # Micro
  programs.micro.enable = true;
  programs.micro.settings = {
  	colorscheme = "dukeubuntu-tc";
  	eofnewline = false;
  	fastdirty = true;
  	tabstospaces = true;
  };

  # Nushell
  programs.nushell = {
    enable = true;
  };

  # VSCodium
  programs.vscode = {
    enable = true;
    extensions =
      let vscode-marketplace =
        vscode-extensions.extensions.${system}.vscode-marketplace;
      in [
        vscode-marketplace."2gua".rainbow-brackets
        vscode-marketplace.alefragnani.bookmarks
        vscode-marketplace.bbenoist.nix
        vscode-marketplace.canadaduane.vscode-kmonad
        vscode-marketplace.juanblanco.solidity
        vscode-marketplace.max-ss.cyberpunk
        vscode-marketplace.nvarner.typst-lsp
        vscode-marketplace.peterj.proto
        vscode-marketplace.rust-lang.rust-analyzer
        vscode-marketplace.tamasfe.even-better-toml
        vscode-marketplace.thenuprojectcontributors.vscode-nushell-lang
        vscode-marketplace.tomoki1207.pdf
      ];
    keybindings = [
      {
        key = "ctrl+shift+f";
        command = "-workbench.action.findInFiles";
      }
    ];
    mutableExtensionsDir = false;
    package = pkgs.vscodium;
    userSettings = {
      "editor.fontFamily" =
        "'Fira Code', 'Font Awesome 6 Free', 'FiraCode Nerd Font'";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 16;
      "editor.rulers" = [ 79 ];
      "rust-analyzer.imports.merge.glob" = false;
      "rust-analyzer.inlayHints.chainingHints.enable" = false;
      "rust-analyzer.inlayHints.parameterHints.enable" = false;
      "rust-analyzer.inlayHints.typeHints.enable" = false;
      "rust-analyzer.procMacro.enable" = false;
      # Some issues with fontconfig
      "typst-lsp.exportPdf" = "never";
      "window.menuBarVisibility" = "toggle";
      "workbench.colorTheme" = "Activate UMBRA protocol";
      "[markdown]" = {
        "editor.wordWrap" = "wordWrapColumn";
      };
    };
  };

  # Waybar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        battery = {
          format-charging-healthy = "󱊦 {capacity}%";
          format-charging-early-warning = "󱊥 {capacity}%";
          format-charging-warning = "󱊤 {capacity}%";
          format-charging-critical = "󰢟 {capacity}%";
          format-discharging-healthy = "󱊣 {capacity}%";
          format-discharging-early-warning = "󱊢 {capacity}%";
          format-discharging-warning = "󱊡 {capacity}%";
          format-discharging-critical = "󱃍 {capacity}%";
          format-plugged = "plugged {capacity}%";
          format-full = " 100%";
          states = {
            healthy = 100;
            early-warning = 45;
            warning = 30;
            critical = 15;
          };
        };
        clock = {
          actions = {
            on-click-backward = "tz_down";
            on-click-forward = "tz_up";
            on-click-right = "mode";
            on-scroll-down = "shift_down";
            on-scroll-up = "shift_up";
          };
          calendar = {
            mode = "year";
            mode-mon-col = 2;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              months = "<span color='#ffead3'><b>{}</b></span>";
              today = "<span color='#ff6699'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            };
          };
          format = "{:%H:%M:%S}";
          interval = 1;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };
        "custom/weather" = {
          exec = "wttrbar --location Taipei";
          format = "{}°C";
          return-type = "json";
        };
        "temperature#cpu" = {
          format = " {temperatureC}°C";
          hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";
        };
        "temperature#gpu" = {
          format = "󰢮 {temperatureC}°C";
          hwmon-path = "/sys/class/hwmon/hwmon8/temp1_input";
        };
        "temperature#nvme1" = {
          format = " {temperatureC}°C";
          hwmon-path = "/sys/class/hwmon/hwmon0/temp1_input";
        };
        tray = {
          reverse-direction = true;
          spacing = 8;
        };
        wireplumber = {
          format = " {volume}%";
          format-muted = " MUTE";
          on-click = "helvum";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        layer = "bottom";
        modules-left = [ "sway/workspaces" ];
        # modules-center = [ "temperature" ];
        modules-right = [
          "temperature#cpu"
          "temperature#nvme1"
          "wireplumber"
          "battery"
          "tray"
          "custom/weather"
          "clock"
        ];
        position = "bottom";
        "sway/workspaces" = {
          disable-scroll = true;
          # all-outputs = true;
        };
      };
    };
    style = waybar-style;
  };

  # Wezterm
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        color_scheme = "Tokyo Night",
        disable_default_key_bindings = true,
        font = wezterm.font 'Fira Mono',
        hide_tab_bar_if_only_one_tab = true,
        keys = {
          {
            key = 'C',
            mods = 'CTRL',
            action = wezterm.action.CopyTo 'Clipboard'
          },
          {
            key = 'C',
            mods = 'SHIFT|CTRL',
            action = wezterm.action.CopyTo 'Clipboard'
          },
          {
            key = 'T',
            mods = 'CTRL',
            action = wezterm.action.SpawnTab 'CurrentPaneDomain',
          },
          {
            key = 'V',
            mods = 'CTRL',
            action = wezterm.action.PasteFrom 'Clipboard'
          },
          {
            key = 'V',
            mods = 'SHIFT|CTRL',
            action = wezterm.action.PasteFrom 'Clipboard'
          },
        },
        window_background_opacity = 0.95,
        window_padding = {
          left = 2,
          right = 2,
          top = 0,
          bottom = 0,
        }

      }
    '';
  };

  # Zsh
  programs.zsh = {
  	enable = true;
  	initExtra = "setopt hist_ignore_space";
    shellAliases = {
      gdiff = "git diff";
      glfm = "git ls-files --modified";
      glfu = "git ls-files --others --exclude-standard";
      gpush = "git push";
      gstat = "git status";
      r = "echo \"This command has been unset in \\`~/.zshrc\\`.\"";
    };
    shellGlobalAliases = {
      ga = "git add";
    };
  };
  programs.zsh.oh-my-zsh = {
  	enable = true;
  	plugins = [ "git" "per-directory-history" ];
  	theme = "robbyrussell";
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  services = {
    avizo = {
      enable = true;
      settings = {
        default = {
          time = 1.5;
          y-offset = 0.4;
        };
      };
    };

    kanshi = {
      enable = true;
      profiles = {
        docked = {
          exec = [
            "wlr-randr --output DP-9 --off && wlr-randr --output DP-9 --on"
          ];
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
            {
              criteria = "AOC U28P2G6B PDRMAJA003132";
              position = "1920,0";
              scale = 1.5;
              status = "enable";
            }
            {
              criteria = "AOC U28P2G6B PDRMAJA003160";
              position = "4480,0";
              scale = 1.5;
              status = "enable";
            }
          ];
        };
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        };
      };
    };

    # Direnv wrapper
    lorri.enable = true;

    udiskie = {
      enable = true;
      tray = "always";
    };
  };

  # Enable Sway
  wayland.windowManager.sway = sway-config;
}
