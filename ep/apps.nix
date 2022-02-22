{ pkgs, ... }:

{
  home.packages = [
    #pkgs.nosql-workbench # DynamoDB UI, not yet in NixOS channel
    pkgs.altair  # beautiful feature-rich GraphQL Client IDE
    pkgs.curlie  # the power of curl, the ease of use of httpie
    pkgs.gh
  ];
}
