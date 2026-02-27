{ config, lib, pkgs, ... }:

let
  cfg = config.local.babashka;
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) babashka babashka-unwrapped writeScriptBin;

  edn-pp = writeScriptBin "edn-pp" ''
    #!${babashka-unwrapped}/bin/bb
    (clojure.pprint/pprint (edn/read {:default (fn [tag v] [tag v])} *in*))
  '';
in
{
  options.local.babashka = {
    enable = mkEnableOption "babashka";
  };

  config = mkIf cfg.enable {
    home.packages = [
      babashka
      edn-pp
    ];

    programs.fish.shellAbbrs = {
      bbnrs = "bb --nrepl-server";
    };
  };
}
