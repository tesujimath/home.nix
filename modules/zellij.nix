{ config, lib, ... }:

let
  cfg = config.local.zellij;
  inherit (lib) mkEnableOption mkIf mkOption;
in
{
  options.local.zellij = {
    enable = mkEnableOption "zellij";
    mouse_mode = mkOption {
      type = lib.types.bool;
      description = "Enable mouse_mode";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs = {
      zellij = {
        enable = true;
        settings = {
          default_shell = config.local.defaultShell;
          scrollback_editor = config.local.defaultEditor;
          mouse_mode = cfg.mouse_mode;

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
                    "Ctrl q" # disable sudden death from Ctrl q
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

              "shared_except \"locked\"" = layer
                {
                  unbinds = [
                    "Ctrl q" # disable sudden death from Ctrl q
                    # Elvish:
                    "Alt l" # Directory history
                    "Alt n" # Navigation mode
                    "Alt f" # Filter in Navigation mode
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
