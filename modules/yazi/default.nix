{ config, lib, ... }:
let
  cfg = config.local.yazi;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    programs = {
      yazi = {
        enable = true;
        enableBashIntegration = config.local.bash.enable;
        enableNushellIntegration = config.local.nushell.enable;
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
                run = "shell ${config.local.defaultShell} --block --confirm";
                desc = "Open default shell here";
              }

              # https://yazi-rs.github.io/docs/tips#smart-enter
              # also needs smart-enter plugin, below
              {
                on = [ "<Enter>" ];
                run = "plugin --sync smart-enter";
                desc = "Enter the child directory, or open the file";
              }
            ];
          };
        };
      };
    };

    home.file = {
      # https://yazi-rs.github.io/docs/tips#smart-enter
      ".config/yazi/plugins/smart-enter.yazi/init.lua".text = ''
        return {
          entry = function()
            local h = cx.active.current.hovered
            ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
          end
        }
      '';
    };
  };
}
