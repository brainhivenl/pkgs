{
  lib,
  pkgs,
  darwin,
}:

let
  extraLibraries = [
    darwin.libiconv
    darwin.libresolv
  ];
in
pkgs.apple-sdk_15.overrideAttrs {
  patchPhase =
    let
      mkStub = dylib: ''
        ${lib.getExe darwin.libtapi} stubify "${dylib}/lib/${dylib.pname}.dylib" -o "$library_path/${dylib.pname}.tbd"
      '';
    in
    ''
      library_path="$out/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${pkgs.apple-sdk_15.version}.sdk/usr/lib"
      mkdir -p $library_path
      ${map mkStub extraLibraries |> lib.concatStringsSep "\n"}
    '';
}
