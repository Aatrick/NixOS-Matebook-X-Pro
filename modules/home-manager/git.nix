{ ... }: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name  = "Aatricks";
        email = "melis.emilio1@gmail.com";
      };
    };
  };
}
