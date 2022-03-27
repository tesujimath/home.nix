self: super:
{
  jetbrains = super.jetbrains // {
    rider = super.jetbrains.rider.overrideAttrs (_: rec {
      name = "rider-${version}";
      version = "2021.3.3";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "13q6hk5l3fqmz818z5wj014jd5iglpdcpi8zlpgaim1jg5fpvi8x";
      };
    });
  };
}
