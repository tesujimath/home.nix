{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./modules/ep-dev-backend
    ./modules/xmonad-desktop
    ./packages.nix
    ./ep/apps.nix
    ./ep/aws.nix
    ./secrets.ep.nix
  ];
}
