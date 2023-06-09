{ config, pkgs, ... }:

with pkgs;
{
  config = {
    programs = {
      zellij = {
        enable = true;
        settings = {
          scrollback_editor = "${pkgs.helix}/bin/hx";
        };
      };
    };
  };
}
