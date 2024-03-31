{ pkgs, ... }:

with pkgs;
{
  home.packages = [
    amber
    bottom
  ];
}
