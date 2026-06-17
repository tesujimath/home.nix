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

    home =
      let
        # requires Hammerspoon cask to have been installed in nix-darwin using same Lua version
        lua = pkgs.lua5_4;
        fennel = lua.pkgs.fennel;

        jeejah = pkgs.callPackage ./jeejah.nix
          {
            inherit lua fennel;
            inherit (lua.pkgs) buildLuaPackage luacheck luaOlder luasocket;
          };

        luaWithPackages = lua.withPackages (ps: with ps; [
          fennel
          luasocket
          readline
          jeejah
        ]);

        # Make required packages available to Hammerspoon via local site packages.
        # This is a bit of a hack.  We're using Hammerspoon's own lua, but bringing our
        # own packages.  If only Hammerspoon were packaged in Nix. 😩
        hammerspoonSitePackages = pkgs.stdenv.mkDerivation {
          name = "hammerspoon-site-packages";
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p $out/lib
            ln -s ${luaWithPackages}/share/lua/${lua.luaversion}/* $out
            ln -s ${luaWithPackages}/lib/lua/${lua.luaversion}/* $out/lib
          '';
        };
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

          ".local/share/hammerspoon/site".source = "${hammerspoonSitePackages}";
        };
      };
  };
}
