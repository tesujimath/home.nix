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
