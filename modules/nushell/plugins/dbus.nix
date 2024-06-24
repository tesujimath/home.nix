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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = "nu_plugin_dbus";
    rev = "0.7.0";
    hash = "sha256-Z9/6BFvaHkKRpNE38YKq30c522ngsROEjQ2BUHm0aOw=";
  };

  cargoHash = "sha256-6Fs57KKEinrjEOhBqMiNP5ORFOlwEmgnTv1fInl8888=";

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
