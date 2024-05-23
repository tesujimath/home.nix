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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = "nu_plugin_dbus";
    rev = "adf528e978d04df8d86643f7b1ee256064961f3c";
    hash = "sha256-3rXIyEWvQ+IrWDORe6+478ahjzshjr00P4ZoW9ANfb4=";
  };

  cargoHash = "sha256-Fc9eFqKVzhImtFcaT28D+9nHdDl0FAHKuo/bPWWuXvc=";

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
