{ options, config, pkgs, lib, ... }:

with pkgs;
{
  options.my.lsp = {
    bash.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Bash LSP server"; };
    dart.enable = lib.mkOption { default = false; type = lib.types.bool; description = "Enable Dart LSP server"; };
    dockerfile.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Dockerfile LSP server"; };
    go.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Go LSP server"; };
    json.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable JSON LSP server"; };
    markdown.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Markdown LSP server"; };
    nix.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Nix LSP server"; };
    python.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Python LSP server"; };
    rust.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Rust LSP server"; };
    terraform.enable = lib.mkOption { default = false; type = lib.types.bool; description = "Enable Terraform LSP server"; };
    toml.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable TOML LSP server"; };
    typescript.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable TypeScript LSP server"; };
    typst.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Typst LSP server"; };
    yaml.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable YAML LSP server"; };
  };

  config = {
    home.packages =
      with pkgs;
      (if config.my.lsp.bash.enable then [nodePackages.bash-language-server] else [])
      ++
      (if config.my.lsp.dart.enable then [dart] else [])
      ++
      (if config.my.lsp.dockerfile.enable then [dockerfile-language-server-nodejs] else [])
      ++
      (if config.my.lsp.go.enable then [gopls] else [])
      ++
      (if config.my.lsp.json.enable then [vscode-langservers-extracted] else [])
      ++
      (if config.my.lsp.markdown.enable then [marksman] else [])
      ++
      (if config.my.lsp.nix.enable then [nixd] else [])
      ++
      (if config.my.lsp.python.enable then [pyright pylint] else [])
      ++
      (if config.my.lsp.rust.enable then [rust-analyzer rustfmt] else [])
      ++
      (if config.my.lsp.terraform.enable then [terraform-ls] else [])
      ++
      (if config.my.lsp.toml.enable then [taplo-lsp] else [])
      ++
      (if config.my.lsp.typescript.enable then [nodePackages.typescript-language-server] else [])
      ++
      (if config.my.lsp.typst.enable then [typst-lsp typst-fmt] else [])
      ++
      (if config.my.lsp.yaml.enable then [yaml-language-server] else [])
    ;

    programs = {
      helix = {
        enable = true;
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
        languages = let remove-trailing-whitespace-formatter = {
          command = "sed";
          args = ["s/[[:space:]]*$//"];
        }; in {
          language = [
            {
              name = "nix";
              language-servers = ["nixd"];
            }
            {
              name = "python";
              language-servers = ["pyright"];
              formatter = remove-trailing-whitespace-formatter;
              auto-format = true;
            }
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
              name = "typst";
              formatter = {
                command = "typstfmt";
                args = ["--output" "-"];
              };
              auto-format = true;
            }
          ];

          language-server = {
            nixd = {
              command = "nixd";
            };
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
