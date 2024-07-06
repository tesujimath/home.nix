use direnv

# get hostname into prompt
set edit:prompt = {
     styled (hostname)'❱ ' bright-yellow
}

# kill right prompt
set edit:rprompt = (constantly "")

# Packages
# TODO: it's a bad idea to install packages in rc.elv, work out how to do this in Home Manager
#use epm

# Elvish modules
#epm:install &silent-if-installed=$true github.com/zzamboni/elvish-modules
use github.com/zzamboni/elvish-modules/alias

# Rivendell
#epm:install &silent-if-installed=$true github.com/crinklywrappr/rivendell
#epm:upgrade github.com/crinklywrappr/rivendell

use github.com/crinklywrappr/rivendell/test t
use github.com/crinklywrappr/rivendell/base b
use github.com/crinklywrappr/rivendell/fun f
use github.com/crinklywrappr/rivendell/lazy l
use github.com/crinklywrappr/rivendell/rune r
use github.com/crinklywrappr/rivendell/algo a
use github.com/crinklywrappr/rivendell/vis v

# bash-env
#epm:install &silent-if-installed=$true github.com/tesujimath/bash-env-elvish
use github.com/tesujimath/bash-env-elvish/bash-env
fn bash-env { |@args| bash-env:bash-env $@args }

# aliases
alias:new reload eval (cat ~/.config/elvish/rc.elv | slurp)

# viewers
fn jtv { nu --no-config-file --no-history --no-std-lib --plugin-config /dev/null --stdin -c 'from json' }
fn tv { to-json | jtv }
fn fxv { to-json | fx }

# ssh with elvish as remote shell
fn ssh-elvish { |host|
  ssh -t $host bash --login -c elvish
}

# mosh with nu as remote shell
fn mosh-elvish { |host|
  mosh -- $host bash --login -c elvish
}

# AgR eRI
# ssh via OpenStack CoreOS
fn ssh-os-core { |host|
  openstack server ssh --private $host -- -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -l core
}

# Home Manager
fn home-manager-switch {
  home-manager switch -v --flake "HOME_MANAGER_FLAKE_URI"
  echo "may need to exec elvish to reload rc.elv"
}
