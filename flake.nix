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
      bazelisk = callPackage ./pkgs/bazelisk.nix {};
      apple-sdk = callPackage ./pkgs/apple-sdk.nix {};
      thalassa-cloud-cli = callPackage ./pkgs/thalassa-cloud-cli.nix {};
      protobuf-language-server = callPackage ./pkgs/protobuf-language-server.nix {};
    });

    formatter = self.lib.eachSystemPkgs ({alejandra, ...}: alejandra);

    overlays = {
      default = final: prev: let
        packages = self.packages.${prev.system};
      in {
        brain = {
          inherit (prev) aptakube;
          inherit
            (packages)
            bazelisk
            apple-sdk
            thalassa-cloud-cli
            protobuf-language-server
            ;
          mkSdkShell = prev.callPackage ./pkgs/sdk-shell.nix {inherit (packages) apple-sdk;};
        };
      };
    };

    templates = {
      bazel-devenv = {
        path = ./templates/bazel;
        description = "Devenv for Rust development with the Bazel build system";
      };
      kubernetes-devenv = {
        path = ./templates/kubernetes;
        description = "Devenv for local development with kubernetes, powered by k3s and skaffold";
      };
    };
  };
}
