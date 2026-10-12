{
  description = "PULSAR - Systemic Modular NixOS Infrastructure & Deployment Framework";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
  };

  outputs = { self, nixpkgs, home-manager, antigravity-nix, noctalia, ... }@inputs:
    let
      system = "x86_64-linux";
      envPath = ./.env.json;
      fallbackEnv = {
        username = "gianluca";
        fullName = "Gianluca";
        email = "gianluca@gmail.com";
        hostname = "dumbledore";
        timezone = "Europe/Rome";
        locale = "en_US.UTF-8";
      };
      env =
        if builtins.pathExists envPath
        then builtins.fromJSON (builtins.readFile envPath)
        else fallbackEnv;

      # Helper function to generate modular NixOS system definitions with Home Manager
      mkHost = hostPath: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs env;
        };
        modules = [
          {
            nixpkgs.overlays = [
              antigravity-nix.overlays.default
            ];
          }
          hostPath
          noctalia.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs env;
            };
            home-manager.users.${env.username} = import ./home/user.nix;
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        workstation = mkHost ./hosts/workstation;
        gaming = mkHost ./hosts/gaming;
        dev = mkHost ./hosts/dev;
        laptop = mkHost ./hosts/laptop;
        server = mkHost ./hosts/server;
      };
    };
}
