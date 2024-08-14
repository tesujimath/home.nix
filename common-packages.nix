{ pkgs, specialArgs, ... }:

with specialArgs; # for flakePkgs
with pkgs;
{
  config = {
    home.packages = [
      amber # CLI search/replace
      bottom
      diskonaut
      dig
      du-dust
      fd
      file
      fx
      gzip
      htop
      jq
      mosh
      nix-index
      nixos-option
      nmap
      pstree
      ripgrep
      speedcrunch
      unzip
      virtualenv # better than python -m venv because supports Nu
      wget

      # packages we get from flakes
      flakePkgs.eza
      flakePkgs.nix_search_cli
    ];
  };
}
