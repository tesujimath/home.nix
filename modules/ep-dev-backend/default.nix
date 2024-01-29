{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./overlays/rider.nix)
  ];

  home.packages = [
    (with pkgs.dotnetCorePackages; combinePackages [ sdk_6_0 sdk_5_0 ])

    #pkgs.awless
    pkgs.awscli2
    pkgs.earthly
    pkgs.jetbrains.datagrip
    pkgs.jetbrains.rider
    pkgs.python39Packages.mitmproxy
  ];
}
