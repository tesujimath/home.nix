{ pkgs, ... }:

{
  home.packages = [
    #pkgs.awless
    pkgs.awscli2
    pkgs.dotnet-sdk_5
    pkgs.jetbrains.datagrip
    pkgs.jetbrains.rider
    pkgs.python39Packages.mitmproxy

    # these are needed for the building the server repo natively,
    # but would be better as a shell.nix in that repo, or even just
    # switching to building that with docker
    pkgs.libgdiplus
    pkgs.libmediainfo
  ];
}
