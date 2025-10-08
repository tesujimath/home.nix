{ config, pkgs, lib, specialArgs, ... }:

let
  cfg = config.local.elvish;
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (specialArgs) flakePkgs;
in
{
  options.local.elvish = {
    enable = mkEnableOption "elvish";

    rcExtra = mkOption { type = types.str; default = ""; description = "Extra text for rc.elv"; };
  };

  config = mkIf cfg.enable {
    home =
      let
        elvish_0_21_0 =
          let
            version = "0.21.0";

            src = pkgs.fetchFromGitHub {
              owner = "elves";
              repo = "elvish";
              rev = "v${version}";
              hash = "sha256-+qkr0ziHWs3MVhBoqAxrwwbsQVvmGHRKrlqiujqBKvs=";
            };
          in
          pkgs.elvish.override {
            buildGoModule = args: pkgs.buildGoModule (args // {
              inherit src version;
              vendorHash = "sha256-UjX1P8v97Mi5cLWv3n7pmxgnw+wCr4aRTHDHHd/9+Lo=";
            });
          };
      in
      {
        packages = [
          # elvish_0_21_0
          pkgs.elvish
          flakePkgs.bash-env-json
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

            elvish-tap = elvish-package "github.com/tesujimath/elvish-tap";

            direlv = elvish-package "github.com/tesujimath/direlv";
          };
      };

    xdg = {
      configFile = {
        "elvish/rc.elv".text = (builtins.readFile ./rc.elv)
          + (if cfg.rcExtra == "" then "" else "\n")
          + cfg.rcExtra;
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

    services.pueue.enable = true;
  };
}
