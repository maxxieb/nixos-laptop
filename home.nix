{
  pkgs,
  inputs,
  lib,
  ...
}: let
  vs-ext = inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace;
  inherit (inputs.flox.packages.x86_64-linux) flox;
in {
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    useUserPackages = true;
    users.max = {
      home = {
        keyboard = {
          options = ["caps:escape"];
        };

        username = "max";
        homeDirectory = "/home/max";
        stateVersion = "24.05"; # Please read the comment before changing.
        sessionPath = [
          "$HOME/go/bin"
          "$HOME/.config/emacs/bin"
        ];

        packages = with pkgs; [
          wofi
          minikube
          openconnect
          mattermost-desktop
          bat
          bitwarden
          croc
          csview
          grafana-alloy
          delve
          devbox
          dig
          direnv
          vesktop
          du-dust
          fd
          feh
          ansible
          firefox
          fluxcd
          nmap
          fzf
          gh
          libreoffice-qt6-fresh
          simple-scan
          ipmitool
          git
          git-lfs
          gron
          blueberry
          glow
          gnumake
          pdfannots2json
          go
          google-chrome
          wdisplays
          gparted
          k3d
          graphviz
          hddtemp
          (python3.withPackages (p: [
            p.requests
            p.lxml
          ]))
          htop
          ibm-plex
          inetutils
          jless
          jost
          jq
          killall
          kind
          kubectl
          kubernetes-helm
          devenv
          kustomize
          libgen-cli
          lm_sensors
          nautilus
          nerd-fonts.hack
          noto-fonts
          openmoji-color
          font-awesome
          swaycons
          networkmanager
          networkmanagerapplet
          networkmanager-openconnect
          nil
          nix-index
          obsidian
          openssl
          pavucontrol
          ripgrep
          rsync
          slack
          spotify
          starship
          tealdeer
          traceroute
          tree
          unzip
          usbutils
          vlc
          yq-go
          zathura
          zeal
          zip
          zotero
          flox
        ];
        sessionVariables = {
          TERM = "xterm-256color";
          EDITOR = "nvim";
        };
      };
      services = {
        dunst = {
          enable = true;
          settings = {
            global = {
              width = 300;
              height = 300;
              offset = "30x50";
              origin = "top-right";
            };

            urgency_normal.timeout = 10;
          };
        };
      };
      programs = {
        k9s = {
          enable = true;
        };
        nh = {
          enable = true;
          clean.enable = true;
          flake = "/etc/nixos";
        };

        home-manager.enable = true;

        autorandr.enable = true;
        eza = {
          enable = true;
          colors = "auto";
          git = true;
          icons = "auto";
        };

        zoxide.enable = true;
        zoxide.options = [
          "--cmd z"
        ];
        vscode = {
          enable = true;
          package = pkgs.vscodium;
          extensions = with vs-ext; [
            zainchen.json
            bbenoist.nix
            golang.go
            ms-python.python
            redhat.ansible
            grafana.grafana-alloy
            jgclark.vscode-todo-highlight
          ];
          userSettings = {
            "files.autoSave" = "onFocusChange";
            "files.insertFinalNewline" = true;
            "files.trimTrailingWhitespace" = true;
            "editor.formatOnSave" = true;
            "editor.cursorBlinking" = "phase";
            "editor.cursorStyle" = "line";
            "editor.fontLigatures" = true;
            "workbench.sideBar.location" = "right";
            "explorer.autoReveal" = true;
            "editor.fontFamily" = lib.mkForce "Hack Nerd Font Mono";
            "terminal.integrated.fontFamily" = lib.mkForce "Hack Nerd Font Mono";
          };
        };

        waybar.enable = true;
        waybar.settings = [
          {
            layer = "top";
            position = "top";
            height = 30;
            modules-left = ["hyprland/workspaces"];
            modules-center = ["clock"];
            modules-right = [
              "network"
              "battery"
            ];
            "hyprland/workspaces" = {
              format = "{icon}";
              on-scroll-up = "hyprctl dispatch workspace e+1";
              on-scroll-down = "hyprctl dispatch workspace e-1";
            };
            "network" = {
              interval = 10;
              format = "{ifname} {ipaddr}";
            };
            "clock" = {
              interval = 5;
              format = "{:%H:%M:%S}";
              format-alt = "{:%A, %B %d, %Y (%R)}  ";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "year";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                on-click-right = "mod";
              };
            };

            "battery".format = "{icon} {capacity}%";
          }
        ];

        carapace.enable = true;
        carapace.enableNushellIntegration = true;
        zsh = {
          enable = true;
          initExtra = "${pkgs.owofetch}/bin/owofetch";
          autosuggestion.enable = true;
          enableCompletion = true;
          autocd = true;
          enableVteIntegration = true;
          shellAliases = {
            gitroot = "cd $(git rev-parse --show-toplevel)";
            nv = "nvim";
            k = "kubectl";
            glow = "glow -p";
          };

          history.ignoreDups = true;

          oh-my-zsh.enable = true;
          oh-my-zsh.plugins = [
            "git"
            "sudo"
            "aws"
          ];

          sessionVariables.TERM = "xterm-256color";
        };
        starship = {
          enable = true;
          enableZshIntegration = true;
          settings = {
            add_newline = true;

            character.success_symbol = "[➜](bold green)";
            character.error_symbol = "[➜](bold red)";
          };
        };
        fzf = {
          enable = true;
          enableZshIntegration = true;
          changeDirWidgetCommand = "fd --type d . $HOME";
          fileWidgetCommand = "fd --type d .";

          tmux.enableShellIntegration = true;
        };
        git = {
          enable = true;
          delta.enable = true;
          userEmail = "maxbrydak@gmail.com";
          userName = "mbrydak";
        };
        kitty = {
          enable = true;

          settings.background_opacity = lib.mkForce 0.8;
          settings.confirm_os_window_close = 2;

          font.name = lib.mkForce "Hack Nerd Font Mono";

          shellIntegration.enableZshIntegration = true;
        };

        zellij.enable = true;
        zellij.enableZshIntegration = true;

        direnv.enable = true;
        direnv.nix-direnv.enable = true;
        helix = {
          enable = true;
          extraPackages = [
            pkgs.marksman
            pkgs.terraform-ls
            pkgs.nil
            pkgs.rust-analyzer
            pkgs.gopls
          ];

          languages.language = [
            {
              name = "rust";
              auto-format = true;
            }
            {
              name = "hcl";
              auto-format = true;
            }
          ];
        };
        rofi = {
          enable = true;
          terminal = "kitty";

          extraConfig.modes = "window,drun,run,ssh";
          extraConfig.show-icons = true;
        };

        hyprlock.enable = true;
      };

      fonts.fontconfig.enable = true;
      wayland = {
        windowManager = {
          hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
              borders-plus-plus
            ];
            settings = {
              "$mainMod" = "SUPER";
              "exec-once" = "hyprpaper";
              monitor = ",1920x1080,auto,1,bitdepth,8";
              general = {
                gaps_in = 5;
                gaps_out = 10;
                border_size = 2;
                layout = "master";
              };

              input.kb_layout = "pl";

              input.touchpad.natural_scroll = "yes";
              decoration = {
                rounding = 10;
                blur = {
                  enabled = true;
                  size = 3;
                  passes = 1;
                };
                shadow = {
                  enabled = true;
                  range = 4;
                  render_power = 3;
                };
              };

              dwindle.pseudotile = "yes";
              dwindle.preserve_split = "yes";

              bindel = [
                ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 6.25%+"
                ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 6.25%-"
              ];

              # Media.
              bindl = [
                ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
                ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
                ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
              ];
              bind = [
                "$mainMod SHIFT, D, exec, hyprctl keyword general:layout \"dwindle\""
                "$mainMod CTRL,  D, exec, hyprctl keyword general:layout \"master\""
                
                "$mainMod SHIFT, M, layoutmsg, swapwithmaster"
                "$mainMod, F, fullscreen"
                "$mainMod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
                "$mainMod, C, killactive,"
                "$mainMod SHIFT, E, exit,"
                "$mainMod, E, exec, ${pkgs.dolphin}/bin/dolphin"
                "$mainMod, V, togglefloating,"
                "$mainMod, R, exec, ${pkgs.wofi}/bin/wofi --show drun"
                "$mainMod, P, pseudo," # dwindle
                "$mainMod, J, togglesplit," # dwindle
                "$mainMod, T, togglegroup,"

                # Move focus with mainMod + arrow keys
                "$mainMod, left, movefocus, l"
                "$mainMod, right, movefocus, r"
                "$mainMod, up, movefocus, u"
                "$mainMod, down, movefocus, d"

                
                "$mainMod, left, changegroupactive, b"
                "$mainMod, right, changegroupactive, f"

                "$mainMod SHIFT, left, movewindoworgroup, l"
                "$mainMod SHIFT, right, movewindoworgroup, r"
                "$mainMod SHIFT, up, movewindoworgroup, u"
                "$mainMod SHIFT, down, movewindoworgroup, d"


                # Screen brightness
                ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%"
                ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-"

                # Screenshot
                ", Print, exec, ${pkgs.sway-contrib.grimshot}/bin/grimshot copy"

                # Switch workspaces with mainMod + [0-9]
                "$mainMod, 1, workspace, 1"
                "$mainMod, 2, workspace, 2"
                "$mainMod, 3, workspace, 3"
                "$mainMod, 4, workspace, 4"
                "$mainMod, 5, workspace, 5"
                "$mainMod, 6, workspace, 6"
                "$mainMod, 7, workspace, 7"
                "$mainMod, 8, workspace, 8"
                "$mainMod, 9, workspace, 9"
                "$mainMod, 0, workspace, 10"

                # Move active window to a workspace with mainMod + SHIFT + [0-9]
                "$mainMod SHIFT, 1, movetoworkspace, 1"
                "$mainMod SHIFT, 2, movetoworkspace, 2"
                "$mainMod SHIFT, 3, movetoworkspace, 3"
                "$mainMod SHIFT, 4, movetoworkspace, 4"
                "$mainMod SHIFT, 5, movetoworkspace, 5"
                "$mainMod SHIFT, 6, movetoworkspace, 6"
                "$mainMod SHIFT, 7, movetoworkspace, 7"
                "$mainMod SHIFT, 8, movetoworkspace, 8"
                "$mainMod SHIFT, 9, movetoworkspace, 9"
                "$mainMod SHIFT, 0, movetoworkspace, 10"

                # Scroll through existing workspaces with mainMod + scroll
                "$mainMod, mouse_down, workspace, e+1"
                "$mainMod, mouse_up, workspace, e-1"

                # Move/resize windows with mainMod + LMB/RMB and dragging
              ];
              bindm = [
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
              ];

              xwayland.force_zero_scaling = true;
            };
          };
        };
      };
    };
  };
}
