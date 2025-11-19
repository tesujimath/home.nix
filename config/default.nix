let
  stateVersion = "21.11";

  mapEnabled = (enable: names: builtins.listToAttrs (map (name: { inherit name; value = { inherit enable; }; }) names));
  enable = mapEnabled true;
  disable = mapEnabled false;

  commonModules = enable [
    "bash"
    "babashka"
    "carapace"
    "emacs"
    "fish"
    "fonts"
    "git"
    "helix"
    "mitmproxy"
    "tmux"
    "yazi"
    "zathura"
  ];

  allLanguages = enable [
    "bash"
    "beancount"
    "c"
    "dockerfile"
    "go"
    "jinja"
    "json"
    "jsonnet"
    "markdown"
    "nix"
    "python"
    "rust"
    "terraform"
    "toml"
    "typescript"
    "typst"
    "yaml"
  ];

  commonLanguages = allLanguages // disable [ ];

  fish-functions = {
    common = {
      # add all ssh identities
      ssh-add-all.body = ''ssh-add ~/.ssh/(ls  ~/.ssh | grep '^id_[a-z0-9-]*$')'';
    };

    eri = {
      mosh-eri.body = "mosh --server=/home/agresearch.co.nz/guestsi/.nix-profile/bin/mosh-server $argv";
      #
      # AgR eRI
      # ssh via OpenStack CoreOS
      ssh-os-core.body = ''openstack server ssh --private $argv[1] -- -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -l core $argv[2..]'';

      ssh-os-rocky.body = ''openstack server ssh --private $argv[1] -- -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -l cloud-user $argv[2..]'';

      # ssh natively CoreOS
      ssh-core.body = ''ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -l core $argv'';

      # ssh natively Rocky Linux
      ssh-rocky.body = ''ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -l cloud-user $argv'';
    };

    slurm = {
      squeue-me = {
        body = "squeue --me -o '%.10A %.40j %.4t %.20S %.11M %.11L %.5m %.3c %.12B'";
      };
      squeue-all = {
        body = "squeue -o '%.10A %.25u %.40j %.4t %.20S %.11M %.11L %.5m %.3c %.12B'";
      };
      sacct-json = {
        body = "SLURM_TIME_FORMAT='%Y-%m-%dT%H:%M:%S' sacct --json $argv";
      };
    };
  };

  # any profile which uses mosh with kerberos will need this:
  moshWithKerberos = pkgs: (pkgs.mosh.override {
    openssh = pkgs.opensshWithKerberos;
  }).overrideAttrs (attrs: {
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
  # starter profile for third parties,
  # use the real profiles below for ideas on what to tweak
  minimal =
    let
      username = "CHANGEME";
      homeDirectory = /home/CHANGEME;
      email = "CHANGEME@CHANGEME";
      fullName = "CHANGEME";
    in
    {
      system = "x86_64-linux";
      attrs = pkgs: {
        local = pkgs.lib.attrsets.recursiveUpdate
          (commonModules // (disable [
            # list of module names (strings) of what you don't want from common modules
          ]) // (enable [
            # list of module names (strings) of what extra modules you want beyond common
          ]))
          {
            user = {
              inherit email;
              inherit fullName;
            };

            languages = commonLanguages;
          };

        home = {
          inherit stateVersion;
          inherit username;
          inherit homeDirectory;

          packages = with pkgs; [
            # recently Kerberos was removed from the default openssh package
            # would be better configured via programs.ssh
            opensshWithKerberos
            (moshWithKerberos pkgs)

            # any extra packages you want
          ];
        };
      };
    };

  agr =
    let
      username = "guestsi";
      homeDirectory = /home/guestsi;
      email = "simon.guest@agresearch.co.nz";
      fullName = "Simon Guest";
    in
    {
      system = "x86_64-linux";
      attrs = pkgs: {
        local = pkgs.lib.attrsets.recursiveUpdate
          (commonModules // (enable [
            "web-browser"
            "wezterm"
          ]))
          {
            user = {
              inherit email;
              inherit fullName;
            };

            defaultShell = "fish";
            defaultShellPath = "${pkgs.fish}/bin/fish";
            defaultEditor = "hx";

            languages = commonLanguages;

            bash.profile.reuse-ssh-agent = true;

            fish.functions = fish-functions.common // fish-functions.eri;

            web-browser.wsl.use-native-windows = true;
          };

        home = {
          inherit stateVersion;
          inherit username;
          inherit homeDirectory;

          file = {
            ".ssh/config".source = ./dotfiles.agr/ssh_config;
          };

          sessionVariables = {
            # in this profile I run a Windows terminal, so copy/paste must use terminal
            FX_NO_MOUSE = "true";
          };

          packages = with pkgs; [
            # recently Kerberos was removed from the default openssh package
            # would be better configured via programs.ssh
            opensshWithKerberos
            (moshWithKerberos pkgs)
          ];
        };
      };
    };

  agr-hpc =
    let
      username = "guestsi";
      homeDirectory = /home/guestsi;
      email = "simon.guest@agresearch.co.nz";
      fullName = "Simon Guest";
    in
    {
      system = "x86_64-linux";
      attrs = pkgs: {
        local = pkgs.lib.attrsets.recursiveUpdate
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
              inherit email;
              inherit fullName;
            };

            defaultShell = "fish";
            defaultShellPath = "${pkgs.fish}/bin/fish";
            defaultEditor = "hx";

            languages = commonLanguages;

            bash.profile = {
              reuse-ssh-agent = true;
              conda-root = "/stash/miniconda3";
            };
          };
        home = {
          inherit stateVersion;
          inherit username;
          inherit homeDirectory;
          packages = with pkgs; [
            # recently Kerberos was removed from the default openssh package
            # would be better configured via programs.ssh
            opensshWithKerberos
            (moshWithKerberos pkgs)
          ];
          sessionVariables = {
            GIT_SSH = "/usr/bin/ssh";
          };
        };
      };
    };

  agr-eri =
    let
      username = "guestsi@agresearch.co.nz";
      homeDirectory = /home/agresearch.co.nz/guestsi;
      email = "simon.guest@agresearch.co.nz";
      fullName = "Simon Guest";
    in
    {
      system = "x86_64-linux";
      attrs = pkgs: {
        local = pkgs.lib.attrsets.recursiveUpdate
          (commonModules // (disable [
            # also use system git on eRI to avoid ssh cert problem as on legacy HPC
            "git"
          ]))
          {
            user = {
              inherit email;
              inherit fullName;
            };

            defaultShell = "fish";
            defaultShellPath = "${pkgs.fish}/bin/fish";
            defaultEditor = "hx";

            languages = commonLanguages;

            bash.profile = {
              reuse-ssh-agent = true;
              conda-root = "/agr/persist/apps/eri_rocky8/software/Miniforge3/24.9.0-0";
              extra = ''
                # work-around for ssh-add: No user found with uid:
                export LD_PRELOAD=/usr/lib64/libnss_sss.so.2
              '';
            };

            fish.functions = fish-functions.common // fish-functions.slurm;
          };

        home = {
          inherit stateVersion;
          inherit username;
          inherit homeDirectory;
          packages = [
            # don't use Nix ssh, but we need mosh for mosh-server
            (moshWithKerberos pkgs)
          ];
          sessionVariables = { };
        };
      };
    };

  sjg-nixos =
    let
      username = "sjg";
      homeDirectory = /home/sjg;
      email = "simon.guest@tesujimath.org";
      fullName = "Simon Guest";
    in
    {
      system = "x86_64-linux";
      attrs = pkgs: {
        local = pkgs.lib.attrsets.recursiveUpdate
          (commonModules // (enable [
            "ledger"
            "syncthing"
            "web-browser"
            "xmonad-desktop"
          ]))
          {
            user = {
              inherit email;
              inherit fullName;
            };

            defaultShell = "fish";
            defaultShellPath = "${pkgs.fish}/bin/fish";
            defaultEditor = "hx";

            languages = commonLanguages;
          };

        home = {
          inherit stateVersion;
          inherit username;
          inherit homeDirectory;

          file = {
            ".env.sh".source = ./dotfiles.sjg-nixos/env.sh;
            ".ssh/config".source = ./dotfiles.sjg-nixos/ssh_config;
          };
          packages = with pkgs;
            [
              _1password-cli
              audacious
              # bind
              calibre
              freerdp
              gimp
              git-crypt
              git-imerge
              ijq
              jo
              nodejs
              python3
              speedcrunch
              # stow # was for install-dotfiles
              unison
              vscode
              yarn
              zoom-us
            ];
        };
      };
    };

  sjg-macos =
    let
      username = "sjg";
      homeDirectory = /Users/sjg;
      email = "simon.guest@tesujimath.org";
      fullName = "Simon Guest";
    in
    {
      system = "aarch64-darwin";
      attrs = pkgs: {
        local = pkgs.lib.attrsets.recursiveUpdate
          (enable [
            # "bash"
            # "babashka"
            # "carapace"
            "fish"
            "git"
            "helix"
            "homebrew"
            "mitmproxy"
            "tmux"
            "yazi"
            "zsh"

            # not these GUI apps and things we don't need on Mac:
            # "emacs"
            # "fonts"
            # "zathura"
          ])
          {
            user = {
              inherit email;
              inherit fullName;
            };

            defaultShell = "fish";
            defaultShellPath = "${pkgs.fish}/bin/fish";
            defaultEditor = "hx";

            languages = commonLanguages;
          };

        home = {
          inherit stateVersion;
          inherit username;
          inherit homeDirectory;
        };
      };
    };
}
