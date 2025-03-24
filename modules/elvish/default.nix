{ config, pkgs, lib, specialArgs, ... }:

let
  cfg = config.local.elvish;
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (specialArgs) flakePkgs;
in
{
  options. local. elvish = {
    enable = mkEnableOption "elvish";

    rcExtra = mkOption { type = types.str; default = ""; description = "Extra text for rc.elv"; };
  };

  config = mkIf cfg.enable {
    home =
      let
        elvish-with-packages = flakePkgs.elvish.withPackages (ps: with ps; [
          bash-env-elvish
          elvish-tap
          direlv
          rivendell
          zzamboni-elvish-modules
        ]);
      in
      {
        packages = [
          elvish-with-packages
          flakePkgs.bash-env-json
        ];
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
  };
}
