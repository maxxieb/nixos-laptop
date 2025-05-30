# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
  lib,
  ...
}
: let
  rootPath = ../../.;
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  # Nix config
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

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
      trusted-users = root max
    '';
    optimise.automatic = true;
  };
  boot = {
    binfmt = {
      emulatedSystems = ["aarch64-linux"];
    };
    kernelPackages = pkgs.linuxPackages_cachyos-lto;
    loader = {
      # Bootloader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.luks.devices."luks-8ca1acab-c74d-4bfb-9230-d66684026ef6".device = "/dev/disk/by-uuid/8ca1acab-c74d-4bfb-9230-d66684026ef6";
  };
  networking = {
    # openconnect = {
    #   interfaces = {
    #     openconnect0 = {
    #       gateway = "connect.flipfit.io/flip";
    #       protocol = "anyconnect";
    #       user = "kamil@flip.shop";
    #       passwordFile = /etc/nixos/hosts/hp840/certs/anyconnect-passwd;
    #     };
    #   };
    # };
    hostName = "hp840"; # Define your hostname.
    networkmanager.enable = true;
    stevenBlackHosts = {
      enable = true;
      blockFakenews = true;
      blockGambling = true;
      blockSocial = false;
    };

    extraHosts = ''
      127.0.0.1 vault.vault
      192.168.11.21 bastion
      192.168.11.193 argocd.connectome.name
      192.168.11.193 argocd-grpc.connectome.name
    '';

    # nameservers = ["192.168.0.57"];

    firewall = {
      allowedUDPPorts = [5353];
      allowedUDPPortRanges = [
        {
          from = 32768;
          to = 61000;
        }
      ];
      allowedTCPPorts = [
        8010
        6443
        10250
        6379
        80
        8080
        443
      ];
    };
  };
  swapDevices = lib.mkForce [];

  stylix = {
    enable = true;

    opacity = {
      terminal = 0.8;
    };

    base16Scheme = {
      base00 = "1c202c";
      base01 = "4d4455";
      base02 = "5d6280";
      base03 = "c98365";
      base04 = "c6b790";
      base05 = "f0dd9b";
      base06 = "fff0cf";
      base07 = "fbedae";
      base08 = "aa8c74";
      base09 = "9f8a6b";
      base0A = "969384";
      base0B = "a29279";
      base0C = "a68e6a";
      base0D = "9b9478";
      base0E = "a7906e";
      base0F = "989175";
      scheme = "Stylix";
      author = "Stylix";
      slug = "stylix";
    };

    image = rootPath + /wallpaper/49041096012_fde0c8a500_o.jpg;

    polarity = "dark";
  };
  services = {
    freshrss = {
      enable = true;
      authType = "none";
      baseUrl = "http://localhost";
    };
    gitea.enable = true;
    k3s = {
      enable = false;
      package = pkgs.k3s_1_32;
      extraFlags = ["--disable=traefik"];
    };
    #webdav = {
    #  enable = true;
    #  settings = {
    #    directory = "/srv/webdav";
    #    address = "0.0.0.0";
    #    port = 8080;
    #    modify = true;
    #    permissions = "CRUD";
    #    users = [
    #      {
    #        username = "admin";
    #        password = "admin";
    #      }
    #    ];
    #  };
    #};
    #webdav-server-rs = {
    #  enable = true;
    #  settings = {
    #    server.listen = ["0.0.0.0:4918" "[::]:4918"];
    #    accounts = {
    #      auth-type = "htpasswd.default";
    #      acct-type = "unix";
    #    };
    #    htpasswd.default = {
    #      htpasswd = "/etc/htpasswd";
    #    };
    #    location = [
    #      {
    #        route = ["/zotero/*path"];
    #        directory = "/srv/zotero";
    #        handler = "filesystem";
    #        methods = ["webdav-ro"];
    #        autoindex = true;
    #        auth = "false";
    #      }
    #    ];
    #  };
    #};
    #xserver = {
    #  enable = true;
    #  displayManager.gdm.enable = true;
    #  desktopManager.gnome.enable = true;
    #};
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    #ollama = {
    #  enable = true;
    #  loadModels = ["deepseek-r1:1.5b" "deepseek-r1:7b" "deepseek-r1:8b" "llama3.1:8b" "llama3.2:3b"];
    #};
    #open-webui = {
    #  enable = true;
    #  openFirewall = true;
    #};
    speechd.enable = false;
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
      startWhenNeeded = true;
    }; # optional
    scx = {
      enable = true;
      scheduler = "scx_rusty";
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --time --time-format '%a, %d %b %Y • %T' --greeting  '[Become \t          Visible]' --asterisks --remember --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    resolved.enable = true;

    locate.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        package = pkgs.wireplumber;
      };
    };
    openssh = {
      enable = true;
      settings = {
        UseDns = true;
        PasswordAuthentication = true;
      };
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
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
  };
  environment = {
    stub-ld.enable = false;
    sessionVariables.NIXOS_OZONE_WL = "1";

    pathsToLink = [
      "/libexec"
      "/share/zsh"
    ];
    variables.XDG_RUNTIME_DIR = "/run/user/$UID";

    systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      ipmicfg
      mako
      libnotify
      xterm
      rofi
    ];
  };

  documentation = {
    nixos.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
  };
  programs = {
    virt-manager.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    ssh.startAgent = true;
    xwayland.enable = true;

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };

    # enalbe zsh
    zsh.enable = true;

    # Install firefox.
    firefox.enable = true;
  };
  security = {
    # set the runtime directory
    #pam.services.gdm-password.enableGnomeKeyring = true;
    pki.certificateFiles = [
      ./certs/ca-chain.crt
      ./certs/ca.crt
    ];
    rtkit.enable = true;
  };
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    sane = {
      enable = true;
      extraBackends = [pkgs.hplipWithPlugin];
    };
  };

  # Configure console keymap
  console.keyMap = "pl2";

  users.users.max = {
    isNormalUser = true;
    description = "max";
    extraGroups = [
      "networkmanager"
      "ipfs"
      "wheel"
      "docker"
      "scanner"
      "lp"
      "libvirtd"
      "adbusers"
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
  nixpkgs = {
    config.permittedInsecurePackages = ["electron-25.9.0"];

    config.allowUnfree = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    jost
    ibm-plex
    openmoji-color
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
  ];
  xdg = {
    portal.enable = true;
    portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    ];
  };
  virtualisation = {
    libvirtd.enable = true;
    containers.enable = true;
    docker.enable = true;
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
