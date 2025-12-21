{
  self,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    grc
    fish
    fzf
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.tide
  ];
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
        };
      }
    ];
    shellAliases = {
      ll = "ls -l";
    };
    functions = {
      # Function to kill processes by name
      kall = "pgrep -d ' ' $argv | xargs kill -15";
    };
  };
}
