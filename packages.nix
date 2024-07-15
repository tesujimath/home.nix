{ pkgs, ... }:

with pkgs;
{
  # currently a big dump of what I had in nix-env
  home.packages = [
    _1password
    audacious
    bind
    #discord
    freerdp
    fx
    #gh
    gimp
    git-crypt
    git-imerge
    #go
    ijq
    jo
    nodejs
    #postman
    #powershell
    python3
    #skippy-xd-git
    #stack
    slack
    #steam-run
    stow # for install-dotfiles for now
    unison
    vscode
    yarn
    zoom-us
  ];
}
