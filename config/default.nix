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
    "jujutsu"
    "mitmproxy"
    "nushell"
    "yazi"
    "zathura"
    "zellij"
  ];

  allLanguages = enable [
    "bash"
    "beancount"
    "c"
    "dart"
    "dockerfile"
    "go"
    "jinja"
    "json"
    "jsonnet"
    "markdown"
    "nix"
    "packer"
    "python"
    "rust"
    "steel"
    "terraform"
    "toml"
    "typescript"
    "typst"
    "yaml"
  ];

  commonLanguages = allLanguages // disable [ "dart" "packer" ];

  # Elvish functions shared between profiles:
  elvish-functions =
    {
      gquery = "fn gquery-env {|env| nix run 'git+ssh://k-devops-elvish-functions.pv01.agresearch.co.nz/tfs/Scientific/Bioinformatics/_git/gquery?ref=refs/heads/gbs_prism#export-env' -- $env}";

      eri = "fn mosh-eri {|@args| e:mosh --server=/home/agresearch.co.nz/guestsi/.nix-profile/bin/mosh-server $@args}";

      slurm = ''
        fn squeue-me { squeue --me -o "%.10A %.40j %.4t %.20S %.11M %.11L %.5m %.3c %.12B"}
        fn squeue-all { squeue -o "%.10A %.25u %.40j %.4t %.20S %.11M %.11L %.5m %.3c %.12B"}
        fn sacct-json {|@rest| with E:SLURM_TIME_FORMAT = "%Y-%m-%dT%H:%M:%S" { sacct --json $@rest } }
      '';
    };

  # any profile which uses mosh with kerberos will need this:
  moshWithKerberos = (pkgs.mosh.override {
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
      local = lib.attrsets.recursiveUpdate
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
          moshWithKerberos

          # any extra packages you want
        ];
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
      local = lib.attrsets.recursiveUpdate
        (commonModules // (enable [
          "web-browser"
          "wezterm"
        ]))
        {
          user = {
            inherit email;
            inherit fullName;
          };

          defaultShell = "elvish";
          defaultEditor = "hx";

          languages = commonLanguages;

          bash.profile.reuse-ssh-agent = true;

          elvish.rcExtra = ''
            ${elvish-functions.gquery}
            ${elvish-functions.eri}
          '';

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
          moshWithKerberos
        ];
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
            inherit email;
            inherit fullName;
          };

          defaultShell = "elvish";
          defaultEditor = "hx";

          languages = commonLanguages;

          bash.profile = {
            reuse-ssh-agent = true;
            conda-root = "/stash/miniconda3";
          };

          elvish.rcExtra = ''
            ${elvish-functions.gquery}
          '';
        };
      home = {
        inherit stateVersion;
        inherit username;
        inherit homeDirectory;
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

  agr-eri =
    let
      username = "guestsi@agresearch.co.nz";
      homeDirectory = /home/agresearch.co.nz/guestsi;
      email = "simon.guest@agresearch.co.nz";
      fullName = "Simon Guest";
    in
    {
      local = lib.attrsets.recursiveUpdate
        (commonModules // (disable [
          # also use system git on eRI to avoid ssh cert problem as on legacy HPC
          "git"
        ]))
        {
          user = {
            inherit email;
            inherit fullName;
          };

          defaultShell = "elvish";
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

          elvish.rcExtra = ''
            ${elvish-functions.gquery}
            ${elvish-functions.slurm}
          '';
        };

      home = {
        inherit stateVersion;
        inherit username;
        inherit homeDirectory;
        packages = [
          # don't use Nix ssh, but we need mosh for mosh-server
          moshWithKerberos
        ];
        sessionVariables = { };
      };
    };

  personal =
    let
      username = "sjg";
      homeDirectory = /home/sjg;
      email = "simon.guest@tesujimath.org";
      fullName = "Simon Guest";
    in
    {
      local = lib.attrsets.recursiveUpdate
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

          defaultShell = "elvish";
          defaultEditor = "hx";

          languages = commonLanguages;
        };

      home = {
        inherit stateVersion;
        inherit username;
        inherit homeDirectory;

        file = {
          ".env.sh".source = ./dotfiles.personal/env.sh;
          ".ssh/config".source = ./dotfiles.personal/ssh_config;
        };
        packages = with pkgs;
          [
            _1password-cli
            audacious
            bind
            calibre
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
