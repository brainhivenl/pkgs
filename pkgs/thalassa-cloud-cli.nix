{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "thalassa-cloud-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "thalassa-cloud";
    repo = "cli";
    rev = "64452f71607269c8a214264c71df9d4ad9025ea7";
    hash = "sha256-1L3FcwAyTfbjBfZJ9lpp43bmW0xwATKc+QZvIz1m71k=";
  };

  vendorHash = "sha256-JwGqt1Y0cyZaC3WEupJS0MTCQKsABtMtE8V4Z701+5Q=";

  postInstall = ''
    mv $out/bin/cli $out/bin/tcloud
    rm $out/bin/tools
  '';

  meta.mainProgram = "tcloud";
}
