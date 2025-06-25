{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "thalassa-cloud-cli";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "thalassa-cloud";
    repo = "cli";
    rev = "9250bc8bf294446f6519c5147aad466a3c4a6a4f";
    hash = "sha256-rsimcFG2uwwpsJEUpJuP7CA5AwyITFV65yCg75fcisU=";
  };

  vendorHash = "sha256-e9z5QGlbJ0LM1z8AUNzjGiOSkPExBQHdwJWdGxv/Zxc=";

  postInstall = ''
    mv $out/bin/cli $out/bin/tcloud
    rm $out/bin/tools
  '';

  meta.mainProgram = "tcloud";
}
