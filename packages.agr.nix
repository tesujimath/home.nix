{ config, specialArgs, pkgs, ... }:

with pkgs;
with specialArgs; # for flakePkgs
{
  config = {
    # currently a big dump of what I had in nix-env
    home.packages = [
      flakePkgs.bcl-convert.v4_2_4
      amber
      beekeeper-studio
      python3Packages.mitmproxy
      rclone
    ];
  };
}
