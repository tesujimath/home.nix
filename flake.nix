{
  description = "Nix flake for Nix Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tesujimath-modules = {
      url = "github:tesujimath/home.modules.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tesujimath-modules-datacom = {
      # private repo for Datacom specifics
      url = "git+ssh://git@github.com/tesujimath/home.modules.datacom.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nox = {
      url = "github:madsbv/nix-options-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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
                  overlays = [ inputs.tesujimath-modules.overlays.default ];
                  config = {
                    allowUnfreePredicate =
                      let
                        allowedUnfree = [
                          "1password-cli"
                          "claude-code"
                          "cursor"
                          "cursor-cli"
                          "datagrip"
                          "rider"
                          "teams"
                          "vscode"
                          "widevine-cdm" # for playing Spotify in open source browsers
                          "zoom"
                        ];
                      in
                      pkg: builtins.elem (pkgs.lib.getName pkg) allowedUnfree;

                  };
                };
              flakePkgs = {
                nox = inputs.nox.packages.${system}.default;
              };

            in
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./base.nix
                ./modules/local-llms.nix
                inputs.nix-index-database.homeModules.nix-index
                inputs.tesujimath-modules.homeManagerModules.default
                inputs.tesujimath-modules-datacom.homeManagerModules.default
                (pkgs.lib.attrsets.recursiveUpdate (attrs pkgs) {
                  home.sessionVariables.HOME_MANAGER_FLAKE_REF_ATTR = "path:$HOME/home.nix#${name}";
                })
              ];
              extraSpecialArgs = {
                inherit flakePkgs;
              };
            })
          configurations;

      # for nix repl
      inherit inputs;
    };
}
