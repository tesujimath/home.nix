{ config, pkgs, lib, ... }:

{
  imports = [
    ./common-packages.nix
    ./modules/bash.nix
    ./modules/helix.nix
    ./modules/nushell
    ./modules/tmux.nix
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
        # these should be the defaults in the test SQL server builder in server repo
        SQLSERVER_MAIN_SERVER = "localhost";
        SQLSERVER_MAIN_USERNAME = "sa";
        # SQLSERVER_MAIN_PASSWORD from 1Password via secrets.nix

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

    my.lsp = {
      rust.enable = true;
      go.enable = true;
      python.enable = true;
      json.enable = true;
      dockerfile.enable = true;
    };

    xdg.mimeApps = {
      enable = true;
    };
  };
}
