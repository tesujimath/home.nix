{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import ./overlays/rider.nix)
  ];

  home.sessionVariables = {
    # these should be the defaults in the test SQL server builder in server repo
    SQLSERVER_MAIN_SERVER = "localhost";
    SQLSERVER_MAIN_USERNAME = "sa";
    # SQLSERVER_MAIN_PASSWORD from 1Password via secrets.nix
  };
}
