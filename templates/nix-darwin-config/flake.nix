{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    brainhive = "github:brainhivenl/pkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
  } @ inputs: {
    darwinSystems."<your-hostname>" = nix-darwin.lib.darwinSystem {
      modules = [./configuration.nix];
      specialArgs = {inherit inputs;};
    };
  };
}
