{
  lib,
  pkgs,
  ...
}: {
  packages = with pkgs; [];

  bazel = {
    enable = true;
    extraLibraries = with pkgs.darwin; [
      libiconv
      libresolv
    ];
  };

  enterShell = lib.mkForce "";
}
