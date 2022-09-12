self: super:
{
  jetbrains = super.jetbrains // {
    rider = super.jetbrains.rider.overrideAttrs (attrs: rec {
      name = "rider-${version}";
      version = "2022.2.2";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "sha256-WX+JdpvdeYZE3eM4YW9kJFcuRwRAFNpresg7laPWez8=";
      };

      postPatch = super.lib.optionalString (!super.stdenv.isDarwin) (attrs.postPatch + ''
        interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        patchelf --set-interpreter $interp lib/ReSharperHost/linux-x64/Rider.Backend

        rm -rf lib/ReSharperHost/linux-x64/dotnet
        ln -s ${super.dotnet-sdk_6} lib/ReSharperHost/linux-x64/dotnet
      '');

    });
  };
}
