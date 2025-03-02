{
  description = "Nix flake for Nix Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bash-env-json = {
      url = "github:tesujimath/bash-env-json/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bash-env-nushell = {
      url = "github:tesujimath/bash-env-nushell/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.bash-env-json.follows = "bash-env-json";
    };
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (pkg: true);
        };
      };
      flakePkgs = {
        bash-env-json = inputs.bash-env-json.packages.${system}.default;
        bash-env-nushell = inputs.bash-env-nushell.packages.${system}.default;
      };
      localPkgs = {
        volnoti = pkgs.callPackage ./packages/volnoti { };
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
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./main.nix
                (lib.attrsets.recursiveUpdate attrs {
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
