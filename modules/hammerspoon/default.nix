{ config, lib, pkgs, ... }:

let
  cfg = config.local.hammerspoon;
  inherit (lib) mkEnableOption mkIf;
in
{
  options. local. hammerspoon = {
    enable = mkEnableOption "hammerspoon";
  };

  config = mkIf cfg.enable {
    # requires hammerspoon cask to have been installed in nix-darwin

    home = {
      packages = with pkgs; [
        fennel
      ];

      file = {
        ".hammerspoon/init.lua".source = ./init.lua;
        ".hammerspoon/init.fnl".source = ./init.fnl;

        # make Fennel available to Hammerspoon
        ".hammerspoon/fennel.lua".source = "${pkgs.fennel}/share/lua/${pkgs.lua.luaversion}/fennel.lua";

        ".hammerspoon/fnl" = {
          source = ./fnl;
          recursive = true;
        };
      };
    };
  };
}
