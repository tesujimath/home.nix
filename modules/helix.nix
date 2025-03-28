{ config, lib, specialArgs, ... }:

let
  cfg = config.local.helix;
  inherit (lib) mkEnableOption mkIf;
  inherit (specialArgs) flakePkgs;
in
{
  options.local.helix = {
    enable = mkEnableOption "helix";
  };

  config = mkIf cfg.enable {
    programs = {
      helix = {
        enable = true;

        package = flakePkgs.helix;

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
                name = "jinja";
                language-servers = [ "jinja-lsp" ];
                formatter = {
                  command = "prettier";
                  args = [ "--parser" "html" ];
                };
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

              jinja-lsp = {
                command = "jinja-lsp";
                config =
                  {
                    templates = "./templates";
                    backend = [ "./src" ];
                    lang = "python";
                  };
                timeout = 5;
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
            };
          };
      };
    };
  };
}
