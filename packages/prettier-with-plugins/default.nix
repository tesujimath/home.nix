{ buildNpmPackage
, fetchFromGitHub
, makeWrapper
, nodePackages
, symlinkJoin
}:
let
  prettierPluginJinjaTemplate = buildNpmPackage
    rec {
      pname = "prettier-plugin-jinja-template";
      version = "v2.0.0";
      src = fetchFromGitHub {
        owner = "davidodenwald";
        repo = pname;
        rev = version;
        hash = "sha256-5xPR305Ux0SFhoBFJ3XdlOY2PqtAqZn1PQAy38HCJss=";
      };
      npmDepsHash = "sha256-dlQkvji36Za86lAt5ds8nphDnu2uA28tNZqZKzt2o5A=";
      dontNpmPrune = true;
    };
in

symlinkJoin {
  name = "prettier-with-plugins";
  paths = [
    nodePackages.prettier
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/prettier \
      --add-flags "--plugin=${prettierPluginJinjaTemplate}/lib/node_modules/prettier-plugin-jinja-template/lib/index.js"
  '';
}
