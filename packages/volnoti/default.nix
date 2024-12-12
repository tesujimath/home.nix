{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, dbus
, gdk-pixbuf
, glib
, libX11
, gtk2
, librsvg
, dbus-glib
, autoreconfHook
, wrapGAppsHook3
}:

stdenv.mkDerivation {
  pname = "volnoti-unstable";
  version = "2013-09-23";

  src = fetchFromGitHub {
    owner = "davidbrazdil";
    repo = "volnoti";
    rev = "4af7c8e54ecc499097121909f02ecb42a8a60d24";
    sha256 = "155lb7w563dkdkdn4752hl0zjhgnq3j4cvs9z98nb25k1xpmpki7";
  };

  patches = [
    # New icon for display brightness, accessed via volnoti-show -b, see
    # https://github.com/davidbrazdil/volnoti/pull/14
    (fetchpatch {
      url = "https://github.com/davidbrazdil/volnoti/pull/14.patch";
      sha256 = "sha256-NTyKuYK4w1flCV5NJzVIVcptNrxfYQ7/UGmD7BNQ6x0=";
    })
  ];

  nativeBuildInputs = [ pkg-config autoreconfHook wrapGAppsHook3 ];

  buildInputs = [
    dbus
    gdk-pixbuf
    glib
    libX11
    gtk2
    dbus-glib
    librsvg
  ];

  meta = with lib; {
    description = "Lightweight volume notification for Linux";
    homepage = "https://github.com/davidbrazdil/volnoti";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
