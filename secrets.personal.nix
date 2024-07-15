{
  imports = [ ./third-party/alexey/home/modules/secureEnv/onePassword.nix ];

  config = {
    secureEnv.onePassword = {
      enable = true;
      sessionVariables = { };
      sshKeys = {
        # the IDs may be found from `op list items`
      };
    };
  };
}
