{ config, pkgs, lib, ... }:

{
  imports = [
    ./common.nix
    ./packages.agr-hpc.nix
  ];

  config = {
    home = {
      sessionPath = [
        "$HOME/scripts"
      ];

      sessionVariables = {
        # failed attempt to stop this when logging into legacy HPC:
        # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
        # manpath: can't set the locale; make sure $LC_* and $LANG are correct
        LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      };
    };

    local = {
      bash.profile = {
        reuse-ssh-agent = true;
      };

      nushell = {
        left_prompt_cmd = "cat /etc/agr-hostname";

        # sqlite implies WAL which doesn't work across network
        # https://www.sqlite.org/wal.html
        history_file_format = "plaintext";
      };

      # use system git on legacy HPC to avoid ssh cert problem:
      # inscrutable$ git fetch --all
      # Fetching origin
      # fatal: unable to access 'https://github.com/tesujimath/emacs.d.git/': OpenSSL/3.0.13: error:16000069:STORE routines::unregistered scheme
      # error: could not fetch origin
    };
  };
}
