{ pkgs, ... }:

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
    ];
  };
}
