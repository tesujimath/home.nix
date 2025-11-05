{ config, lib, ... }:

let
  cfg = config.local.tmux;
  inherit (lib) mkEnableOption mkIf mkOption;
in
{
  options.local.tmux = {
    enable = mkEnableOption "tmux";
    mouse = mkOption {
      type = lib.types.bool;
      description = "Enable mouse support";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs = {
      tmux = {
        enable = true;
        shell = config.local.defaultShellPath;
        mouse = cfg.mouse;
        extraConfig = ''
          # Preferred editor
          set -s editor ${config.local.defaultEditor}
 
          # Don't wait after escape, send it through to the terminal application immediately
          set -s escape-time 0

          # Make the status bar always visible
          set -g status on

          # Set the status bar background and foreground
          set -g status-bg colour234   # dark background
          set -g status-fg colour136   # text color

          # Make current window stand out
          setw -g window-status-current-format " #[bold]#[fg=colour82]#I:#W#[default] "
          setw -g window-status-current-style "bg=colour235 fg=colour82 bold"

          # Inactive windows
          setw -g window-status-format " #[fg=colour244]#I:#W#[default] "

          # Optional: separators
          set -g status-left-length 20
          set -g status-right-length 140
          set -g status-left " #[fg=colour33,bold]#S #[default] "
          set -g status-right " #[fg=colour244]%Y-%m-%d %H:%M #[default] "

          # Enable 256-color and true-color (24-bit) support
          set -g default-terminal "tmux-256color"
          set -ga terminal-overrides ",*:Tc"

          # Ensure modern extended underline styles are passed through
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
          set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

          # ensure new window panes open in the same directory
          bind '"' split-window -v -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"
          bind c new-window -c "#{pane_current_path}"
        '';
      };
    };
  };
}
