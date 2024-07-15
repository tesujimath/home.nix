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
      activation =
        let
          elvish-package = url: lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            run ${pkgs.elvish}/bin/elvish -c "use epm; epm:install &silent-if-installed=\$true ${url}; epm:upgrade ${url}"
          '';
        in
        {
          elvish-modules = elvish-package "github.com/zzamboni/elvish-modules";

          rivendell = elvish-package "github.com/crinklywrappr/rivendell";

          bash-env-elvish = elvish-package "github.com/tesujimath/bash-env-elvish";
        };
    };

    xdg = {
      configFile = {
        "elvish/rc.elv".source = ./rc.elv;
      };

      dataFile = {
        "elvish/lib/direnv.elv".text = ''
          ## hook for direnv
          set @edit:before-readline = $@edit:before-readline {
            try {
              var m = [(${pkgs.direnv}/bin/direnv export elvish | from-json)]
              if (> (count $m) 0) {
                set m = (all $m)
                keys $m | each { |k|
                  if $m[$k] {
                    set-env $k $m[$k]
                  } else {
                    unset-env $k
                  }
                }
              }
            } catch e {
              echo $e
            }
          }
        '';
      };
    };
  };
}
