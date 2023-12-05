{
  description = "sjg home manager flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    home-manager = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nu_plugin_bash_env = {
      url = github:tesujimath/nu_plugin_bash_env/main;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nu_plugin_bash_env, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      flakePkgs = {
        nu_plugin_bash_env = nu_plugin_bash_env.packages.${system}.default;
      };

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
          extraSpecialArgs = {
            inherit flakePkgs;
          };
        };
      };
    };
}
