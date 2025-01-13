{
  description = "Flaked NixOS Config";

  inputs = {
    hosts.url = "github:StevenBlack/hosts";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
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
    };
    nixvim-config.url = "github:mbrydak/nixvim-config";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    #    musnix = {
    #      url = "github:musnix/musnix";
    #    };
  };

  outputs =
    {
      self,
      nixpkgs,
      stylix,
      home-manager,
      nixvim-config,
      lix-module,
      chaotic,
      hosts,
      ...
    }@inputs:
    {

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

            {
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              # home-manager.useUserPackages = true;
              home-manager.users.max = import ./home.nix;
            }
          ];
        };
        hp840 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          # system = "x86_64-linux";
          modules = [
            ./hosts/hp840/configuration.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            lix-module.nixosModules.default
            chaotic.nixosModules.default
            hosts.nixosModule
            #inputs.musnix.nixosModules.musnix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useUserPackages = true;
              home-manager.users.max = import ./home.nix;
            }

          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
