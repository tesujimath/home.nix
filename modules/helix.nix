{ config, lib, pkgs, ... }:

let
  cfg = config.local.helix;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.helix = {
    enable = mkEnableOption "helix";
  };

  config = mkIf cfg.enable {
    programs = {
      helix = {
        enable = true;

        package = pkgs.helix.overrideAttrs (attrs: rec {
          version = "24.07";
          src = pkgs.fetchzip {
            url = "https://github.com/helix-editor/helix/releases/download/${version}/helix-${version}-source.tar.xz";
            hash = "sha256-R8foMx7YJ01ZS75275xPQ52Ns2EB3OPop10F4nicmoA=";
            stripRoot = false;
          };
          # Overriding `cargoHash` has no effect; we must override the resultant
          # `cargoDeps` and set the hash in its `outputHash` attribute.
          cargoDeps = attrs.cargoDeps.overrideAttrs (lib.const {
            name = "${attrs.pname}-${version}-vendor.tar.gz";
            inherit src;
            outputHash = "sha256-Y8zqdS8vl2koXmgFY0hZWWP1ZAO8JgwkoPTYPVpkWsA=";
          });

          doCheck = false;
        });

        defaultEditor = true;
        settings = {
          editor = {
            true-color = true;
            bufferline = "multiple";
            line-number = "relative";
            lsp = {
              display-inlay-hints = true;
              display-messages = true;
            };
            search = {
              wrap-around = false;
            };
            soft-wrap = {
              enable = true;
            };
            auto-format = true;
            auto-pairs = {
              "(" = ")";
              "{" = "}";
              "[" = "]";
            };
          };
          keys = {
            normal = {
              "X" = [ "extend_line_up" "extend_to_line_bounds" ];
            };
            insert = {
              up = "no_op";
              down = "no_op";
              left = "no_op";
              right = "no_op";
              pageup = "no_op";
              pagedown = "no_op";
              home = "no_op";
              end = "no_op";
            };
          };
        };
        languages =
          let
            remove-trailing-whitespace-formatter = {
              command = "sed";
              args = [ "s/[[:space:]]*$//" ];
            };
          in
          {
            language = [
              {
                name = "nix";
                language-servers = [ "nil" ];
                formatter = {
                  command = "nixpkgs-fmt";
                };
                auto-format = true;
              }
              {
                name = "python";
                language-servers = [ "pyright" ];
                formatter = { command = "black"; args = [ "-" "--quiet" ]; };
                auto-format = true;
              }
              {
                name = "rust";
                formatter = { command = "rustfmt"; args = [ "--edition=2021" ]; };
                auto-format = true;
              }
              {
                name = "bash";
                formatter = {
                  command = "shfmt";
                  args = [ "-i" "4" ];
                };
                auto-format = true;
              }
              {
                name = "c";
                auto-format = true;
              }
              {
                # treat embedded postgres like C
                name = "pgc";
                scope = "source.pgc";
                file-types = [ "pgc" ];
                language-servers = [ "clangd" ];
              }
              {
                name = "dockerfile";
                formatter = remove-trailing-whitespace-formatter;
                auto-format = true;
              }
              {
                name = "elvish";
                formatter = remove-trailing-whitespace-formatter;
                auto-format = true;
              }
              {
                name = "jsonnet";
                formatter = {
                  command = "jsonnetfmt";
                  args = [ "-" ];
                };
                auto-format = true;
              }
              {
                name = "markdown";
                formatter = remove-trailing-whitespace-formatter;
                auto-format = true;
              }
              {
                name = "nu";
                formatter = remove-trailing-whitespace-formatter;
                auto-format = true;
              }
              {
                name = "nextflow";
                scope = "source.nextflow";
                file-types = [ "nf" "nf.test" { glob = "nextflow.config"; } ];
                language-servers = [ "nextflow-language-server" ];
                # auto-format is annoying as it loses comments in certain contexts
                # auto-format = true;
              }
              {
                name = "packer";
                scope = "source.packer";
                file-types = [ "pkr.hcl" ];
                formatter = {
                  command = "packer";
                  args = [ "fmt" ];
                };
                auto-format = true;
              }
              {
                name = "toml";
                formatter = {
                  command = "taplo";
                  args = [ "fmt" "-" ];
                };
                auto-format = true;
              }
              {
                name = "typst";
                formatter = {
                  command = "typstyle";
                };
                # auto-format = true; - as of 9/12/24 it does a terrible job of tables
              }
              {
                name = "yaml";
                formatter = remove-trailing-whitespace-formatter;
                auto-format = true;
              }
            ];

            language-server = {
              nil = {
                command = "nil";
              };
              rust-analyzer = {
                config = {
                  check = {
                    command = "clippy";
                  };
                };
              };

              vscode-json-language-server = {
                config = {
                  provideFormatter = true;
                  json.keepLines.enable = true;
                };
              };

              nextflow-language-server = {
                command = "nextflow-language-server";
                config = {
                  nextflow = {
                    debug = true;

                    files.exclude = [
                      ".git"
                      ".nf-test"
                      "work"
                    ];

                    formatting.harshilAlignment = true;
                  };
                };
              };
            };
          };
      };
    };
  };
}
