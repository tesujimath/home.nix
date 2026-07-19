{ config, pkgs, lib, ... }:

let
  cfg = config.tesujimath.languages.clojure;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.tesujimath = {
    languages = {
      clojure.enable = mkEnableOption "clojure";
    };
  };

  config = mkIf cfg.enable
    {
      tesujimath.languages.packages =
        with pkgs;
        [
          clj-kondo # clj-kondo is bundled in clojure-lsp, so strictly we don't need both
          clojure-lsp
          zprint
        ];

      home.file.".clojure/rebel_readline.edn".source = ./rebel_readline.edn;
    };
}
