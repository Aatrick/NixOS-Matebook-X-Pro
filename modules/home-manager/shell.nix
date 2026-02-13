{
  self,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    grc
    fish
    fzf
  ];
  programs.starship = {
    enable = true;
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      # Source home-manager session variables (POSIX to Fish translation)
      if test -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
          cat "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" | while read -l line
              if string match -qr '^export ' $line
                  set -l entry (string replace -r '^export ' ''' $line | string split -m 1 '=')
                  set -l key $entry[1]
                  set -l val (string trim -c '"' $entry[2])
                  set -gx $key $val
              end
          end
      end
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
      {
        name = "fisher";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "fisher";
          rev = "4.4.4";
          hash = "sha256-e8gIaVbuUzTwKtuMPNXBT5STeddYqQegduWBtURLT3M=";
        };
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
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
