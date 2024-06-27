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
    rev = "0.8.0";
    hash = "sha256-iTZanNEKuNZ+IVV8h3SixktJGg15iG9MIZyeZe7Gpjw=";
  };

  cargoHash = "sha256-au8sOG/Ex0G4sscINvWDG7v+whfHmlGxzTIFpWMFl/4=";

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
