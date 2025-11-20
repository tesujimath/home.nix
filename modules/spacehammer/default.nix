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
              # TODO revert to mainline once path issue fixed:
              # owner = "agzam";
              owner = "tesujimath";
              repo = "spacehammer";
              rev = "4d404a708a42d665260affd03f7c3ca4626d54d2";
              sha256 = "sha256-cH5E1qhKsbLSP+a4+7pR7i7Trtvn2+y4rL+aX/USLVI=";
            };

          ".spacehammer/config.fnl".source = ./config.fnl;
        };
      };
  };
}
