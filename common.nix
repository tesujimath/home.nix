{ config, lib, ... }:

with lib;
{
  imports = [
    ./common-packages.nix
    ./modules/bash.nix
    ./modules/elvish
    ./modules/helix.nix
    ./modules/lsp.nix
    ./modules/mitmproxy
    ./modules/nushell
    ./modules/xdg.nix
    ./modules/yazi
    ./modules/zathura.nix
    ./modules/zellij.nix
  ];

  options.local.defaultShell = mkOption { default = "bash"; type = types.str; description = "Default shell"; };
  options.local.defaultEditor = mkOption { default = "vi"; type = types.str; description = "Default editor"; };

  config = {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (pkg: true);
      };

      overlays = [
        (import ./overlays/volnoti.nix)
      ];
    };

    home = {
      sessionVariables = {
        # make virsh use system connection as per virt-manager
        LIBVIRT_DEFAULT_URI = "qemu:///system";
      };

      file = {
        ".dircolors".source = ./dotfiles/dircolors;
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

    local.lsp = {
      rust.enable = true;
      go.enable = true;
      python.enable = true;
      json.enable = true;
      dockerfile.enable = true;
    };
  };
}
