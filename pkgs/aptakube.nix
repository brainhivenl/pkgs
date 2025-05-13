{
  lib,
  stdenv,
  fetchurl,
  undmg,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aptakube";
  version = "1.11.5";

  src = fetchurl {
    url = "https://releases.aptakube.com/Aptakube_${finalAttrs.version}_universal.dmg";
    sha256 = "sha256-6X/IsukSpUJrcqcJWcYd5kczyVNe8WOtfbp0ErgdS+A=";
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
