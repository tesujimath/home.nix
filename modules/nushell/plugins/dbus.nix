{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, unstableGitUpdater
, dbus
, pkg-config
}:

rustPlatform.buildRustPackage {
  pname = "nu-plugin-dbus";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = "nu_plugin_dbus";
    rev = "d6edfe2f1a74970381b539164316a3f040d366db";
    hash = "sha256-dvUYYEZA1IvRjYvIN9yHpBhfQRkgM7/fD1fmpEJfN3o=";
  };

  cargoHash = "sha256-7AAc/igCcXxmHbW4ZXPqHSEwfcTjvAmsAyb7x2VY8zY=";

  cargoPatches = [
    # a patch file to add Cargo.lock in the source code
    ./dbus.Cargo.lock.patch
  ];

  buildInputs = [
    dbus
  ];

  nativeBuildInputs = [
    #rustPlatform.bindgenHook
    pkg-config
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Nushell plugin for interacting with D-Bus";
    homepage = "https://github.com/devyn/nu_plugin_dbus";
    license = licenses.mit;
    mainProgram = "nu-plugin-dbus";
  };
}
