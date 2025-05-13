{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = with pkgs; [
    kubectl
    kubie
    k3d
    skaffold
    kubernetes-helm
  ];
}
