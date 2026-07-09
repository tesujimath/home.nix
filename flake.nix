{
  description = "Nix flake for Nix Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # TODO fold this back into nixpkgs once PR is merged:
    nixpkgs-deno_292.url = "github:NixOS/nixpkgs/pull/539847/head";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nox = {
      url = "github:madsbv/nix-options-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bash-env-json = {
      url = "github:tesujimath/bash-env-json/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hl = {
      url = "github:pamburus/hl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    {
      homeConfigurations =
        let
          configurations = (
            import ./config/default.nix
          );
        in
        builtins.mapAttrs
          (name: { system
                 , attrs
                 }:
            let
              pkgs = import inputs.nixpkgs
                {
                  inherit system;
                  config = {
                    allowUnfreePredicate =
                      let
                        allowedUnfree = [
                          "claude-code"
                          "cursor"
                          "cursor-cli"
                          "datagrip"
                          "rider"
                          "teams"
                          "zoom"
                        ];
                      in
                      pkg: builtins.elem (pkgs.lib.getName pkg) allowedUnfree;

                  };
                };
              flakePkgs = {
                nox = inputs.nox.packages.${system}.default;
                bash-env-json = inputs.bash-env-json.packages.${system}.default;
                hl = inputs.hl.packages.${system}.default;
                deno_292 = inputs.nixpkgs-deno_292.legacyPackages.${system}.deno;
              };
              localPkgs = {
                volnoti = pkgs.callPackage ./packages/volnoti { };
              };

            in
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./main.nix
                (pkgs.lib.attrsets.recursiveUpdate (attrs pkgs) {
                  home.sessionVariables.HOME_MANAGER_FLAKE_REF_ATTR = "path:$HOME/home.nix#${name}";
                })
              ];
              extraSpecialArgs = {
                inherit flakePkgs localPkgs;
              };
            })
          configurations;

      # for nix repl
      inherit inputs;
    };
}
