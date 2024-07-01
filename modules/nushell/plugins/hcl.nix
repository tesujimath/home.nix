{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, unstableGitUpdater
, pkg-config
}:

rustPlatform.buildRustPackage {
  pname = "nu-plugin-hcl";
  version = "0.95-1";

  src = fetchFromGitHub {
    owner = "tesujimath";
    repo = "nu_plugin_hcl";
    rev = "nu-0.95";
    hash = "sha256-XsDS1i6XsGuHCo3rDtfIe9+DZqnLrRAiqAFHkmktEcY=";
  };

  cargoHash = "sha256-nP/pRKsr5318krI55QGJqXV8zIDp8aq7fSTRHVeiar0=";

  nativeBuildInputs = [
    #rustPlatform.bindgenHook
    pkg-config
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Nushell plugin for converting from HCL";
    homepage = "https://github.com/tesujimath/nu_plugin_hcl";
    license = licenses.mit;
    mainProgram = "nu-plugin-hcl";
  };
}
