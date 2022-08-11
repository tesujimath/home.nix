{
  programs.ssh = {
    matchBlocks = {
      "test-gha-runner" = {
        user = "ubuntu";
        hostname = "10.0.5.63";
      };
    };
  };
}
