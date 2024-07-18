{ options, config, pkgs, lib, ... }:

with pkgs;
{
  options.local.lsp = {
    bash.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Bash LSP server"; };
    dart.enable = lib.mkOption { default = false; type = lib.types.bool; description = "Enable Dart LSP server"; };
    dockerfile.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Dockerfile LSP server"; };
    go.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Go LSP server"; };
    json.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable JSON LSP server"; };
    markdown.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Markdown LSP server"; };
    nix.enable = lib.mkOption { default = true; type = lib.types.bool; description = "Enable Nix LSP server"; };
    packer.enable = lib.mkOption { default = false; type = lib.types.bool; description = "Enable Packer formatting"; };
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
      (if config.local.lsp.bash.enable then [ nodePackages.bash-language-server shfmt ] else [ ])
      ++
      (if config.local.lsp.dart.enable then [ dart ] else [ ])
      ++
      (if config.local.lsp.dockerfile.enable then [ dockerfile-language-server-nodejs ] else [ ])
      ++
      (if config.local.lsp.go.enable then [ go gopls ] else [ ])
      ++
      (if config.local.lsp.json.enable then [ vscode-langservers-extracted ] else [ ])
      ++
      (if config.local.lsp.markdown.enable then [ marksman ] else [ ])
      ++
      (if config.local.lsp.nix.enable then [ nil nixpkgs-fmt ] else [ ])
      ++
      (if config.local.lsp.packer.enable then [ packer ] else [ ])
      ++
      (if config.local.lsp.python.enable then [ pyright pylint black ] else [ ])
      ++
      (if config.local.lsp.rust.enable then [ rust-analyzer rustfmt ] else [ ])
      ++
      (if config.local.lsp.terraform.enable then [ terraform-ls ] else [ ])
      ++
      (if config.local.lsp.toml.enable then [ taplo-lsp ] else [ ])
      ++
      (if config.local.lsp.typescript.enable then [ nodePackages.typescript-language-server ] else [ ])
      ++
      (if config.local.lsp.typst.enable then [ typst-lsp typst-fmt ] else [ ])
      ++
      (if config.local.lsp.yaml.enable then [ yaml-language-server ] else [ ])
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
            auto-format = true;
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
                auto-pairs = {
                  "(" = ")";
                  "{" = "}";
                  "[" = "]";
                  "\"" = "\"";
                  "`" = "`";
                };
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
                name = "dockerfile";
                formatter = remove-trailing-whitespace-formatter;
                auto-format = true;
              }
              {
                name = "nu";
                formatter = remove-trailing-whitespace-formatter;
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
                  command = "typstfmt";
                  args = [ "--output" "-" ];
                };
                auto-format = true;
              }
              {
                name = "yaml";
                formatter = remove-trailing-whitespace-formatter;
                auto-format = true;
              }
            ]
            ++
            (if config.local.lsp.packer.enable then [
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

            ] else [ ]);

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
            };
          };
      };
    };
    #home.packages = [
    #  vscode-extensions.llvm-org.lldb-vscode
    #];
  };
}
