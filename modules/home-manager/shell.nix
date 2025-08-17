{ self, pkgs , ... }: {
  home.packages = with pkgs; [
    grc
    fish
    fishPlugins.done
    fishPlugins.fzf-fish
	  fishPlugins.forgit
	  fishPlugins.hydro
	  fishPlugins.grc
	  fzf
  ];
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      # Manually packaging and enable a plugin
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
      update = "sudo nix-channel --update
                sudo nix-env -u --always
                sudo nixos-rebuild boot --upgrade-all
                sudo rm /nix/var/nix/gcroots/auto/*
                sudo nix-store --gc
                sudo nix-collect-garbage -d
                ";
      clean  = "sudo nix-env -u --always
                sudo nix-store --gc
                ";
      killall = "pgrep -d ' ' $1 | xargs kill -15";
    };
  };
}
