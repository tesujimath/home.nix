{ config, lib, pkgs, ... }:

let
  cfg = config.tesujimath.agentic-engineering;
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) fetchFromGitHub;
in
{
  options.tesujimath.agentic-engineering = {
    enable = mkEnableOption "agentic-engineering";
  };

  config = mkIf cfg.enable {
    programs = {
      cursor.enable = true;
    };

    home =
      let
        skills = {
          mattpocock = {
            src = fetchFromGitHub {
              owner = "mattpocock";
              repo = "skills";
              rev = "8370e760d0251a3738e006aeacec6d1cb31dd208";
              sha256 = "sha256-+Crwt+cP8B6wiIsthpwFUBgRHeTSRoPm2YASZEQE/9k=";
            };
            path = {
              # productivity
              grill-me = "skills/productivity/grill-me";
              grilling = "skills/productivity/grilling";
              handoff = "skills/productivity/handoff";
              teach = "skills/productivity/teach";
              writing-great-skills = "skills/productivity/writing-great-skills";

              # engineering
              ask-matt = "skills/engineering/ask-matt";
              codebase-design = "skills/engineering/codebase-design";
              diagnosing-bugs = "skills/engineering/diagnosing-bugs";
              domain-modeling = "skills/engineering/domain-modeling";
              grill-with-docs = "skills/engineering/grill-with-docs";
              implement = "skills/engineering/implement";
              improve-codebase-architecture = "skills/engineering/improve-codebase-architecture";
              prototype = "skills/engineering/prototype";
              resolving-merge-conflicts = "skills/engineering/resolving-merge-conflicts";
              setup-matt-pocock-skills = "skills/engineering/setup-matt-pocock-skills";
              tdd = "skills/engineering/tdd";
              to-issues = "skills/engineering/to-issues";
              to-prd = "skills/engineering/to-prd";
              triage = "skills/engineering/triage";
            };
          };

          andrej-karpathy = {
            src = fetchFromGitHub {
              owner = "multica-ai";
              repo = "andrej-karpathy-skills";
              rev = "2c606141936f1eeef17fa3043a72095b4765b9c2";
              sha256 = "sha256-4z/wRdYH7UXRzF8RJU0sw8xbpx0BW/7CBv5sVEC2knY=";
            };
            path = {
              # karpathy-guidelines = "skills/karpathy-guidelines";
            };
          };
        };

        skillFiles = lib.concatMapAttrs
          (_: skill:
            lib.mapAttrs'
              (name: path:
                lib.nameValuePair
                  ".claude/skills/${name}"
                  { source = "${skill.src}/${path}"; }
              )
              skill.path
          )
          skills;
      in
      {
        packages = with pkgs; [
          claude-code
          claude-agent-acp
          cursor-cli
          opencode
          qwen-code
        ];

        file = skillFiles;
      };
  };
}
