{
  imports = [ ./third-party/alexey/home/modules/secureEnv/onePassword.nix ];

  config = {
    secureEnv.onePassword = {
      enable = true;
      sessionVariables = {
        EP_NUGET_SOURCE_PASS = {
          vault = "Private";
          item = "GitHub personal token for NuGET";
          field = "notesPlain";
        };
        SQLSERVER_MAIN_PASSWORD = {
          vault = "Dev - Shared";
          item = "Local SQL Server admin";
          field = "password";
        };
      };
      sshKeys = {
        # the IDs may be found from `op list items`
        sjg-ep = {
          vault = "Private";
          item = "rewjf4dvulthujute5tj7pkoum";
          field = "notesPlain";
        };
        test_ec2_keypair = {
          vault = "Dev - Shared Root";
          item = "hp3fuuqmfwbf3rj7naoyffx2za";
          field = "notesPlain";
        };
        staging_pem = {
          vault = "Dev - Shared Root";
          item = "izlxfcxdsfxp5xbd5t3ripnwim";
          field = "notesPlain";
        };
        loadtest01_pem = {
          vault = "Dev - Shared Root";
          item = "mzbwmqvuajtn3trebnc4o3ndve";
          field = "notesPlain";
        };
      };
    };
  };
}
