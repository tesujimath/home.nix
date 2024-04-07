{ pkgs, ... }:

with pkgs;
{
  config = {
    home.packages = [
      amber # CLI search/replace
      bottom
      dig
      du-dust
      fd
      file
      git
      gzip
      htop
      jq
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
