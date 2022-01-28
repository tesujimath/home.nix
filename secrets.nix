{
  imports = [ ./third-party/alexey/home/modules/secureEnv/onePassword.nix ];

  config = {
    secureEnv.onePassword = {
      enable = true;
      sessionVariables = {
        EP_NUGET_SOURCE_PASS = {
          vault = "Private";
          item = "GitHub personal token for NuGET";
          field = "notes";
        };
      };
    };
  };
}
