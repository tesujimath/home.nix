{ config, pkgs, lib, ... }:

{
  options.my.elvish = {
    home_manager_flake_uri = lib.mkOption { default = "path:/UNSET"; type = lib.types.str; description = "URI for Home Manager flake for this system"; };
  };

  config = {
    home = {
      packages = with pkgs; [
        elvish
      ];

      file = {
        ".config/elvish/rc.elv".text = (builtins.replaceStrings [
          "HOME_MANAGER_FLAKE_URI"
        ] [
          config.my.elvish.home_manager_flake_uri
        ] (builtins.readFile ./rc.elv));

        ".local/share/elvish/lib/direnv.elv".source = ./direnv.elv;
      };
    };
  };
}
