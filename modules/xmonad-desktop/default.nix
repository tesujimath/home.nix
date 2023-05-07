{ pkgs, ... }:

with pkgs;
let
  xmonad-with-ghc = haskellPackages.ghcWithPackages (pkgs: [pkgs.xmonad pkgs.xmonad-extras pkgs.xmonad-contrib]);
in
{
  home.packages = [
    xmonad-with-ghc
    arandr
    blueman
    cantarell-fonts
    dmenu
    dunst
    gnome.seahorse
    handlr
    libnotify
    libsecret
    networkmanagerapplet
    nushell
    pasystray
    pulseaudio
    scrot
    skippy-xd
    sxiv
    tmux
    trayer
    udiskie
    volnoti
    xmobar
    xorg.xmodmap
    xscreensaver
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

  services.blueman-applet.enable = true;

  programs.alacritty = {
    enable = true;
    # see https://github.com/alacritty/alacritty/blob/master/alacritty.yml
    settings = {
      font = {
        normal = {
          family = "Source Code Pro";
        };
      };
    };
  };
}
