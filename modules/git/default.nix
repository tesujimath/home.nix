{ config, lib, ... }:

let
  cfg = config.local.git;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = config.local.user.fullName;
            email = config.local.user.email;
          };
          fetch = {
            prune = true;
          };
          init = {
            defaultBranch = "main";
          };
          alias = {
            glog = "log --graph --all --pretty='format:%C(auto)%h %D %<|(100)%s %<|(120)%an %ar'";
          };
        };
      };
    };
  };
}
