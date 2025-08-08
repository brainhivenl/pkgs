{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bazel;
in {
  options.bazel = with lib; {
    enable = mkEnableOption "Whether to enable Bazel integration";
    extraLibraries = mkOption {
      type = types.listOf types.package;
      description = "List of library packages to be included in the Apple SDK";
      default = with pkgs.darwin; [libiconv libresolv];
    };
  };

  config = lib.mkIf cfg.enable {
    packages = with pkgs; [brain.bazelisk];

    apple.sdk = lib.mkDefault (pkgs.brain.apple-sdk.override {
      inherit (cfg) extraLibraries;
    });
  };
}
