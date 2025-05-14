{
  pkgs,
  lib,
  config,
  inputs,
  brainhive,
  ...
}: let
  brain = brainhive.packages.${pkgs.system};
  apple-sdk = brain.apple-sdk.override {
    extraLibraries = with pkgs.darwin; [
      libiconv
      libresolv
    ];
  };
in {
  packages = [
    brain.bazelisk
    apple-sdk
  ];

  apple.sdk = apple-sdk;
}
