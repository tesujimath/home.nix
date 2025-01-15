{ pkgs, lib, ... }:
let
  stateVersion = "21.11";

  mapEnabled = (enable: names: builtins.listToAttrs (map (name: { inherit name; value = { inherit enable; }; }) names));
  enable = mapEnabled true;
  disable = mapEnabled false;

  commonModules = enable [
    "bash"
    "carapace"
    "elvish"
    "emacs"
    "fonts"
    "git"
    "helix"
    "mitmproxy"
    "nushell"
    "yazi"
    "zathura"
    "zellij"
  ];

  allLanguages = enable [
    "bash"
    "c"
    "dart"
    "dockerfile"
    "go"
    "json"
    "markdown"
    "nextflow"
    "nix"
    "packer"
    "python"
    "rust"
    "terraform"
    "toml"
    "typescript"
    "typst"
    "yaml"
  ];

  commonLanguages = allLanguages // disable [ "dart" "nextflow" "packer" ];
in
{
  agr = {
    local = lib.attrsets.recursiveUpdate
      (commonModules // (enable [
        "web-browser"
        "wezterm"
      ]))
      {
        user = {
          email = "simon.guest@agresearch.co.nz";
          fullName = "Simon Guest";
        };

        defaultShell = "elvish";
        defaultEditor = "hx";

        lsp = commonLanguages // enable [ "nextflow" ];

        bash.profile.reuse-ssh-agent = true;

        web-browser.wsl.use-native-windows = true;
      };

    home = {
      inherit stateVersion;
      username = "guestsi";
      homeDirectory = /home/guestsi;

      file = {
        ".ssh/config".source = ./dotfiles.agr/ssh_config;
      };

      sessionVariables = {
        # in this profile I run a Windows terminal, so copy/paste must use terminal
        FX_NO_MOUSE = "true";
      };

      packages = with pkgs; [
        beekeeper-studio
        # recently Kerberos was removed from the default openssh package
        # would be better configured via programs.ssh
        opensshWithKerberos
      ];
    };
  };
  agr-hpc = {
    local = lib.attrsets.recursiveUpdate
      (commonModules // (disable [
        # use system git on legacy HPC to avoid ssh cert problem:
        # inscrutable$ git fetch --all
        # Fetching origin
        # fatal: unable to access 'https://github.com/tesujimath/emacs.d.git/': OpenSSL/3.0.13: error:16000069:STORE routines::unregistered scheme
        # error: could not fetch origin
        "git"
      ]))
      {
        user = {
          email = "simon.guest@agresearch.co.nz";
          fullName = "Simon Guest";
        };

        defaultShell = "elvish";
        defaultEditor = "hx";

        lsp = commonLanguages;

        bash.profile = {
          reuse-ssh-agent = true;
          conda-root = "/stash/miniconda3";
        };
      };
    home = {
      inherit stateVersion;
      username = "guestsi";
      homeDirectory = /home/guestsi;
      packages = with pkgs; [
        # recently Kerberos was removed from the default openssh package
        # would be better configured via programs.ssh
        opensshWithKerberos
      ];
    };

  };
  agr-eri = {
    local = lib.attrsets.recursiveUpdate commonModules {
      user = {
        email = "simon.guest@agresearch.co.nz";
        fullName = "Simon Guest";
      };

      defaultShell = "elvish";
      defaultEditor = "hx";

      lsp = commonLanguages;

      bash.profile = {
        reuse-ssh-agent = true;
        conda-root = "/agr/persist/apps/Miniconda3/23.5.2";
      };
    };
    home = {
      inherit stateVersion;
      username = "guestsi@agresearch.co.nz";
      homeDirectory = /home/agresearch.co.nz/guestsi;
      packages = with pkgs; [
        # recently Kerberos was removed from the default openssh package
        # would be better configured via programs.ssh
        opensshWithKerberos
      ];
    };
  };
  personal = {
    local = lib.attrsets.recursiveUpdate
      (commonModules // (enable [
        "ledger"
        "syncthing"
        "web-browser"
        "xmonad-desktop"
      ]))
      {
        user = {
          email = "simon.guest@tesujimath.org";
          fullName = "Simon Guest";
        };

        defaultShell = "elvish";
        defaultEditor = "hx";

        lsp = commonLanguages;
      };

    home = {
      inherit stateVersion;
      username = "sjg";
      homeDirectory = /home/sjg;

      file = {
        ".env.sh".source = ./dotfiles.personal/env.sh;
        ".ssh/config".source = ./dotfiles.personal/ssh_config;
      };
      packages = with pkgs;
        [
          _1password-cli
          audacious
          bind
          freerdp
          gimp
          git-crypt
          git-imerge
          ijq
          jo
          nodejs
          python3
          # stow # was for install-dotfiles
          unison
          vscode
          yarn
          zoom-us
        ];
    };
  };
}
