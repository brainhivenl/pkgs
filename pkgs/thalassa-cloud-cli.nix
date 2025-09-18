{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "thalassa-cloud-cli";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "thalassa-cloud";
    repo = "cli";
    rev = "1e7c1bfb5004da4fcdb647905163a367cae7afcc";
    hash = "sha256-ANewyJhoPog7Jl4HFzzeDP6J7pIMBu6oPpi7bdhPPRc=";
  };

  vendorHash = "sha256-mjZCzeq7yTWY3S89VQsvLMubGgh+BmfKv3to+JYGiTc=";

  postInstall = ''
    mv $out/bin/cli $out/bin/tcloud
    rm $out/bin/tools
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev or "unknown"}"
    "-X main.branch=${src.ref or "main"}"
    "-X main.date=1970-01-01T00:00:00Z"
    "-X main.builtBy=nix"
  ];

  meta.mainProgram = "tcloud";
}
