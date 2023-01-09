{ config, ... }:

{
  config = {
    programs.bash = {
      enable = true;

      # all shells
      bashrcExtra = ''
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
  };
}
