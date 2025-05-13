{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    brainhive = {
      url = "github:brainhivenl/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    brainhive,
  }: {
    devShells = brainhive.lib.eachSystemPkgs (pkgs: {
      default = pkgs.brain.mkSdkShell {
        extraLibraries = with pkgs.darwin; [libiconv libresolv];
        packages = with pkgs; [brain.bazelisk];
      };
    });
  };
}
