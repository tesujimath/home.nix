{ config, lib, ... }:

with lib;
let
  cfg = config.local.ledger;
in
{
  options.local.ledger = {
    enable = mkEnableOption "ledger";
  };

  config = {
    home.file = {
      ".config/ledger-autosync/plugins/firstdirect.py".source = ./ledger-autosync-plugins/firstdirect.py;
    };
  };
}
