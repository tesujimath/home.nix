{ config, pkgs, ... }:

{
  imports = [
    ./modules/bash.nix
    ./modules/zathura.nix
    ];

  config = {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # additional docs, access via home-manager-help command
    manual.html.enable = true;

    #nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = (pkg: true);

    nixpkgs.overlays = [
      (import ./overlays/rider.nix)
      (import ./overlays/volnoti.nix)
    ];

    home.sessionVariables = {
      # these should be the defaults in the test SQL server builder in server repo
      SQLSERVER_MAIN_SERVER = "localhost";
      SQLSERVER_MAIN_USERNAME = "sa";
      # SQLSERVER_MAIN_PASSWORD from 1Password via secrets.nix

      # make virsh use system connection as per virt-manager
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    home.file = {
      ".dircolors".source = ./dotfiles/dircolors;
    };
  };
}
