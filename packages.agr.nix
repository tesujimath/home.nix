{ pkgs, ... }:

with pkgs;
{
  # currently a big dump of what I had in nix-env
  home.packages = [
    beekeeper-studio
    dig
    du-dust
    emacs
    file
    git
    gzip
    helix
    htop
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    ijq
    jo
    jq
    nix-index
    nixos-option
    nmap
    #openssh_gssapi, not actually required
    pstree
    python3
    rclone
    ripgrep
    # for modern Emacs
    sqlite
    virtualenv # better than python -m venv because supports Nu
    wget
  ];
}
