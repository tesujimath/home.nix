{ config, lib, ... }:

let
  cfg = config.local.ledger;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.local.ledger = {
    enable = mkEnableOption "ledger";
  };

  config = mkIf cfg.enable {
    home.file = {
      ".config/ledger-autosync/plugins/firstdirect.py".source = ./ledger-autosync-plugins/firstdirect.py;
    };
  };
}
