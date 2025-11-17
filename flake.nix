{
  description = "Nix flake for Nix Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bash-env-json = {
      url = "github:tesujimath/bash-env-json/main";
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
              pkgs = import inputs.nixpkgs {
                inherit system;
                config = {
                  allowUnfree = true;
                  allowUnfreePredicate = (pkg: true);
                };
              };
              flakePkgs = {
                bash-env-json = inputs.bash-env-json.packages.${system}.default;
              };
              localPkgs = {
                volnoti = pkgs.callPackage ./packages/volnoti { };
                prettier-with-plugins = pkgs.callPackage ./packages/prettier-with-plugins { };
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
    };
}
