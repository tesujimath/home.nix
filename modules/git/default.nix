{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.local.git;
in
{
  options.local.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        userName = config.local.user.fullName;
        userEmail = config.local.user.email;
        extraConfig = {
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
