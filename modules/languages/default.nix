{ config, pkgs, lib, specialArgs, ... }:

let
  cfg = config.local.languages;
  inherit (lib) mkEnableOption;
in
{
  options.local.languages = {
    bash.enable = mkEnableOption "bash";
    beancount.enable = mkEnableOption "beancount";
    c.enable = mkEnableOption "C";
    clojure.enable = mkEnableOption "clojure";
    dockerfile.enable = mkEnableOption "dockerfile";
    fennel.enable = mkEnableOption "fennel";
    go.enable = mkEnableOption "go";
    jinja.enable = mkEnableOption "jinja";
    json.enable = mkEnableOption "json";
    jsonnet.enable = mkEnableOption "jsonnet";
    markdown.enable = mkEnableOption "markdown";
    nix.enable = mkEnableOption "nix";
    python.enable = mkEnableOption "python";
    rust.enable = mkEnableOption "rust";
    terraform.enable = mkEnableOption "terraform";
    toml.enable = mkEnableOption "toml";
    typescript.enable = mkEnableOption "typescript";
    typst.enable = mkEnableOption "typst";
    yaml.enable = mkEnableOption "yaml";
  };

  config =
    let
      language-support-packages =
        let
          inherit (specialArgs) localPkgs;
        in
        with pkgs;
        (if cfg.bash.enable then [ nodePackages.bash-language-server shfmt ] else [ ])
        ++
        (if cfg.beancount.enable then [ beancount-language-server ] else [ ])
        ++
        (if cfg.c.enable then [ clang-tools ] else [ ])
        ++
        (if cfg.dockerfile.enable then [ dockerfile-language-server ] else [ ])
        ++
        (if cfg.fennel.enable then [ fennel-ls fnlfmt ] else [ ])
        ++
        (if cfg.go.enable then [ go gopls ] else [ ])
        ++
        (if cfg.jinja.enable then [ jinja-lsp localPkgs.prettier-with-plugins ] else [ ])
        ++
        (if cfg.json.enable then [ vscode-langservers-extracted ] else [ ])
        ++
        (if cfg.jsonnet.enable then [ jsonnet-language-server jsonnet ] else [ ])
        ++
        (if cfg.markdown.enable then [ marksman ] else [ ])
        ++
        (if cfg.nix.enable then [ nil nixpkgs-fmt ] else [ ])
        ++
        (if cfg.python.enable then [ pyright ruff ] else [ ])
        ++
        (if cfg.rust.enable then [ rust-analyzer rustfmt ] else [ ])
        ++
        (if cfg.terraform.enable then [ terraform-ls ] else [ ])
        ++
        (if cfg.toml.enable then [ taplo ] else [ ])
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
    in
    {
      # It would be nicer to pull this in from the helix module rather than set it here,
      # but I am unsure how to get NixOS modules to do that.
      local.helix.language-support-packages = language-support-packages;

      # Make zprint for Clojure available globally, for use from Emacs
      home.packages =
        if cfg.clojure.enable then [
          pkgs.zprint
        ] else [ ];
    };
}
