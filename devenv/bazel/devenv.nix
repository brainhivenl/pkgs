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
in
{
  packages = with brain; [
    apple-sdk
    bazelisk
  ];

  env.DEVELOPER_DIR = brain.apple-sdk;
  env.SDKROOT = "${brain.apple-sdk}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
}
