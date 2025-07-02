{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.languages.protobuf;
in {
  options.languages.protobuf = with lib; {
    enable = mkEnableOption "Whether to enable protobuf language support";
  };

  config = lib.mkIf cfg.enable {
    packages = with pkgs; [
      protobuf
      brain.protobuf-language-server
    ];
  };
}
