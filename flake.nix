{
  description = "Nix flake for Nix Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bash-env-json = {
      url = "github:tesujimath/bash-env-json/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nu_plugin_bash_env = {
      # needs to be kept in step with version of Nu in nixpkgs
      url = "github:tesujimath/nu_plugin_bash_env?tag=0.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eza = {
      url = "github:eza-community/eza/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix_search_cli = {
      url = "github:peterldowns/nix-search-cli/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, bash-env-json, nu_plugin_bash_env, eza, nix_search_cli, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (pkg: true);
        };
        overlays = [
          (import ./overlays/volnoti.nix)
        ];
      };
      flakePkgs = {
        bash-env-json = bash-env-json.packages.${system}.default;
        nu_plugin_bash_env = nu_plugin_bash_env.packages.${system}.default;
        eza = eza.packages.${system}.default;
        nix_search_cli = nix_search_cli.packages.${system}.default;
      };
      lib = pkgs.lib;

    in
    {
      homeConfigurations =
        let
          configurations = (
            import ./config/default.nix
              {
                inherit lib pkgs;
              }
          );
        in
        builtins.mapAttrs
          (name: attrs:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./main.nix
                (lib.attrsets.recursiveUpdate attrs {
                  home.sessionVariables.HOME_MANAGER_FLAKE_REF_ATTR = "path:$HOME/home.nix#${name}";
                })
              ];
              extraSpecialArgs = {
                inherit flakePkgs;
              };
            })
          configurations;
    };
}
