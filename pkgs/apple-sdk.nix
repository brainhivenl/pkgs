{
  lib,
  darwin,
  apple-sdk_15,
  package ? apple-sdk_15,
  extraLibraries ? [],
}:
package.overrideAttrs {
  patchPhase = let
    mkStub = dylib:
    # sh
    ''
      ${lib.getExe darwin.libtapi} stubify "${dylib}/lib/${dylib.pname}.dylib" -o "$library_path/${dylib.pname}.tbd"
    '';
  in
    # sh
    ''
      library_path="$out/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${package.version}.sdk/usr/lib"
      mkdir -p $library_path
      ${lib.concatStringsSep "\n" (map mkStub extraLibraries)}
    '';
}
