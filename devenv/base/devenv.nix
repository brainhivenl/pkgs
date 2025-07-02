{brainhive, ...}: {
  overlays = [brainhive.overlays.default];

  imports = [
    "${brainhive.outPath}/modules/bazel.nix"
    "${brainhive.outPath}/modules/kubernetes.nix"
    "${brainhive.outPath}/modules/protobuf.nix"
  ];
}
