{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  options.local.homebrew = {
    enable = mkEnableOption "homebrew";
  };
}
