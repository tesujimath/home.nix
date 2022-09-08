{
  description = "sjg home manager flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;

    home-manager = {
      url = github:nix-community/home-manager/release-22.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # other flakes
    aws-ep.url = path:/home/sjg/vc/nix/aws-ep;
  };

  outputs = { nixpkgs, home-manager, aws-ep, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      flakePkgs = {
        aws-ep = aws-ep.defaultPackage.${system};
      };

      username = "sjg"; #builtins.getEnv "USER";
      homeDirectory = /home/sjg; # /. + builtins.getEnv "HOME";
      stateVersion = "21.11";

    in {
      homeConfigurations = {
        ep = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs username homeDirectory stateVersion;

          configuration = import ./home.ep.nix { inherit pkgs flakePkgs; };

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };

        personal = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs username homeDirectory stateVersion;

          configuration = import ./home.personal.nix;

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
      };
    };
}
