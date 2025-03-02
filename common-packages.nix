{ pkgs, ... }:

{
  config = {
    home.packages =
      with pkgs;
      [
        amber # CLI search/replace
        bottom
        diskonaut
        dig
        du-dust
        eza
        fd
        file
        fx
        gzip
        htop
        jq
        nix-index
        nix-search-cli
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
