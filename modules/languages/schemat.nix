{ lib, pkgs, ... }:
let
  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "schemat";
    rev = "fe1f5fe93dcef49cb7217ba6b9956a5b36f33a68"; # TODO use a tag
    sha256 = "sha256-opxzwxZvVushvj+36M4LCmLShpLFTHYtJqpkqDj1xJ0=";
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
