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
        TEST_AURORA_MAIN_PASSWORD = {
          vault = "Dev - Shared DevOps";
          item = "AWS Test Aurora Main - RemoteAdmin";
          field = "password";
        };
        TEST_AURORA_MAIN_USERNAME = {
          vault = "Dev - Shared DevOps";
          item = "AWS Test Aurora Main - RemoteAdmin";
          field = "username";
        };
        TEST_AURORA_MAIN_HOST = {
          vault = "Dev - Shared DevOps";
          item = "AWS Test Aurora Main - RemoteAdmin";
          field = "server";
        };
        TEST_AURORA_STATS_PASSWORD = {
          vault = "Dev - Shared DevOps";
          item = "AWS Test Aurora Stats - RemoteAdmin";
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
          vault = "Dev - Shared DevOps";
          item = "wrmpodmfm2k6rijjj5dimhrnwq";
          field = "notesPlain";
        };
        staging_pem = {
          vault = "Dev - Shared DevOps";
          item = "uhpvoujfk2wgu7kpqrdc2heaby";
          field = "notesPlain";
        };
        loadtest01_pem = {
          vault = "Dev - Shared DevOps";
          item = "nztr4zuyig4jhac47tfgbo6vn4";
          field = "notesPlain";
        };
      };
    };
  };
}
