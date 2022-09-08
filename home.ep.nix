{ pkgs, flakePkgs, ... }:

{
  imports = [
    ./common.nix
    ./modules/ep-dev-backend
    ./modules/xmonad-desktop
    ./packages.nix
    ./ep/apps.nix
    ./ep/aws.nix
    ./ep/lexicon.nix
    ./secrets.ep.nix
  ];

  home.packages = [
    flakePkgs.aws-ep
  ];
}
