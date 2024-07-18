{ config, pkgs, lib, specialArgs, ... }:

with specialArgs; # for flakePkgs
{
  imports = [
    ./common-packages.nix
    ./modules/bash.nix
    ./modules/elvish
    ./modules/helix.nix
    ./modules/mitmproxy
    ./modules/nushell
    ./modules/tmux.nix
    ./modules/xdg.nix
    ./modules/yazi
    ./modules/zathura.nix
    ./modules/zellij.nix
  ];

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

      packages = [
        flakePkgs.eza
        flakePkgs.nix_search
      ];
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
