{ config, pkgs, ... }:

with pkgs;
{
  config = {
    programs = {
      zellij = {
        enable = true;
        settings = {
          default_shell = "nu";
          scrollback_editor = "${pkgs.helix}/bin/hx";
          mouse_mode = true;

          # See https://git.lyte.dev/lytedev-divvy/nix/src/branch/main/modules/home-manager/zellij.nix
          keybinds = with builtins; let
            binder = bind: let
              keys = elemAt bind 0;
              action = elemAt bind 1;
              argKeys = map (k: "\"${k}\"") (lib.lists.flatten [keys]);
            in {
              name = "bind ${concatStringsSep " " argKeys}";
              value = action;
            };
            layer = binds: (listToAttrs (map binder binds));
          in {
            # disable sudden death from Ctrl q
            unbind = "Ctrl q";

            # Allow for navigating tabs when Zellij is locked;  great solution to Helix/Zellij conflicts.
            # See https://github.com/helix-editor/helix/discussions/8537#discussioncomment-8370297
            shared  = layer [
              [["Alt h" "Alt Left"] { MoveFocusOrTab = "Left"; }]
              [["Alt l" "Alt Right"] { MoveFocusOrTab = "Right"; }]
              [["Alt j" "Alt Down"] { MoveFocus = "Down"; }]
              [["Alt k" "Alt Up"] { MoveFocus = "Up"; }]
              [["Alt m"] { ToggleFloatingPanes = []; }]
            ];
          };
        };
      };
    };
  };
}
