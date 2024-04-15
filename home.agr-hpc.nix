{ config, pkgs, lib, ... }:

{
  imports = [
    ./common.nix
  ];

  config = {
    home = {
      sessionPath = [
        "$HOME/scripts"
      ];
    };

    my = {
      bash.profile = {
        reuse-ssh-agent = true;
        explicit-locale-archive = true;
      };

      nushell.left_prompt_cmd = "cat /etc/agr-hostname";

      # use system git on legacy HPC to avoid ssh cert problem:
      # inscrutable$ git fetch --all
      # Fetching origin
      # fatal: unable to access 'https://github.com/tesujimath/emacs.d.git/': OpenSSL/3.0.13: error:16000069:STORE routines::unregistered scheme
      # error: could not fetch origin
    };
  };
}
