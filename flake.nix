{
  description = "Nix flake for Nix Home Manager config";

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
      url = "github:tesujimath/nu_plugin_bash_env/0.12.0";
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

  outputs = { nixpkgs, home-manager, bash_env_elvish, nu_plugin_bash_env, eza, nix_search_cli, ... }:
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
        bash_env_elvish = bash_env_elvish.packages.${system}.default;
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
                  # this is causing infinite recursion 🤷
                  # home.sessionVariables.HOME_MANAGER_FLAKE_REF_ATTR = "path:${attrs.home.homeDirectory}/home.nix#${name}";
                })
              ];
              extraSpecialArgs = {
                inherit flakePkgs;
              };
            })
          configurations;
    };
}
