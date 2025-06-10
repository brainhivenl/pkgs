{
  lib,
  stdenv,
  fetchurl,
  undmg,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aptakube";
  version = "1.11.6";

  src = fetchurl {
    url = "https://releases.aptakube.com/Aptakube_${finalAttrs.version}_universal.dmg";
    sha256 = "sha256-z9PNmf6KNeHeYycEZF7rJWu22UJffJVuLU4J4upQi60=";
  };

  nativeBuildInputs = [
    undmg
  ];

  unpackPhase = ''
    undmg $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r Aptakube.app $out/Applications/Aptakube.app
  '';

  meta = with lib; {
    platforms = platforms.darwin;
    # license = licenses.unfree;
  };
})
