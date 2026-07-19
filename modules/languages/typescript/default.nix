{ config, pkgs, lib, specialArgs, ... }:

let
  cfg = config.tesujimath.languages.typescript;
  inherit (lib) mkEnableOption mkIf;
  inherit (specialArgs) flakePkgs;
in
{
  options.tesujimath.languages.typescript.enable = mkEnableOption "typescript";

  config =
    let
      # needed for tsbiome preset
      rassumfrassum_034 = pkgs.rassumfrassum.overrideAttrs (attrs: rec {
        version = "0.3.4";

        src = pkgs.fetchFromGitHub {
          owner = "joaotavora";
          repo = "rassumfrassum";
          tag = "v${version}";
          hash = "sha256-q8Pv+E+UejK3z5xCw44Gji2xJ01uIo18qS5LHpLc5HE=";
        };
      });

    in
    mkIf cfg.enable
      {
        tesujimath.languages.packages =
          with pkgs;
          [
            biome
            flakePkgs.deno_292
            typescript-language-server
            rassumfrassum_034
          ] ++ (if config.tesujimath.zed-editor.enable then [
            eslint
            tailwindcss-language-server
            typescript
            vtsls
          ] else [ ]);

        home.file = {
          ".config/rassumfrassum/deno-biome.py".text = ''
            def servers():
                """TypeScript preset using deno and biome."""
                return [
                    ['deno', 'lsp'],
                    ['biome', 'lsp-proxy'],
                ]
          '';
        };
      };
}
