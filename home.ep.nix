{ pkgs, flakePkgs, ... }:

{
  imports = [
    ./common.nix
    ./modules/ep-dev-backend
    ./modules/xmonad-desktop
    ./packages.nix
    ./packages.ep.nix
    ./ep/apps.nix
    ./ep/aws.nix
    ./ep/lexicon.nix
    ./secrets.ep.nix
  ];

  home.packages = [
    flakePkgs.aws-ep
    pkgs.tcptraceroute
    pkgs.wireshark
  ];

  programs.ssh = {
    extraOptionOverrides = {
      StrictHostKeyChecking = "accept-new";
    };
  };

  home.sessionVariables = {
    EMAIL = "simon.guest@educationperfect.com";
  };
}
