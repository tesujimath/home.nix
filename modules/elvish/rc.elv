use direnv

# get hostname into prompt
set edit:prompt = {
     styled (hostname)'❱ ' bright-yellow
}

# kill right prompt
set edit:rprompt = (constantly "")

# Packages
use epm

# Elvish modules
epm:install &silent-if-installed=$true github.com/zzamboni/elvish-modules
use github.com/zzamboni/elvish-modules/alias

# Rivendell
epm:install &silent-if-installed=$true github.com/crinklywrappr/rivendell
epm:upgrade github.com/crinklywrappr/rivendell

use github.com/crinklywrappr/rivendell/test t
use github.com/crinklywrappr/rivendell/base b
use github.com/crinklywrappr/rivendell/fun f
use github.com/crinklywrappr/rivendell/lazy l
use github.com/crinklywrappr/rivendell/rune r
use github.com/crinklywrappr/rivendell/algo a
use github.com/crinklywrappr/rivendell/vis v

# aliases
alias:new reload eval (cat ~/.config/elvish/rc.elv | slurp)

# viewers
fn jtv { nu --no-config-file --no-history --no-std-lib --plugin-config /dev/null --stdin -c 'from json' }
fn tv { to-json | jtv }
fn fxv { to-json | fx }

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
