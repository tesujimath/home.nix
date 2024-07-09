{
  description = "sjg home manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bash_env_elvish = {
      url = "github:tesujimath/bash-env-elvish/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nu_plugin_bash_env = {
      # we have to manually keep version of Nu bash-env plugin in step with Nushell version
      url = "github:tesujimath/nu_plugin_bash_env/0.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eza = {
      url = "github:eza-community/eza/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix_search = {
      url = "github:diamondburned/nix-search/v0.3.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, bash_env_elvish, nu_plugin_bash_env, eza, nix_search, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      flakePkgs = {
        bash_env_elvish = bash_env_elvish.packages.${system}.default;
        nu_plugin_bash_env = nu_plugin_bash_env.packages.${system}.default;
        eza = eza.packages.${system}.default;
        nix_search = nix_search.packages.${system}.default;
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
                sessionVariables.HOME_MANAGER_FLAKE_REF_ATTR = "path:/home/guestsi/vc/env/home.nix#agr";
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
                sessionVariables.HOME_MANAGER_FLAKE_REF_ATTR = "path:/home/guestsi/vc/env/home.nix#agr-hpc";
              };
            }
          ];
          extraSpecialArgs = {
            inherit flakePkgs;
          };
        };

        agr-eri = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.agr-eri.nix
            {
              home = {
                inherit stateVersion;
                username = "guestsi@agresearch.co.nz"; #builtins.getEnv "USER";
                homeDirectory = /home/agresearch.co.nz/guestsi; # /. + builtins.getEnv "HOME";
                sessionVariables.HOME_MANAGER_FLAKE_REF_ATTR = "path:/home/agresearch.co.nz/guestsi/vc/env/home.nix#agr-eri";
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
                sessionVariables.HOME_MANAGER_FLAKE_REF_ATTR = "path:/home/sjg/vc/env/home.nix#personal";
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
