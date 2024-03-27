{ pkgs, ... }:

with pkgs;
{
  home.packages = [
    amber
    bottom
    firefox
    google-chrome
  ];
}
