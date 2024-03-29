{ pkgs, ... }:

with pkgs;
{
  # currently a big dump of what I had in nix-env
  home.packages = [
    _1password
    audacious
    bind
    #discord
    du-dust
    file
    firefox
    freerdp
    #gh
    gimp
    git
    git-crypt
    git-imerge
    #go
    gzip
    htop
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    ijq
    jo
    jq
    mimeo
    nix-index
    nixos-option
    nmap
    nodejs
    pavucontrol
    #postman
    #powershell
    pstree
    python3
    ripgrep
    #skippy-xd-git
    #stack
    slack
    speedcrunch
    #steam-run
    stow  # for install-dotfiles for now
    sxiv
    unison
    unzip
    virtualenv # better than python -m venv because supports Nu
    vscode
    wget
    xclip
    xdragon
    yarn
    zoom-us
  ];
}
