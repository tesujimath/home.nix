{ config, lib, ... }:
let
  cfg = config.tesujimath.yazi;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.tesujimath.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    programs = {
      yazi = {
        enable = true;
        enableBashIntegration = config.tesujimath.bash.enable;
        shellWrapperName = "y";
        settings = {
          mgr = {
            ratio = [ 1 2 5 ];
          };
        };

        keymap = {
          input = {
            prepend_keymap = [
              # https://yazi-rs.github.io/docs/tips#close-input-by-esc
              {
                on = [ "<Esc>" ];
                run = "close";
                desc = "Cancel input";
              }
            ];
          };

          mgr = {
            prepend_keymap = [
              # https://yazi-rs.github.io/docs/tips#dropping-to-shell
              {
                on = [ "<C-s>" ];
                run = "shell ${config.tesujimath.defaultShell} --block --confirm";
                desc = "Open default shell here";
              }
            ];
          };
        };
      };
    };
  };
}
