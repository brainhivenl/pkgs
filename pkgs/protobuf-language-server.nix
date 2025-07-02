{
  buildGoModule,
  fetchFromGitHub,
}: let
  pname = "protobuf-language-server";
in
  buildGoModule {
    inherit pname;
    version = "0.1.1";

    src = fetchFromGitHub {
      owner = "lasorda";
      repo = "protobuf-language-server";
      rev = "ecab27467944346fb4227f90161d3ec823346646";
      hash = "sha256-hN91/yBcybF/4syItD1B03/qlR4cICYJQ3NNjIDBOrs=";
    };

    vendorHash = "sha256-4nTpKBe7ekJsfQf+P6edT/9Vp2SBYbKz1ITawD3bhkI=";

    checkPhase = "";

    postInstall = ''
      rm $out/bin/example
    '';

    meta.mainProgram = pname;
  }
