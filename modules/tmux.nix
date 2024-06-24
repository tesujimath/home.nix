{ options, config, pkgs, lib, ... }:

with pkgs;
{
  config = {
    programs = {
      tmux = {
        enable = true;
        shell = "${pkgs.nushell}/bin/nu";
        };
      };
  };
}
