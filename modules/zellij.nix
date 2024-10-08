{ config, lib, ... }:

let
  cfg = config.local.zellij;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.zellij = {
    enable = mkEnableOption "zellij";
  };

  config = mkIf cfg.enable {
    programs = {
      zellij = {
        enable = true;
        settings = {
          default_shell = config.local.defaultShell;
          scrollback_editor = config.local.defaultEditor;
          mouse_mode = true;

          # See https://git.lyte.dev/lytedev-divvy/nix/src/branch/main/modules/home-manager/zellij.nix
          keybinds =
            let
              inherit (builtins) concatStringsSep elemAt listToAttrs;
              binder = bind:
                let
                  keys = elemAt bind 0;
                  action = elemAt bind 1;
                  argKeys = map (k: "\"${k}\"") (lib.lists.flatten [ keys ]);
                in
                {
                  name = "bind ${concatStringsSep " " argKeys}";
                  value = action;
                };
              layer = binds: (listToAttrs (map binder binds));
            in
            {
              # disable sudden death from Ctrl q
              unbind = "Ctrl q";

              normal = {
                unbind = "Alt l";
              };
              # Elvish uses Alt-L etc with readline bindings
              # but to unbind all these I would need to write an unbinds function
              #unbind = "Alt h";
              #unbind = "Alt j";
              #unbind = "Alt k";
              #unbind = "Alt l";

              # Allow for navigating tabs when Zellij is locked;  great solution to Helix/Zellij conflicts.
              # See https://github.com/helix-editor/helix/discussions/8537#discussioncomment-8370297
              shared = layer [
                [ [ "Alt Left" ] { MoveFocusOrTab = "Left"; } ]
                [ [ "Alt Right" ] { MoveFocusOrTab = "Right"; } ]
                [ [ "Alt Down" ] { MoveFocus = "Down"; } ]
                [ [ "Alt Up" ] { MoveFocus = "Up"; } ]
                [ [ "Alt m" ] { ToggleFloatingPanes = [ ]; } ]
              ];
            };
        };
      };
    };
  };
}
