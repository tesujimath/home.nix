# append to path if directory exists
append_path() {
    test -d "$1" && PATH=$PATH:"$1"
}

# prepend to path if directory exists
prepend_path() {
    test -d "$1" && PATH="$1":$PATH
}

# for Go
#GOROOT=$HOME/lib/go export GOROOT
#GOPATH=$HOME/go export GOPATH

# so can use latest npm
#prepend_path $HOME/lib/npm.global/bin

# set PATH so it includes user's own bin directories
append_path $HOME/bin
append_path $HOME/vc/sjg/scripts
append_path $HOME/vc/env/scripts
append_path $HOME/vc/env/nix-wrappers
append_path $HOME/vc/shc/scripts
append_path $HOME/vc/devops/devtools
append_path $HOME/lib/julia/bin
append_path $HOME/share/python
append_path $GOROOT/bin
append_path $HOME/go/bin
append_path $HOME/.local/bin
append_path $HOME/.cargo/bin

#HOOPLAYROOT=$HOME/vc/hooplay export HOOPLAYROOT
#. $HOME/vc/hooplay/site/devtools/devtools.env
#. $HOME/vc/hooplay/infrastructure/infrastructure.env

#. $HOME/vc/cog/devtools/env.sh

#append_path $HOME/vc/tesujimath/singstreet/scripts

# obsolete stuff:
#append_path $HOME/lib/android-studio/bin
#append_path $HOME/bin
#append_path $HOME/.cabal/bin
#append_path $HOME/.local/bin
#append_path /usr/local/racket/bin

# if the current node project has a bin, use it in preference to any global thing
# don't do this anymore, instead use npx
#PATH=./node_modules/.bin:$PATH

# moved from .bash_profile, where nix installer put it
test -e $HOME/.nix-profile/etc/profile.d/nix.sh && . $HOME/.nix-profile/etc/profile.d/nix.sh

export PATH

# to avoid grey windows in Geogebra
# both are necessary
_JAVA_AWT_WM_NONREPARENTING=1 export _JAVA_AWT_WM_NONREPARENTING
#JAVACMD=/usr/bin/java export JAVACMD

# so virsh uses the same URI scheme as virt-manager
LIBVIRT_DEFAULT_URI="qemu:///system" export LIBVIRT_DEFAULT_URI

#PYTHONPATH=$HOME/.local/lib/python2.7/site-packages:$PYTHONPATH
