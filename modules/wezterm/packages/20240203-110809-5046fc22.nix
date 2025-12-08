{ stdenv }:

let
  nixpkgs_rev = "cefbda9e4cdc33950b9eba424d405ee791c6de34";
  nixpkgs_sha256 = "sha256:12c5wmdwsk8gw763g2c6dvkb1b1xbp7394a14xpn95iddf4n53v7";

  pinnedPkgs = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgs_rev}.tar.gz";
      sha256 = nixpkgs_sha256;
    })
    {
      system = stdenv.hostPlatform.system;
    };
in
pinnedPkgs.wezterm
