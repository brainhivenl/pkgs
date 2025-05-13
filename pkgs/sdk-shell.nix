{
  mkShell,
  apple-sdk,
  ...
}: {
  sdkPackage ? apple-sdk,
  extraLibraries ? [],
  shellHook ? "",
  ...
} @ attrs: let
  sdkPackage' = sdkPackage.override {inherit extraLibraries;};
in
  mkShell (
    attrs
    // {
      shellHook =
        shellHook
        +
        # sh
        ''
          export DEVELOPER_DIR="${sdkPackage'}"
          export SDKROOT="${sdkPackage'}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
        '';
    }
  )
