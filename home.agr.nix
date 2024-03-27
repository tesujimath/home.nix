{ config, pkgs, lib, ... }:

{
  home.sessionPath = [
    "$HOME/scripts"
  ];

  programs = {
    bash = {
      enable = true;

      profileExtra = ''
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
      '';
    };

    home-manager.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "Simon Guest";
      userEmail = "simon.guest@agresearch.co.nz";
      extraConfig = {
        fetch = {
          prune = true;
        };
        init = {
          defaultBranch = "main";
        };
      };
    };
  };

  home = {
    file = {
      ".ssh/config".source = ./dotfiles.agr/ssh_config;
    };
  };

  imports = [
    ./packages.agr.nix
    ./modules/helix.nix
    ./modules/nushell
    ./modules/tmux.nix
    ./modules/yazi
    ./modules/zellij.nix
  ];

  my.lsp = {
    # mostly they're enabled by default, except:
    terraform.enable = true;
  };
}
