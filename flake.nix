{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      nixpkgs,
      systems,
      ...
    }:
    let
      forAllSystems =
        function: nixpkgs.lib.genAttrs (import systems) (system: function nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        { pkgs, ... }:
        with pkgs;
        {
          apple-sdk = callPackage ./apple-sdk.nix { };
          bazelisk = (
            symlinkJoin {
              name = "bazelisk";
              paths = [ bazelisk ];
              buildInputs = [ makeWrapper ];
              postBuild = ''
                makeWrapper $out/bin/bazelisk $out/bin/bazel
              '';
            }
          );
        }
      );
    };
}
