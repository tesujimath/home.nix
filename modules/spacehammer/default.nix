{ config, lib, pkgs, ... }:

let
  cfg = config.tesujimath.spacehammer;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.tesujimath.spacehammer = {
    enable = mkEnableOption "spacehammer";
  };

  config = mkIf cfg.enable {

    home =
      let
        # requires Hammerspoon cask to have been installed in nix-darwin using same Lua version
        lua = pkgs.lua5_4;
        fennel = lua.pkgs.fennel;
      in
      {
        file = {
          ".hammerspoon".source =
            pkgs.fetchFromGitHub {
              owner = "agzam";
              repo = "spacehammer";
              rev = "0725fa69e94d397b542e303cc8c774a0d7d5d5ab";
              sha256 = "sha256-joFelJ4K+dehF3HHP5eF2RshG29KP5iCpzPVstMey+o=";
            };

          ".spacehammer/config.fnl".source = ./config.fnl;

          ".local/share/hammerspoon/site/fennel.lua".source = "${fennel}/share/lua/${lua.luaversion}/fennel.lua";
        };
      };
  };
}
