{ pkgs, ... }:

{
  config = {
    home.packages =
      with pkgs;
      [
        amber # CLI search/replace
        bottom
        dig
        du-dust
        eza
        fd
        file
        fx
        gzip
        htop
        ijq
        jq
        jqp
        nix-index
        nix-search-cli
        nixos-option
        nmap
        pstree
        ripgrep
        sd
        speedcrunch
        unzip
        virtualenv # better than python -m venv because supports Nu
        wget
      ];
  };
}
