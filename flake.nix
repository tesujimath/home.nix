{
  description = "sjg home manager flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    home-manager = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      flakePkgs = {};

      username = "sjg"; #builtins.getEnv "USER";
      homeDirectory = /home/sjg; # /. + builtins.getEnv "HOME";
      stateVersion = "21.11";

    in {
      homeConfigurations = {
        ep = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.ep.nix
            {
              home = {
                inherit username homeDirectory stateVersion;
              };
            }
          ];
        };

        personal = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.personal.nix
            {
              home = {
                inherit username homeDirectory stateVersion;
              };
            }
          ];
        };
      };
    };
}
