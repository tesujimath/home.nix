{ config, lib, ... }:

let
  cfg = config.tesujimath.agentic-engineering;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    xdg.configFile =
      let
        goose-providers = mkIf cfg.goose.enable {
          "goose/custom_providers/oMLX.json".text = builtins.toJSON {
            name = "oMLX";
            engine = "openai";
            display_name = "Local oMLX";
            description = "oMLX running on localhost";
            base_url = "http://localhost:8000/v1";
            models = [
              {
                name = "Devstral-Small-2-24B-Instruct-2512-4bit";
                context_limit = 393216;
              }
              {
                name = "Ornith-1.0-9B-4bit";
                context_limit = 262144;
              }
              {
                name = "Ornith-1.0-35B-5bit-XL-mlx";
                context_limit = 262144;
              }
              {
                name = "Qwen3.6-27B-MLX-4bit";
                context_limit = 262144;
              }
            ];
          };
        };
      in
      goose-providers;
  };
}
