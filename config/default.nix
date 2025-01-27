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

  gquery-env-elvish-fn = "fn gquery-env {|env| nix run 'git+ssh://k-devops-pv01.agresearch.co.nz/tfs/Scientific/Bioinformatics/_git/gquery?ref=refs/heads/gbs_prism#export-env' -- $env}";

  lmod-module-elvish-fn = ''fn module {|@args|
    if (has-env LMOD_CMD) {
      fn is-env-changer {|cmd|
        has-key [&load &add &try-load &try-add &del &unload &swap &sw &switch &purge &refresh &update] $cmd
      }

      # find the actual command, i.e. skipping past options
      var cmd = (keep-if {|s| !=s $s[0] -} $args | take 1)

      if (is-env-changer $cmd) {
        $E:LMOD_CMD bash $@args | bash-env
      } else {
        $E:LMOD_CMD bash $@args | bash
      }
    } else {
      fail "Environment variable LMOD_CMD is unset, is lmod installed?"
    }
  }
  '';

  moshWithKerberos = (pkgs.mosh.override { openssh = pkgs.opensshWithKerberos; }).overrideAttrs (attrs: {
    # The locale setting is for glibc 2.27 compatability, as per this:
    # https://github.com/NixOS/nixpkgs/issues/38991
    postFixup = ''
      for prog in mosh-client mosh-server; do
        wrapProgram $out/bin/''$prog --set LOCALE_ARCHIVE_2_27 "${pkgs.glibcLocales}/lib/locale/locale-archive"
      done
    '';
  });
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

        elvish.rcExtra = ''
          ${gquery-env-elvish-fn}
        '';

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
        moshWithKerberos
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

        elvish.rcExtra = ''
          ${gquery-env-elvish-fn}
        '';
      };
    home = {
      inherit stateVersion;
      username = "guestsi";
      homeDirectory = /home/guestsi;
      packages = with pkgs; [
        # recently Kerberos was removed from the default openssh package
        # would be better configured via programs.ssh
        opensshWithKerberos
        moshWithKerberos
      ];
      sessionVariables = {
        GIT_SSH = "/usr/bin/ssh";
      };
    };

  };
  agr-eri = {
    local = lib.attrsets.recursiveUpdate
      (commonModules // (disable [
        # also use system git on eRI to avoid ssh cert problem as on legacy HPC
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
          conda-root = "/agr/persist/apps/Miniconda3/23.5.2";
          extra = ''
            # work-around for ssh-add: No user found with uid:
            export LD_PRELOAD=/usr/lib64/libnss_sss.so.2
          '';
        };

        elvish.rcExtra = ''
          ${gquery-env-elvish-fn}
          ${lmod-module-elvish-fn}
        '';
      };

    home = {
      inherit stateVersion;
      username = "guestsi@agresearch.co.nz";
      homeDirectory = /home/agresearch.co.nz/guestsi;
      packages = with pkgs; [
        # recently Kerberos was removed from the default openssh package
        # would be better configured via programs.ssh
        opensshWithKerberos
        moshWithKerberos
      ];
      sessionVariables = {
        GIT_SSH = "/usr/bin/ssh";
      };
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
