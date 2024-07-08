{ config, pkgs, lib, specialArgs, ... }:

with specialArgs; # for flakePkgs
{
  config = {
    home = {
      packages = with pkgs; [
        elvish
        flakePkgs.bash_env_elvish
      ];

      # epm package installation
      activation = let
        elvish-package = url: lib.hm.dag.entryAfter ["writeBoundary"] ''
          run ${pkgs.elvish}/bin/elvish -c "use epm; epm:install &silent-if-installed=\$true ${url}; epm:upgrade ${url}"
        '';
      in
        {
          elvish-modules = elvish-package "github.com/zzamboni/elvish-modules";

          rivendell = elvish-package "github.com/crinklywrappr/rivendell";

          bash-env = elvish-package "github.com/tesujimath/bash-env-elvish";
        };
    };

    xdg = {
      configFile = {
        "elvish/rc.elv".text = (builtins.readFile ./rc.elv);
      };

      dataFile = {
        "elvish/lib/direnv.elv".source = ./direnv.elv;
      };
    };
  };
}
