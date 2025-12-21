{...}: {
  programs.git = {
    enable = true;
    settings = {
      credential.helper = "!gh auth git-credential";
      user = {
        name = "Aatricks";
        email = "melis.emilio1@gmail.com";
      };
    };
  };
}
