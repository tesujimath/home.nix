{ options, config, pkgs, lib, ... }:

with pkgs;
{
  config = {
    programs = {
      tmux = {
        enable = true;
        shell = "${pkgs.nushellFull}/bin/nu";
        };
      };
  };
}
