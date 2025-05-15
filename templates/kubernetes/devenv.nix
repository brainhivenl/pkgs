{
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [];

  kubernetes = {
    enable = true;
    clusterName = "my-cluster";
    namespace = "default";
    defaultRepo = "registry.localhost:5003";
  };

  enterShell = lib.mkForce "";
}
