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
        languages = [
          {
            name = "rust";
            auto-pairs = {
              "(" = ")";
              "{" = "}";
              "[" = "]";
              "\"" = "\"";
              "`" = "`";
              "<" = ">";
            };
          }
        ];
      };
    };
    home.packages = [
      vscode-extensions.llvm-org.lldb-vscode
    ];
  };
}
