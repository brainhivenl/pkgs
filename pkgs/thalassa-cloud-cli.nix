{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "thalassa-cloud-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "thalassa-cloud";
    repo = "cli";
    rev = "9db1838d59257de08c17623dc9c76989b7022fcd";
    hash = "sha256-cubphVGdyu0Y2SlyVS+lzaOfAwGBcYVxJw7NK1d3/0o=";
  };

  vendorHash = "sha256-X43mgoO+ukIZd2y93csaD4DP20n3llOG7U9IvZl3FTw=";

  postInstall = ''
    mv $out/bin/cli $out/bin/tcloud
    rm $out/bin/tools
  '';

  meta.mainProgram = "tcloud";
}
