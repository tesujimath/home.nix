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
          field = "notes";
        };
        test_ec2_keypair = {
          vault = "Dev - Shared DevOps";
          item = "wrmpodmfm2k6rijjj5dimhrnwq";
          field = "notes";
        };
        staging_pem = {
          vault = "Dev - Shared DevOps";
          item = "uhpvoujfk2wgu7kpqrdc2heaby";
          field = "notes";
        };
        loadtest01_pem = {
          vault = "Dev - Shared DevOps";
          item = "nztr4zuyig4jhac47tfgbo6vn4";
          field = "notes";
        };
      };
    };
  };
}
