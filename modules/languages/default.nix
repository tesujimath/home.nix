{ config, pkgs, lib, specialArgs, ... }:

let
  cfg = config.tesujimath.languages;
  inherit (lib) mkIf mkOption;
  inherit (pkgs) symlinkJoin;

  prettier-with-plugins = pkgs.callPackage ./prettier-with-plugins.nix { };

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

      csharp = [ csharpier roslyn-ls ];

      dockerfile = [ dockerfile-language-server ];

      fennel = [ fennel-ls fnlfmt ];

      fsharp = [ fsautocomplete fantomas dotnet-sdk_10 ]; # SDK for interactive and REPL

      go = [ go gopls ];

      jinja = [ jinja-lsp prettier-with-plugins ];

      json = [ vscode-langservers-extracted ];

      jsonnet = [ jsonnet-language-server jsonnet ];

      markdown = [ marksman ];

      nix = [ nil nixpkgs-fmt ];

      python = [ pyright ruff ];

      rust = [ rust-analyzer rustfmt ];

      terraform = [ terraform-ls ];

      toml = [ taplo ];

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
    ./typescript
  ];

  options.tesujimath = {
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

  config.tesujimath.languages.packages = (lib.concatLists (lib.mapAttrsToList
    (name: packages: if cfg.${name}.enable then packages else [ ])
    language-packages));

  config.home = {
    packages =
      let
        language-support = symlinkJoin
          {
            name = "language-support";
            paths = config.tesujimath.languages.packages;
          };
      in
      [
        language-support
      ];
  };
}
