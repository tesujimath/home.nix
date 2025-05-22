{ lib, pkgs, ... }:
let
  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "schemat";
    rev = "v0.4.0";
    sha256 = "sha256-LFUXohgQQObuyXv0dVzaok922x0G6zd2vqxDvJU506U=";
  };

  cargoConfig = builtins.fromTOML (builtins.readFile "${src}/Cargo.toml");
  inherit (pkgs) fetchFromGitHub makeRustPlatform rust-bin;
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };
in
rustPlatform.buildRustPackage
{
  pname = "schemat";
  version = cargoConfig.package.version;

  inherit src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  meta = with lib; {
    description = "Code formatter for Scheme, Lisp, and any S-expressions ";
    homepage = "https://github.com/raviqqe/schemat";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
  };
}
