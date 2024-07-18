{ config, pkgs, lib, ... }:

{
  options.local.bash.profile = {
    reuse-ssh-agent = lib.mkOption { default = false; type = lib.types.bool; description = "Reuse or start ssh agent in Bash profile"; };
    ensure-krb5ccname = lib.mkOption { default = false; type = lib.types.bool; description = "Ensure KRB5CCNAME has a sensible value"; };
  };

  config = {
    programs.bash = {
      enable = true;

      # all shells
      bashrcExtra = ''
      '';

      profileExtra = ''
        ${if config.local.bash.profile.reuse-ssh-agent then ''
          # reuse an ssh-agent if we can
          unset SSH_AUTH_SOCK
          for ssh_auth_sock in `ls -t /tmp/ssh-*/agent.*`; do
            SSH_AUTH_SOCK=''$ssh_auth_sock ssh-add -l >/dev/null 2>&1
            # 0 means connected and found ssh identities
            # 1 means connected but no ssh identities found
            # 2 means failed to connect
            test $? -ne 2 && {
              export SSH_AUTH_SOCK=$ssh_auth_sock
              break
            }
          done
          unset ssh_auth_sock

          # otherwise start a new one
          test -n "''$SSH_AUTH_SOCK" || {
            eval `ssh-agent`
          }

        '' else ""
        }
        ${if config.local.bash.profile.ensure-krb5ccname then ''
          # ensure KRB5CCNAME has a good value
          export KRB5CCNAME=''${KRB5CCNAME-''$HOME/.krb5.cache}
        '' else ""
        }
      '';

      # interactive shells only
      initExtra = ''
        PS1='\h\$ '

        # colours for less
        export LESS="-R"

        # colours for ls
        dircolors_config=$HOME/.dircolors
        test -r $dircolors_config && eval $(dircolors -b $dircolors_config)

        # direnv
        eval "$(direnv hook bash)"

        # fallback terminal if not found
        infocmp "$TERM" >/dev/null 2>&1 || {
            export TERM=xterm-256color
        }
      '';
    };

    home.packages =
      with pkgs;
      [
        nodePackages.bash-language-server
      ];
  };
}
