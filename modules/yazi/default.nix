{ config, pkgs, ... }:
{
  config = {
    programs = {
      yazi = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        settings = {
          manager = {
            ratio = [1 2 5];
          };
        };

        keymap = {
          input = {
            prepend_keymap = [
              # https://yazi-rs.github.io/docs/tips#close-input-by-esc
              {
                on   = [ "<Esc>" ];
                run  = "close";
                desc = "Cancel input";
              }
            ];
          };

          manager = {
            prepend_keymap = [
              # https://yazi-rs.github.io/docs/tips#dropping-to-shell
              {
                on   = [ "<C-s>" ];
                run  = "shell nu --block --confirm";
                desc = "Open Nushell here";
              }

              # https://yazi-rs.github.io/docs/tips#smart-enter
              # also needs smart-enter plugin, below
              {
                on   = [ "<Enter>" ];
                run  = "plugin --sync smart-enter";
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
