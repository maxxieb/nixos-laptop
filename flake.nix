{
  description = "Flaked NixOS Config";

  inputs = {
    hosts.url = "github:StevenBlack/hosts";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
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

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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
    nvf,
    rust-overlay,
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
          nvf.nixosModules.nvf
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
          ./hosts/hp840/configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          lix-module.nixosModules.default
          chaotic.nixosModules.default
          hosts.nixosModule
          nvf.nixosModules.nvf
          ./home.nix
        ];
      };
    };

    formatter = inputs.alejandra.defaultPackage;
  };
}
