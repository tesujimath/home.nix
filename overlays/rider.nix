self: super:
{
  jetbrains = super.jetbrains // {
    rider = super.jetbrains.rider.overrideAttrs (_: rec {
      name = "rider-${version}";
      version = "2021.3.1";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "0c788xvcd5b9jafz2yyllj1pzgc9ry3pg82qi8glghvimjnk1cfd";
      };
    });
  };
}
