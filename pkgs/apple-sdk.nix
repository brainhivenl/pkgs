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
    ''
      ${lib.getExe darwin.libtapi} stubify "${dylib}/lib/${dylib.pname}.dylib" -o "$sdk_path/usr/lib/${dylib.pname}.tbd"
      cp ${lib.getInclude dylib}/include/*.h "$sdk_path/usr/include/"
    '';
  in
    ''
      sdk_path="$out/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${package.version}.sdk"
      mkdir -p $sdk_path/usr/lib
      mkdir -p $sdk_path/usr/include

      ${lib.concatStringsSep "\n" (map mkStub extraLibraries)}
    '';
}
