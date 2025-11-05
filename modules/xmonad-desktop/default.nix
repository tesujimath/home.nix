{ config, pkgs, lib, specialArgs, ... }:

let
  cfg = config.local.xmonad-desktop;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.xmonad-desktop = {
    enable = mkEnableOption "xmonad-desktop";
  };

  config = mkIf cfg.enable (
    let
      xmonad-with-ghc = pkgs.haskellPackages.ghcWithPackages (pkgs: [ pkgs.xmonad pkgs.xmonad-extras pkgs.xmonad-contrib ]);
    in
    {
      home.packages =
        let
          inherit (specialArgs) localPkgs;
        in
        with pkgs;
        [
          xmonad-with-ghc
          arandr
          autorandr
          blueman
          dmenu
          dunst
          # seahorse not in NixOS 24.05
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
          localPkgs.volnoti
          xclip
          xdragon
          xmobar
          xorg.xmodmap
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

          # it seems we no longer need to explicitly start this,
          # I'm unsure who starts it, but if we do here we'll get two of these varmints
          #pasystray &

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
              family = "monospace";
            };
          };
          window = {
            padding = {
              x = 6;
              y = 6;
            };
          };
          terminal.shell = config.local.defaultShell;
        };
      };

      services = {
        blueman-applet.enable = true;

        trayer.enable = true;

        xscreensaver.enable = true;
      };

      xdg.mimeApps = {
        defaultApplications = {
          "image/*" = [ "sxiv.desktop" ];
        };
      };
    }
  );
}
