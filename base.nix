{ pkgs, specialArgs, ... }:

let
  inherit (specialArgs) flakePkgs;
in
{
  config = {
    home = {
      sessionVariables = {
        # make virsh use system connection as per virt-manager
        LIBVIRT_DEFAULT_URI = "qemu:///system";

        # never use managed Python from uv
        UV_NO_MANAGED_PYTHON = "1";
        UV_PYTHON_DOWNLOADS = "never";
      };

      file = {
        ".dircolors".source = ./config/dotfiles/dircolors;
      };

      packages =
        (with pkgs;
        [
          amber # CLI search/replace
          bottom
          devenv
          dig
          dust
          eza
          fd
          file
          gzip
          htop
          ijq
          jnv
          jq
          nix-index
          nix-search-cli
          nixos-option
          nmap
          pstree
          ripgrep
          sd
          unzip
          virtualenv # better than python -m venv because support for different shells
          wget
        ]) ++ (with flakePkgs;
        [ hl nox ]);
    };
  };
}
