{ config, pkgs, lib, specialArgs, ... }:

let
  cfg = config.local.lsp;
  inherit (lib) mkEnableOption;
in
{
  options.local.lsp = {
    bash.enable = mkEnableOption "bash";
    c.enable = mkEnableOption "C";
    dart.enable = mkEnableOption "dart";
    dockerfile.enable = mkEnableOption "dockerfile";
    go.enable = mkEnableOption "go";
    json.enable = mkEnableOption "json";
    jsonnet.enable = mkEnableOption "jsonnet";
    markdown.enable = mkEnableOption "markdown";
    nextflow.enable = mkEnableOption "nextflow";
    nix.enable = mkEnableOption "nix";
    packer.enable = mkEnableOption "packer";
    python.enable = mkEnableOption "python";
    rust.enable = mkEnableOption "rust";
    terraform.enable = mkEnableOption "terraform";
    toml.enable = mkEnableOption "toml";
    typescript.enable = mkEnableOption "typescript";
    typst.enable = mkEnableOption "typst";
    yaml.enable = mkEnableOption "yaml";
  };

  config = {
    home.packages =
      let
        inherit (specialArgs) flakePkgs;
      in
      with pkgs;
      (if cfg.bash.enable then [ nodePackages.bash-language-server shfmt ] else [ ])
      ++
      (if cfg.c.enable then [ clang-tools ] else [ ])
      ++
      (if cfg.dart.enable then [ dart ] else [ ])
      ++
      (if cfg.dockerfile.enable then [ dockerfile-language-server-nodejs ] else [ ])
      ++
      (if cfg.go.enable then [ go gopls ] else [ ])
      ++
      (if cfg.json.enable then [ vscode-langservers-extracted ] else [ ])
      ++
      (if cfg.jsonnet.enable then [ jsonnet-language-server jsonnet ] else [ ])
      ++
      (if cfg.markdown.enable then [ marksman ] else [ ])
      ++
      (if cfg.nextflow.enable then [ flakePkgs.nextflow-language-server ] else [ ])
      ++
      (if cfg.nix.enable then [ nil nixpkgs-fmt ] else [ ])
      ++
      (if cfg.packer.enable then [ packer ] else [ ])
      ++
      (if cfg.python.enable then [ pyright pylint black ] else [ ])
      ++
      (if cfg.rust.enable then [ rust-analyzer rustfmt ] else [ ])
      ++
      (if cfg.terraform.enable then [ terraform-ls ] else [ ])
      ++
      (if cfg.toml.enable then [ taplo-lsp ] else [ ])
      ++
      (if cfg.typescript.enable then [ nodePackages.typescript-language-server ] else [ ])
      ++
      (if cfg.typst.enable then [
        # typst-lsp is broken just now
        # typst-lsp
        typstyle
      ] else [ ])
      ++
      (if cfg.yaml.enable then [ yaml-language-server ] else [ ])
    ;
  };
}
