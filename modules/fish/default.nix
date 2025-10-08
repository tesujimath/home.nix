{ config, lib, ... }:

let
  cfg = config.local.fish;
  inherit (lib) mkEnableOption mkIf mkOption types;
in
{
  options. local. fish = {
    enable = mkEnableOption "fish";

    functions = mkOption { type = types.attrsOf (types.attrsOf types.str); default = { }; description = "Fish functions as per Home Manager"; };
  };

  config = mkIf cfg.enable {
    programs = {
      fish = {
        enable = true;
        functions = cfg.functions // {
          fish_prompt.body = "string join '' -- (set_color green) $hostname '> ' (set_color normal)";
        };
      };
    };
  };
}
