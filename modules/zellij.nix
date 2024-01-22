{ config, pkgs, ... }:

with pkgs;
{
  config = {
    programs = {
      zellij = {
        enable = true;
        settings = {
          default_shell = "nu";
          scrollback_editor = "${pkgs.helix}/bin/hx";
          mouse_mode = false;
        };
      };
    };
  };
}
