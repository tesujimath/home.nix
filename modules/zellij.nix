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
              unbinder = keys:
                let
                  argKeys = map (k: "\"${k}\"") (lib.lists.flatten [ keys ]);
                in
                {
                  name = "unbind ${concatStringsSep " " argKeys}";
                  value = [ ];
                };
              layer = { binds ? [ ], unbinds ? [ ] }:
                (listToAttrs (map binder binds)) //
                (listToAttrs (map unbinder unbinds));
            in
            {
              normal = layer
                {
                  unbinds = [
                    # Elvish:
                    # "Alt l" # Directory history
                    "Alt n" # Navigation mode
                  ];
                };

              # Allow for navigating tabs when Zellij is locked;  great solution to Helix/Zellij conflicts.
              # See https://github.com/helix-editor/helix/discussions/8537#discussioncomment-8370297
              shared = layer {
                binds = [
                  [ [ "Alt Left" ] { MoveFocusOrTab = "Left"; } ]
                  [ [ "Alt Right" ] { MoveFocusOrTab = "Right"; } ]
                  [ [ "Alt Down" ] { MoveFocus = "Down"; } ]
                  [ [ "Alt Up" ] { MoveFocus = "Up"; } ]
                  [ [ "Alt m" ] { ToggleFloatingPanes = [ ]; } ]
                ];
              };
            } // layer {
              unbinds = [
                "Ctrl q" # disable sudden death from Ctrl q

                # Elvish:
                "Alt l" # Directory history
                "Alt f" # Filter in Navigation mode
              ];
            };
        };
      };
    };
  };
}
