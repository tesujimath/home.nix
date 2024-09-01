use direnv
use readline-binding

# get hostname into prompt
set edit:prompt = {
     styled (hostname)'> ' bright-yellow
}

# kill right prompt
set edit:rprompt = (constantly "")

# Packages - installed in Nix Home Manager

# Elvish modules
use github.com/zzamboni/elvish-modules/alias

# Rivendell
use github.com/crinklywrappr/rivendell/test t
use github.com/crinklywrappr/rivendell/base b
use github.com/crinklywrappr/rivendell/fun f
use github.com/crinklywrappr/rivendell/lazy l
use github.com/crinklywrappr/rivendell/rune r
use github.com/crinklywrappr/rivendell/algo a
use github.com/crinklywrappr/rivendell/vis v

# bash-env
use github.com/tesujimath/bash-env-elvish/bash-env
fn bash-env { |&shellvars=[] @args| bash-env:bash-env &shellvars=$shellvars $@args }

# virtualenv
use github.com/tesujimath/bash-env-elvish/virtualenv

# aliases
alias:new reload eval (cat ~/.config/elvish/rc.elv | slurp)

# viewers
fn values-to-json { var in = [(all)] ; if (== 1 (count $in)) { put $in[0] } else { put $in } | to-json }
fn jtv { nu --no-config-file --no-history --no-std-lib --plugin-config /dev/null --stdin -c 'from json' }
fn tv { values-to-json | jtv }
fn fxv { values-to-json | fx }

# ssh with elvish as remote shell
fn ssh-elvish { |host|
  ssh -t $host bash --login -c elvish
}

# mosh with nu as remote shell
fn mosh-elvish { |host|
  mosh -- $host bash --login -c elvish
}

# add all ssh identities
fn ssh-add-all {
  ssh-add ~/.ssh/id_*[letter][digit][set:-]
}

# AgR eRI
# ssh via OpenStack CoreOS
fn ssh-os-core { |host|
  openstack server ssh --private $host -- -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -l core
}

# Home Manager
fn home-manager-switch {
  home-manager switch -v --flake $E:HOME_MANAGER_FLAKE_REF_ATTR

  unset-env __HM_SESS_VARS_SOURCED
  bash-env $E:HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

  echo "may need to exec elvish to reload rc.elv"
}

bash-env $E:HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
