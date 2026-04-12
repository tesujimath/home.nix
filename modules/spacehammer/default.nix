{ config, lib, pkgs, ... }:

let
  cfg = config.local.spacehammer;
  inherit (lib) mkEnableOption mkIf;
in
{
  options. local. spacehammer = {
    enable = mkEnableOption "spacehammer";
  };

  config = mkIf cfg.enable {
    # requires hammerspoon cask to have been installed in nix-darwin

    home =
      let
        lua = pkgs.lua5_4;
        fennel = pkgs.lua54Packages.fennel;
      in
      {
        packages = [
          fennel
        ];

        file = {
          # make Fennel available to Hammerspoon
          # this is a bit of a hack, we symlink it in as if it had been installed as a Lua Rock,
          # but that's one place Hammerspoon looks for requires
          ".luarocks/share/lua/${lua.luaversion}/fennel.lua".source = "${fennel}/share/lua/${lua.luaversion}/fennel.lua";

          ".hammerspoon".source =
            pkgs.fetchFromGitHub {
              owner = "agzam";
              repo = "spacehammer";
              rev = "0725fa69e94d397b542e303cc8c774a0d7d5d5ab";
              sha256 = "sha256-joFelJ4K+dehF3HHP5eF2RshG29KP5iCpzPVstMey+o=";
            };

          ".spacehammer/config.fnl".source = ./config.fnl;
        };
      };
  };
}
