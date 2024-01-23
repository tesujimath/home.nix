{ options, config, pkgs, lib, ... }:

with pkgs;
{
  options.my.lsp = {
    rust.enable = lib.mkEnableOption "Rust LSP server";
    go.enable = lib.mkEnableOption "Go LSP server";
    python.enable = lib.mkEnableOption "Python LSP server";
    markdown.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Markdown LSP server"; };
    json.enable = lib.mkEnableOption "JSON LSP server";
  };

  config = {
    home.packages =
      with pkgs;
      (if config.my.lsp.rust.enable then [rust-analyzer] else [])
      ++
      (if config.my.lsp.go.enable then [gopls] else [])
      ++
      (if config.my.lsp.python.enable then [pyright pylint] else [])
      ++
      (if config.my.lsp.markdown.enable then [marksman] else [])
      ++
      (if config.my.lsp.json.enable then [vscode-langservers-extracted] else [])
    ;

    programs = {
      helix = {
        enable = true;
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
    #home.packages = [
    #  vscode-extensions.llvm-org.lldb-vscode
    #];
  };
}
