{
  symlinkJoin,
  bazelisk,
}:
symlinkJoin {
  inherit (bazelisk) pname version meta;

  paths = [bazelisk];

  postBuild = ''
    ln -sf $out/bin/bazelisk $out/bin/bazel
  '';
}
