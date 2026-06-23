{ config, pkgs, lib, specialArgs, ... }:

let
  cfg = config.local.languages;
  inherit (lib) mkOption;
  inherit (pkgs) symlinkJoin;

  language-packages =
    let
      inherit (specialArgs) localPkgs;
    in
    with pkgs; {
      # languages whose support simply needs some packages are listed here;
      # more complex ones, such as clojure, are imported as modules

      bash = [ bash-language-server shfmt ];

      beancount = [ beancount-language-server ];

      c = [ clang-tools ];

      dockerfile = [ dockerfile-language-server ];

      fennel = [ fennel-ls fnlfmt ];

      fsharp = [ fsautocomplete fantomas dotnet-sdk_10 ]; # SDK for interactive and REPL

      go = [ go gopls ];

      jinja = [ jinja-lsp localPkgs.prettier-with-plugins ];

      json = [ vscode-langservers-extracted ];

      jsonnet = [ jsonnet-language-server jsonnet ];

      markdown = [ marksman ];

      nix = [ nil nixpkgs-fmt ];

      python = [ pyright ruff ];

      rust = [ rust-analyzer rustfmt ];

      terraform = [ terraform-ls ];

      toml = [ taplo ];

      typescript = [ typescript-language-server biome rassumfrassum nodejs ];

      typst = [
        # typst-lsp is broken just now
        # typst-lsp
        typstyle
      ];

      yaml = [ yaml-language-server ];
    };
in
{
  imports = [
    ./clojure
  ];

  options.local = {
    languages =
      # an attrset with <language>.enable for each language
      (builtins.mapAttrs (name: _packages: { enable = lib.mkEnableOption name; }) language-packages) // {
        packages = mkOption {
          type = lib.types.listOf lib.types.package;
          description = "Programming language support packages for combining";
          default = [ ];
        };
      };
  };

  config.local.languages.packages = (lib.concatLists (lib.mapAttrsToList
    (name: packages: if cfg.${name}.enable then packages else [ ])
    language-packages)) ++ (if config.local.emacs.enable then [ pkgs.emacs-lsp-booster ] else [ ]);

  config.home.packages =
    let
      language-support = symlinkJoin
        {
          name = "language-support";
          paths = config.local.languages.packages;
        };
    in
    [
      language-support
    ];
}
