{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.kubernetes;

  useK3d = cfg.clusterName != null;
  useSkaffold = cfg.defaultRepo != null;
in {
  options.kubernetes = with lib; {
    enable = mkEnableOption "Whether to enable local Kubernetes integrations";

    clusterName = mkOption {
      type = types.nullOr types.str;
      description = "Name of local K3D cluster";
      default = null;
    };

    namespace = mkOption {
      type = types.nullOr types.str;
      description = "Default kubernetes namespace to execute skaffold in";
      default = null;
    };

    defaultRepo = mkOption {
      type = types.nullOr types.str;
      description = "Path to default registry skaffold should use";
      default = null;
    };

    skaffoldCommand = mkOption {
      type = types.enum ["run" "dev" "debug"];
      description = "Default command skaffold should execute";
      default = "dev";
    };
  };

  config = lib.mkIf cfg.enable {
    packages = with pkgs; [
      kubectl
      kubie
      k3d
      skaffold
      kubernetes-helm
    ];

    env = {
      SKAFFOLD_DEFAULT_REPO = lib.optionalString useSkaffold cfg.defaultRepo;
    };

    process.managers.process-compose.tui.enable = lib.mkDefault false;

    processes = {
      k3d = lib.mkIf useK3d {
        exec = "k3d cluster start ${cfg.clusterName}";
      };
      skaffold = lib.mkIf useSkaffold {
        exec = "kubie exec k3d-${cfg.clusterName} ${cfg.namespace} skaffold ${cfg.skaffoldCommand} --cleanup=false";
      };
    };
  };
}
