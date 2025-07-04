# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
  ...
}: let
  rootPath = ../../.;
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  nix = {
    # Nix config
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://niri.cachix.org"
        "https://nvf.cachix.org"
        "https://cache.flox.dev"
        "https://chaotic-nyx.cachix.org/"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
        "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };

    extraOptions = ''
      trusted-users = root max qlb
    '';
    optimise.automatic = true;
  };
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";

    pathsToLink = [
      "/libexec"
      "/share/zsh"
    ];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      mako
      libnotify
      xterm
      rofi
      cloudflare-warp
      sweethome3d
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ms-vscode-remote.remote-ssh
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.47.2";
            sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
          }
        ];
      })
    ];
  };
  boot = {
    loader = {
      grub = {
        # Bootloader.
        enable = true;
        device = "/dev/nvme0n1";
        useOSProber = true;
      };
    };
  };
  networking = {
    hostName = "t480"; # Define your hostname.

    hosts = {
      "192.168.11.28" = ["bastion"];
      "192.168.11.167" = ["cntm"];
      #  "192.168.0.77" = ["k8s-master-0.homelab.home"];
      #  "192.168.0.116" = ["k8s-master-1.homelab.home"];
      #  "192.168.0.220" = ["k8s-master-2.homelab.home"];
      #  "192.168.0.27" = ["k8s-worker-0.homelab.home"];
      #  "192.168.0.232" = ["k8s-worker-1.homelab.home"];
      #  "192.168.0.84" = ["k8s-worker-2.homelab.home"];
      #  "192.168.0.201" = ["pve.homelab.home"];
      #  "192.168.0.57" = ["pihole.homelab.home"];
      #  "192.168.0.78" = ["k8s-lb.homelab.home"];
    };

    # networking.nameservers = [ "1.1.1.1" "1.0.0.1" "192.168.0.57" ];
    nameservers = ["192.168.0.57"];
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager = {
      enable = true;
    };

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    firewall = {
      allowedUDPPorts = [5353]; # For device discovery
      allowedUDPPortRanges = [
        {
          from = 32768;
          to = 61000;
        }
      ]; # For Streaming
      allowedTCPPorts = [8010]; # For gnomecast server
    };
  };
  stylix = {
    enable = true;

    image = rootPath + /wallpaper/flcl-tv-robot.jpg;

    polarity = "dark";
  };
  services = {

    k3s = {
      enable = false;
      package = pkgs.k3s_1_31;
      extraFlags = ["--disable=traefik"];
    };
    syslog-ng.enable = true;
    resolved.enable = true;
    openssh.enable = true;
    openssh.settings = {
      PasswordAuthentication = true;
    };

    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 60;
      };
    };

    locate.enable = true;

    # Enable the SDDM Dispaly Manager

    # enable picom
    picom.enable = true;
    gnome.gnome-keyring.enable = true;

    # Configure keymap in X11

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --time --time-format '%a, %d %b %Y • %T' --greeting  '[Become \t          Visible]' --asterisks --remember --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [brlaser];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
   
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
      wireplumber = {
        enable = true;
        package = pkgs.wireplumber;
      };
    };
    blueman.enable = true;
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  documentation = {
    nixos.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
  };
  security.pam.services.lightdm.enableGnomeKeyring = true;
  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      xwayland.enable = true;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    ssh.startAgent = true;

    virt-manager.enable = true;

    # enalbe zsh
    zsh.enable = true;
    nix-ld.enable = true;    
  };

  # Configure console keymap
  console.keyMap = "pl2";
  hardware = {
    # Enable bluetooth and sound over bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    # Trackpoint settings

    trackpoint = {
      enable = true;
      speed = 192;
      sensitivity = 192;
      emulateWheel = true;
    };
  };
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    isNormalUser = true;
    description = "max";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "scanner"
      "lp"
      "libvirtd"
    ];
    shell = pkgs.zsh;
  };
  users.users.qlb = {
    initialPassword = "changethispassword";
    isNormalUser = true;
    description = "qlb";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "scanner"
      "lp"
      "libvirtd"
    ];
    shell = pkgs.zsh;
  };
  nixpkgs.config.permittedInsecurePackages = ["electron-25.9.0"];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    jost
    ibm-plex
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # List services that you want to enable:
  # Enable Docker

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    containers.enable = true;
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  systemd.packages = [ pkgs.cloudflare-warp ]; # for warp-cli
  systemd.targets.multi-user.wants = [ "warp-svc.service" ]; # causes warp-svc to be started automatically
}
