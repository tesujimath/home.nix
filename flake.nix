{
  description = "Nix flake for Nix Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bash_env_elvish = {
      url = "github:tesujimath/bash-env-elvish/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nu_plugin_bash_env = {
      # we have to manually keep version of Nu bash-env plugin in step with Nushell version
      url = "github:tesujimath/nu_plugin_bash_env/0.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eza = {
      url = "github:eza-community/eza/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix_search = {
      url = "github:diamondburned/nix-search/v0.3.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, bash_env_elvish, nu_plugin_bash_env, eza, nix_search, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      flakePkgs = {
        bash_env_elvish = bash_env_elvish.packages.${system}.default;
        nu_plugin_bash_env = nu_plugin_bash_env.packages.${system}.default;
        eza = eza.packages.${system}.default;
        nix_search = nix_search.packages.${system}.default;
      };
      lib = pkgs.lib;

    in
    {
      homeConfigurations =
        let
          stateVersion = "21.11";

          mapEnabled = (enable: names: builtins.listToAttrs (map (name: { inherit name; value = { inherit enable; }; }) names));
          enable = mapEnabled true;
          disable = mapEnabled false;

          commonModules = enable [
            "bash"
            "elvish"
            "emacs"
            "helix"
            "mitmproxy"
            "nushell"
            "yazi"
            "zathura"
            "zellij"
          ];

          allLanguages = enable [
            "bash"
            "dart"
            "dockerfile"
            "go"
            "json"
            "markdown"
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

          commonLanguages = allLanguages // disable [ "dart" "packer" ];

          configurations = {
            agr = {
              home = {
                inherit stateVersion;
                username = "guestsi";
                homeDirectory = /home/guestsi;
              };
              modules = [
                ./home.agr.nix
                {
                  config.local = lib.attrsets.recursiveUpdate commonModules {
                    user = {
                      email = "simon.guest@agresearch.co.nz";
                      fullName = "Simon Guest";
                    };

                    defaultShell = "elvish";
                    defaultEditor = "hx";

                    lsp = commonLanguages;

                    bash.profile.reuse-ssh-agent = true;

                    web-browser.wsl.use-native-windows = true;
                  };
                }
              ];
            };
            agr-hpc = {
              home = {
                inherit stateVersion;
                username = "guestsi";
                homeDirectory = /home/guestsi;
              };
              modules = [
                ./home.agr-hpc.nix
              ];
            };
            agr-eri = {
              home = {
                inherit stateVersion;
                username = "guestsi@agresearch.co.nz";
                homeDirectory = /home/agresearch.co.nz/guestsi;
              };
              modules = [
                ./home.agr-eri.nix
              ];
            };
            personal = {
              home = {
                inherit stateVersion;
                username = "sjg";
                homeDirectory = /home/sjg;
              };
              modules = [
                ./home.personal.nix
                {
                  config.local = lib.attrsets.recursiveUpdate (commonModules // (enable [ "ledger" ])) {
                    user = {
                      email = "simon.guest@tesujimath.org";
                      fullName = "Simon Guest";
                    };

                    defaultShell = "elvish";
                    defaultEditor = "hx";

                    lsp = commonLanguages;
                  };
                }
              ];
            };
          };
        in
        builtins.mapAttrs
          (name: attrs:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = attrs.modules ++ [
                {
                  home = attrs.home // {
                    sessionVariables.HOME_MANAGER_FLAKE_REF_ATTR = "path:{attrs.home.homeDirectory}/home.nix#${name}";
                  };
                }
              ];
              extraSpecialArgs = {
                inherit flakePkgs;
              };
            })
          configurations;
    };
}
