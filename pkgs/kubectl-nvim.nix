{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  lua5_1,
  stdenv,
  darwin,
}: let
  version = "v2.9.2";
  src = fetchFromGitHub {
    owner = "ramilito";
    repo = "kubectl.nvim";
    rev = version;
    sha256 = "sha256-3XTnKEne95WmbjE4QfLuNTOylQu+c/Wo7kPSXOpUVwE=";
  };

  libkubectl = buildGoModule {
    pname = "libkubectl-go";
    inherit src version;
    sourceRoot = "source/go";

    vendorHash = "sha256-o0i7UK7RzTUsQDwtN7o/XKUE5aewk118W494ui1n9zk=";

    buildPhase = ''
      runHook preBuild

      go build -trimpath -ldflags="-s -w" -buildmode=c-archive -o libkubectl_go.a

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      mkdir -p $out/include

      cp libkubectl_go.a $out/lib/
      cp libkubectl_go.h $out/include/

      mkdir -p $out/lib/pkgconfig
      cat > $out/lib/pkgconfig/libkubectl_go.pc <<EOF
      prefix=$out
      exec_prefix=\''${prefix}
      libdir=\''${prefix}/lib
      includedir=\''${prefix}/include

      Name: libkubectl_go
      Description: Go kubectl library for Rust integration
      Version: ${version}
      Libs: -L\''${libdir} -lkubectl_go
      Cflags: -I\''${includedir}
      EOF

      runHook postInstall
    '';

    dontInstall = false;

    meta = with lib; {
      description = "Go static library for kubectl operations";
      license = licenses.asl20;
      platforms = platforms.all;
    };
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "kubectl-rust";
    inherit version src;

    cargoHash = "sha256-nbR8XTZEOaeAT7T3w75YfOFHc7C/T91hMTDbE+2TfO0=";

    nativeBuildInputs = [pkg-config];

    buildInputs =
      [
        libkubectl
        lua5_1
      ]
      ++ lib.optionals stdenv.isDarwin [
        pkgs.apple-sdk_15
      ];

    NIX_LDFLAGS =
      "-L${lua5_1}/lib -llua"
      + lib.optionalString stdenv.isDarwin " -framework Security -framework CoreFoundation -framework SystemConfiguration -lresolv";

    preBuild = ''
      cp ${libkubectl}/lib/libkubectl_go.a go/
      cp ${libkubectl}/include/libkubectl_go.h go/

      export PKG_CONFIG_PATH="${lua5_1}/lib/pkgconfig:$PKG_CONFIG_PATH"
      export LUA_INC="${lua5_1}/include"
      export LUA_LIB="${lua5_1}/lib"
    '';

    # installPhase = ''
    #   runHook preInstall
    #
    #   mkdir -p $out/lua
    #
    #   ls -la target/debug
    #
    #   cp target/debug/libkubectl_client.* $out/lua
    #
    #   cd $out/lua
    #   for f in libkubectl_client.*; do
    #     mv "$f" "''${f#lib}"
    #   done
    #
    #   runHook postInstall
    # '';

    postInstall = ''
      mkdir -p $out/lua
      cp target/debug/libkubectl_client.* $out/lua/

      cd $out/lua
      for f in libkubectl_client.*; do
        if [ -f "$f" ]; then
          mv "$f" "''${f#lib}"
        fi
      done
    '';

    buildFeatures = ["telemetry"];

    buildType = "debug";

    meta = with lib; {
      description = "Kubectl integration for Neovim";
      license = licenses.asl20;
      platforms = platforms.all;
    };
  }
