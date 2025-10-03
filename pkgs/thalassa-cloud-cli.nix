{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "thalassa-cloud-cli";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "thalassa-cloud";
    repo = "cli";
    rev = "b8aa8ba4694c3c2f456d107d92c038a79e071cf6";
    hash = "sha256-ePetYJzgml9wylEe2BQRl9UFQXjLP0BiZaXqTKdFpLE=";
  };

  vendorHash = "sha256-HaHOv2ZF6rTLzEETi3cR3Q9qytgWOCOA4jZRR/bE8O8=";

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
