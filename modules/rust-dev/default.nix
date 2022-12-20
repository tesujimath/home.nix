{ pkgs, ... }:

{
  home.packages = [
    pkgs.cargo
    pkgs.llvmPackages.bintools
    pkgs.rust-analyzer
    pkgs.rustc
  ];
}
