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
            soft-wrap = {
              enable = true;
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
