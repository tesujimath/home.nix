{ pkgs, ... }:

with pkgs;
let
  xmonad-with-ghc = haskellPackages.ghcWithPackages (pkgs: [pkgs.xmonad pkgs.xmonad-extras pkgs.xmonad-contrib]);
in
{
  home.packages = [
    xmonad-with-ghc
    arandr
    autorandr
    blueman
    cantarell-fonts
    dmenu
    dunst
    gnome.seahorse
    handlr
    libnotify
    libsecret
    networkmanagerapplet
    pasystray
    pavucontrol
    pulseaudio
    scrot
    skippy-xd
    sxiv
    udiskie
    ueberzugpp # for yazi image preview in alacritty
    volnoti
    xclip
    xdragon
    xmobar
    xorg.xmodmap
    xscreensaver
  ];

  home.file = {
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
  services.trayer.enable = true;

  xsession = {
    enable = true;

    windowManager = {
      command = "${xmonad-with-ghc}/bin/xmonad";
    };

    initExtra = ''
      PATH=$HOME/.xmonad-desktop-scripts:$PATH

      test -r $HOME/.env.sh && . $HOME/.env.sh
      env >> $HOME/.xsession-errors

      test -r .Xresources && xrdb -merge .Xresources

      xsetroot -solid gray30

      restart-trayer

      xscreensaver -no-splash &

      dunst -config ~/.dunstrc &

      # GNOME keyring daemon is started at the system level, for integration with PAM,
      # but we need to enable the components we need here, to get ssh.
      eval $(gnome-keyring-daemon -s -c ssh,secrets)
      export SSH_AUTH_SOCK

      nm-applet &

      blueman-applet &

      udiskie --tray &

      volnoti -t 2

      pasystray &

      # for xmonad
      export NIX_GHC="${xmonad-with-ghc}/bin/ghc"
    '';
  };

  programs.alacritty = {
    enable = true;
    # see https://alacritty.org/config-alacritty.html
    settings = {
      font = {
        normal = {
          family = "Source Code Pro";
        };
      };
      shell = "nu";
    };
  };

  xdg.mimeApps = {
    defaultApplications = {
      "image/*" = ["sxiv.desktop"];
    };
  };
}
