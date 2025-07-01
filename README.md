# Simon Guest's Nix Home Manager configuration

This Nix Home Manager configuration is designed to be easy to adapt for others' use.


## Getting Started

If you want to use the convenience script `home-manager-switch`, then clone this repo into `~/home.nix`.

Edit the `minimal` profile in [config/default.nix](config/default.nix) at least setting your user account
details, and ideally giving it a better profile name.

Then,

```
$ cd ~/home.nix
$ nix run 'nixpkgs/nixpkgs-unstable#home-manager' -- switch -v --flake '.#minimal'
```

Subsequently, if you have the `bash` module enabled, the shell function `home-manager-switch` may be
run with no arguments to reapply any changes you make to the profile.

(Nix requires that any new files be added to the git index before it can read them.)
