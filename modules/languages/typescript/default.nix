{ config, pkgs, lib, ... }:

let
  cfg = config.local.languages.typescript;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.languages.typescript.enable = mkEnableOption "typescript";

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
        local.languages.packages =
          with pkgs;
          [
            biome
            deno
            # TODO remove this once deno LSP working in Emacs
            typescript-language-server
            rassumfrassum_034
          ] ++ (if config.local.zed-editor.enable then [
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
