{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  options.tesujimath.homebrew = {
    enable = mkEnableOption "homebrew";
  };
}
