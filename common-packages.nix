{ pkgs, specialArgs, ... }:

{
  config = {
    home.packages =
      let
        inherit (specialArgs) flakePkgs;
      in
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
        mosh
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

        # packages we get from flakes
        # none for now, yay!
      ];
  };
}
