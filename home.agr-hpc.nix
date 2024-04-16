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
        # /nix/store/a1s263pmsci9zykm5xcdf7x9rv26w6d5-bash-5.2p26/bin/bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
        # /home/guestsi/.nix-profile/bin/manpath: can't set the locale; make sure $LC_* and $LANG are correct
        LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      };
    };

    my = {
      bash.profile = {
        reuse-ssh-agent = true;
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
