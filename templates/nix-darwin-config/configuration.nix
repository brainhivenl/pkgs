{
  pkgs,
  lib,
  inputs,
}: {
  nixpkgs.overlays = [inputs.brainhive.overlays.default];

  packages = with pkgs; [
    direnv
    devenv

    brain.aptakube
  ];

  programs.zsh = {
    enable = true;
    shellInit = ''
      eval "${lib.getExe pkgs.direnv} hook zsh"
    '';
  };

  system.stateVersion = 6;
}
