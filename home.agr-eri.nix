{ config, pkgs, lib, ... }:

{
  imports = [
    ./common.nix
    ./packages.agr-eri.nix
  ];

  config = {
    my = {
      bash.profile = {
        reuse-ssh-agent = true;
        ensure-krb5ccname = true;
      };

      nushell = {
        # sqlite implies WAL which doesn't work across network
        # https://www.sqlite.org/wal.html
        history_file_format = "plaintext";
      };
    };
  };
}
