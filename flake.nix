{
  description = "Flaked NixOS Config";

  inputs = {
    #nix-snapshotter = {
    #  url = "github:maxxieb/nix-snapshotter";
    #inputs.nixpkgs.follows = "nixpkgs";
    #};
    niri-flake = {
      url = "github:sodiboo/niri-flake";
    };
    hosts.url = "github:StevenBlack/hosts";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stylix = {
      url = "github:danth/stylix";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    flox.url = "github:flox/flox";
    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mdq = {
      url = "github:maxxieb/mdq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    stylix,
    home-manager,
    lix-module,
    chaotic,
    hosts,
    rust-overlay,
    #nix-snapshotter,
    niri-flake,
    self,
    ...
  } @ inputs: {
    nixosConfigurations = {
      t480 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
        modules = [
          ./hosts/t480/configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          niri-flake.nixosModules.niri
          ./home.nix
        ];
      };
      hp840 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ({pkgs, ...}: {
            nixpkgs.overlays = [rust-overlay.overlays.default];
            environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
          })
          #  ({pkgs, ...}: {
          #    # (1) Import nixos module.
          #    imports = [nix-snapshotter.nixosModules.default];

          #    # (2) Add overlay.
          #    nixpkgs.overlays = [nix-snapshotter.overlays.default];

          #    # (3) Enable service.
          #    virtualisation.containerd = {
          #      enable = false;
          #      nixSnapshotterIntegration = true;
          #      k3sIntegration = true;
          #    };
          #    services.nix-snapshotter = {
          #      enable = true;
          #    };
          #    services.k3s = {
          #      enable = true;
          #      snapshotter = "nix";
          #    };

          #    # (4) Add a containerd CLI like nerdctl.
          #    environment.systemPackages = [pkgs.nerdctl];
          #  })
          ./hosts/hp840/configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          lix-module.nixosModules.default
          chaotic.nixosModules.default
          hosts.nixosModule
          niri-flake.nixosModules.niri
          ./home.nix
        ];
      };
    };

    formatter = inputs.alejandra.defaultPackage;
  };
}
