{ ... }:
{
  programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "!gh auth git-credential";
    };
    settings = {
      user = {
        name = "Aatricks";
        email = "melis.emilio1@gmail.com";
      };
    };
  };
}
