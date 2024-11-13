{ config, lib, ... }:

let
  cfg = config.local.bash;
  inherit (lib) mkEnableOption mkIf mkOption types;
in
{
  options.local.bash = {
    enable = mkEnableOption "bash";
    profile = {
      reuse-ssh-agent = mkOption { default = false; type = types.bool; description = "Reuse or start ssh agent in Bash profile"; };
      ensure-krb5ccname = mkOption { default = false; type = types.bool; description = "Ensure KRB5CCNAME has a sensible value"; };
      conda-root = mkOption { default = null; type = types.nullOr types.str; description = "Root directory for conda, if any"; };
    };
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;

      # all shells
      bashrcExtra = ''
        home-manager-switch() {
          home-manager switch -v --flake $HOME_MANAGER_FLAKE_REF_ATTR

          unset __HM_SESS_VARS_SOURCED
          . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
          . $HOME/.bashrc
        }

        ${if cfg.profile.conda-root != null then ''
          # >>> conda initialize >>>
          # !! Contents within this block are managed by 'conda init' !!
          __conda_setup="$('${cfg.profile.conda-root}/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
          if [ $? -eq 0 ]; then
              eval "$__conda_setup"
          else
              if [ -f "${cfg.profile.conda-root}/etc/profile.d/conda.sh" ]; then
                  . "${cfg.profile.conda-root}/etc/profile.d/conda.sh"
              else
                  export PATH="${cfg.profile.conda-root}/bin:$PATH"
              fi
          fi
          unset __conda_setup
          # <<< conda initialize <<<
        '' else ""
        }
      '';

      profileExtra = ''
        ${if cfg.profile.reuse-ssh-agent then ''
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

        '' else ""
        }

        # start an ssh-agent if there's not one already
        test -n "''$SSH_AUTH_SOCK" || {
          eval `ssh-agent`
        }

        ${if cfg.profile.ensure-krb5ccname then ''
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
  };
}
