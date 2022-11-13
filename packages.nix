{ pkgs, ... }:

{
  # currently a big dump of what I had in nix-env
  home.packages = [
    pkgs._1password
    pkgs.audacious
    pkgs.bind
    #pkgs.discord
    pkgs.du-dust
    pkgs.emacs
    pkgs.file
    pkgs.firefox
    pkgs.freerdp
    #pkgs.gh
    pkgs.gimp
    pkgs.git
    pkgs.git-imerge
    #pkgs.go
    pkgs.gzip
    pkgs.htop
    pkgs.aspell
    pkgs.aspellDicts.en
    pkgs.aspellDicts.en-computers
    pkgs.aspellDicts.en-science
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
    pkgs.python3
    pkgs.ripgrep
    #pkgs.skippy-xd-git
    #pkgs.stack
    pkgs.slack
    pkgs.speedcrunch
    #pkgs.steam-run
    pkgs.stow  # for install-dotfiles for now
    pkgs.sxiv
    pkgs.unzip
    pkgs.vscode
    pkgs.wget
    pkgs.xclip
    pkgs.xdragon
    pkgs.yarn
    pkgs.zathura
    pkgs.zoom-us
  ];
}
