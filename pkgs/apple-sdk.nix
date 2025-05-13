{
  lib,
  darwin,
  symlinkJoin,
  apple-sdk_15,
  package ? apple-sdk_15,
  extraLibraries ? [],
}:
symlinkJoin {
  inherit (package) pname version meta;

  paths = [package];

  buildInputs = [darwin.libtapi];

  postBuild = let
    mkStub = dylib:
    # sh
    ''
      tapi stubify "${dylib}/lib/${dylib.pname}.dylib" -o "$library_path/${dylib.pname}.tbd"
    '';
  in
    # sh
    ''
      library_path="$out/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${package.version}.sdk/usr/lib"
      mkdir -p $library_path
      ${map mkStub extraLibraries |> lib.concatStringsSep "\n"}
    '';
}
