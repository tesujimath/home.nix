{ config, ... }:

{
  config = {
    home.file = {
      ".config/ledger-autosync/plugins/firstdirect.py".source = ./ledger-autosync-plugins/firstdirect.py;
    };
  };
}
