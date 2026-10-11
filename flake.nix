{
  description = "Modular multi-profile NixOS and Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, antigravity-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [
          antigravity-nix.overlays.default
        ];
      };

      # Helper function to construct a NixOS host with integrated Home Manager
      mkHost = { hostName, homeProfile ? hostName }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostName}
            {
              nixpkgs.overlays = [
                antigravity-nix.overlays.default
              ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.gianluca = import ./home/gianluca/${homeProfile}.nix;
              };
            }
          ];
        };

      # Helper function to construct a standalone Home Manager configuration
      mkHome = { homeProfile }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/gianluca/${homeProfile}.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop = mkHost { hostName = "desktop"; };
        laptop = mkHost { hostName = "laptop"; };
        server = mkHost { hostName = "server"; };

        # Alias for current host (hostname: nixos)
        nixos = mkHost { hostName = "desktop"; };
      };

      homeConfigurations = {
        "gianluca@desktop" = mkHome { homeProfile = "desktop"; };
        "gianluca@laptop"  = mkHome { homeProfile = "laptop"; };
        "gianluca@server"  = mkHome { homeProfile = "server"; };
      };
    };
}
