{
  pkgs,
  lib,
  config,
  inputs,
  brainhive,
  ...
}:

let
  brain = brainhive.packages.${pkgs.system};
  apple-sdk' = brain.apple-sdk.override {
    extraLibraries = with pkgs.darwin; [
      libiconv
      libresolv
    ];
  };
in
{
  packages = [
    # apple-sdk'
    brain.bazelisk
  ];

  apple.sdk = null;

  # env.DEVELOPER_DIR = "${apple-sdk'}";
  # env.SDKROOT = "${apple-sdk'}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
}
