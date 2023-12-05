{ config, pkgs, ... }:

with pkgs;
{
  config = {
    programs = {
      helix = {
        enable = true;
        settings = {
          editor = {
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
          };
          keys = {
            normal = {
              "X" = ["extend_line_up" "extend_to_line_bounds"];
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
        languages = {
          language = [
            {
              name = "rust";
              auto-pairs = {
                "(" = ")";
                "{" = "}";
                "[" = "]";
                "\"" = "\"";
                "`" = "`";
              };
            }
            {
              name = "python";
              language-servers = ["pyright"];
            }
          ];

          language-server = {
            rust-analyzer = {
              config = {
                check = {
                  command = "clippy";
                };
              };
            };
          };
        };
      };
    };
    home.packages = [
      vscode-extensions.llvm-org.lldb-vscode
    ];
  };
}
