{ pkgs, ... }:

let
  xmonad-with-ghc = pkgs.haskellPackages.ghcWithPackages (pkgs: [pkgs.xmonad pkgs.xmonad-extras pkgs.xmonad-contrib]);
in
{
  home.packages = [
    xmonad-with-ghc
    pkgs.arandr
    pkgs.cantarell-fonts
    pkgs.dmenu
    pkgs.dunst
    pkgs.gnome3.gnome-terminal
    pkgs.gnome.seahorse
    pkgs.libnotify
    pkgs.libsecret
    pkgs.light
    pkgs.networkmanagerapplet
    pkgs.pasystray
    pkgs.scrot
    pkgs.skippy-xd
    pkgs.sxiv
    pkgs.termonad-with-packages
    pkgs.trayer
    pkgs.udiskie
    pkgs.xmobar
    pkgs.xorg.xmodmap
    pkgs.xscreensaver
  ];

  home.file = {
    ".xsession".source = ./dotfiles/xsession;

    # TODO install desktop version on desktops
    ".xmobarrc".source = ./dotfiles/xmobarrc.laptop;

    ".xmonad/xmonad.hs".source = ./dotfiles/xmonad.hs;

    ".config/skippy-xd/skippy-xd.rc".source = ./dotfiles/skippy-xd.rc;

    ".xmonad-desktop-scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };
}
