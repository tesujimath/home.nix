{ config, lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  imports = [
    ./common-packages.nix
    ./modules/babashka.nix
    ./modules/bash.nix
    ./modules/carapace.nix
    ./modules/elvish
    ./modules/emacs.nix
    ./modules/fish
    ./modules/fonts.nix
    ./modules/git
    ./modules/guile
    ./modules/helix.nix
    ./modules/jujutsu
    ./modules/ledger
    ./modules/languages
    ./modules/mitmproxy
    ./modules/nushell
    ./modules/syncthing.nix
    ./modules/web-browser.nix
    ./modules/wezterm
    ./modules/xdg.nix
    ./modules/xmonad-desktop
    ./modules/yazi
    ./modules/zathura.nix
    ./modules/zellij.nix
  ];

  options.local.defaultShell = mkOption { default = "bash"; type = types.str; description = "Default shell"; };
  options.local.defaultEditor = mkOption { default = "vi"; type = types.str; description = "Default editor"; };
  options.local.user =
    {
      email = mkOption { type = types.str; description = "Email address"; };
      fullName = mkOption { type = types.str; description = "Full name"; };
    };

  config = {
    home = {
      sessionPath = [
        "$HOME/bin"
        "$HOME/scripts"
      ];

      sessionVariables = {
        EMAIL = config.local.user.email;

        # make virsh use system connection as per virt-manager
        LIBVIRT_DEFAULT_URI = "qemu:///system";

        # never use managed Python from uv
        UV_NO_MANAGED_PYTHON = "1";
        UV_PYTHON_DOWNLOADS = "never";
      };

      file = {
        ".dircolors".source = ./config/dotfiles/dircolors;
      };
    };

    programs = {
      # Let Home Manager install and manage itself.
      home-manager.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    # additional docs, access via home-manager-help command
    manual.html.enable = true;
  };
}
