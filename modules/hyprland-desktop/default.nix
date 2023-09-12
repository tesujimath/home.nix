{ pkgs, ... }:

with pkgs;
let
  xmonad-with-ghc = haskellPackages.ghcWithPackages (pkgs: [pkgs.xmonad pkgs.xmonad-extras pkgs.xmonad-contrib]);
in
{
  home.packages = [
    hyprland
    bemenu        # replaces dmenu
    waybar        # replaces xmobar, trayer
    swaylock      # replaces xscreensaver
    way-displays  # replaces autorandr

    # common
    blueman
    cantarell-fonts
    dunst
    gnome.seahorse
    handlr
    libnotify
    libsecret
    networkmanagerapplet # wayland compatible?
    pasystray
    pulseaudio
    udiskie

    # TODO list
    #arandr
    #autorandr
    #scrot
    #skippy-xd
    #sxiv
    #trayer
    #volnoti
  ];

  home.file = {
    #".xsession".source = ./dotfiles/xsession;

    ".hyprland-desktop-scripts" = {
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

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod SHIFT, return, exec, alacritty"
        "$mod, O, exec, bemenu"
      ];
    };
  };

  home.sessionVariables = {
    # Hint electron apps to use wayland:
    NIXOS_OZONE_WL = "1";
  };
}
