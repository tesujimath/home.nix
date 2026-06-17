{ buildLuaPackage, fennel, fetchFromSourcehut, fetchurl, lua, luacheck, luaOlder, luasocket }:
buildLuaPackage rec {
  pname = "jeejah";
  version = "0.3.2-unstable-2025-11-23";
  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = "jeejah";
    rev = "6df08cdf96e76b378e69304c432d889fe6f544ba";
    hash = "sha256-WDniR7fz8066ybfMhg/hPY+qwGc2J97WGHhK2vn9n5U=";
  };

  disabled = luaOlder "5.1";
  nativeBuildInputs = [ fennel luacheck ];
  propagatedBuildInputs = [ luasocket ];

  buildPhase = ''
    runHook preBuild

    # this only builds the jeejah binary
    make jeejah

    # also build the package
    fennel -c jeejah.fnl >jeejah.lua

    runHook postBuild
  '';

  installPhase = let luaPkgDir = "share/lua/${lua.luaversion}"; in ''
    runHook preInstall

    # this only installs the jeejah binary
    PREFIX=$out make install

    # also install the packages
    mkdir -p $out/${luaPkgDir}
    cp bencode.lua jeejah.lua $out/${luaPkgDir}

    runHook postInstall
  '';

  meta = {
    homepage = "https://gitlab.com/technomancy/jeejah";
    license.fullName = "MIT/X11";
    description = "An nREPL server";
    longDescription = ''Implements a server that speaks the nREPL protocol and allows
        clients to connect and evaluate code over a network connection.
    '';
  };
}
