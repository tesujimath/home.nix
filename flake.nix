{
  description = "sjg home manager flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;

    home-manager = {
      url = github:nix-community/home-manager/release-22.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      username = "sjg"; #builtins.getEnv "USER";
      homeDirectory = /home/sjg; # /. + builtins.getEnv "HOME";
      stateVersion = "21.11";

    in {
      homeConfigurations = {
        ep = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs username homeDirectory stateVersion;

          configuration = ./home.ep.nix;

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };

        personal = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs username homeDirectory stateVersion;

          configuration = ./home.personal.nix;

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
      };
    };
}
