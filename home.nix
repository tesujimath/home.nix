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

  imports = [
    ./modules/ep-dev-backend
    ./modules/xmonad-desktop
    ./packages.nix
    ./secrets.nix
  ];

  nixpkgs.overlays = [
    (import ./overlays/rider.nix)
  ];

  home.sessionVariables = {
   SIMONS_HOME_MANAGER_VARIABLE = "hello Nix Home Manager world!";
  };
}
