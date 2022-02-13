{ pkgs, ... }:

{
  home.packages = [
    #pkgs.nosql-workbench # DynamoDB UI, not yet in NixOS channel
  ];
}
