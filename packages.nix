{ pkgs, ... }:

{
  # currently a big dump of what I had in nix-env
  home.packages = [
    pkgs._1password
    pkgs.bind
    #pkgs.discord
    pkgs.dragon-drop
    pkgs.du-dust
    pkgs.emacs
    pkgs.file
    pkgs.firefox
    pkgs.freerdp
    #pkgs.gh
    pkgs.git
    #pkgs.go
    pkgs.gzip
    pkgs.htop
    pkgs.hunspell
    pkgs.hunspellDicts.en-gb-large
    pkgs.ijq
    pkgs.jo
    pkgs.jq
    pkgs.mimeo
    pkgs.nix-index
    pkgs.nmap
    pkgs.nodejs
    pkgs.pavucontrol
    #pkgs.postman
    #pkgs.powershell
    #pkgs.pstree
    #pkgs.python3.8-pip
    pkgs.ripgrep
    #pkgs.skippy-xd-git
    #pkgs.stack
    #pkgs.steam-run
    pkgs.sxiv
    pkgs.unzip
    pkgs.vscode
    pkgs.wget
    pkgs.xclip
    pkgs.yarn
    pkgs.zathura
    pkgs.zoom-us
  ];
}
