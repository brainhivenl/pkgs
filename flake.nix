{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-darwin";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
  }: {
    lib = with nixpkgs.lib; {
      eachSystem = genAttrs (import systems);

      eachSystemOverlayedPkgs = overlays: func:
        self.lib.eachSystem (
          system:
            func (import nixpkgs {inherit system overlays;})
        );

      eachSystemPkgs = self.lib.eachSystemOverlayedPkgs [self.overlays.default];
    };

    packages = self.lib.eachSystemPkgs ({callPackage, ...}: {
      aptakube = callPackage ./pkgs/aptakube.nix {};
      bazelisk = callPackage ./pkgs/bazelisk.nix {};
      apple-sdk = callPackage ./pkgs/apple-sdk.nix {};
    });

    formatter = self.lib.eachSystemPkgs ({alejandra, ...}: alejandra);

    overlays = {
      default = final: prev: let
        packages = self.packages.${prev.system};
      in {
        brain = {
          inherit
            (packages)
            aptakube
            bazelisk
            apple-sdk
            ;
          mkSdkShell = prev.callPackage ./pkgs/sdk-shell.nix {inherit (packages) apple-sdk;};
        };
      };
    };

    templates = {
      bazel-flake = {
        path = ./templates/bazel;
        description = "Simple flake for Rust development with the Bazel build system";
      };
    };
  };
}
