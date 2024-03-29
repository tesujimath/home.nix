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

      stateVersion = "21.11";

    in {
      homeConfigurations = {
        agr = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.agr.nix
            {
              home = {
                inherit stateVersion;
                username = "guestsi"; #builtins.getEnv "USER";
                homeDirectory = /home/guestsi; # /. + builtins.getEnv "HOME";
              };
            }
          ];
          extraSpecialArgs = {
            inherit flakePkgs;
          };
        };

        agr-hpc = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.agr-hpc.nix
            {
              home = {
                inherit stateVersion;
                username = "guestsi"; #builtins.getEnv "USER";
                homeDirectory = /home/guestsi; # /. + builtins.getEnv "HOME";
              };
            }
          ];
          extraSpecialArgs = {
            inherit flakePkgs;
          };
        };

        personal = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.personal.nix
            {
              home = {
                inherit stateVersion;
                username = "sjg"; #builtins.getEnv "USER";
                homeDirectory = /home/sjg; # /. + builtins.getEnv "HOME";
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
