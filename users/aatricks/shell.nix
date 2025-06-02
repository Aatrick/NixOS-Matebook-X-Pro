{ pkgs, ... }: {
  home.packages = with pkgs; [
    fish
    fishPlugins.done
    fishPlugins.fzf-fish
	  fishPlugins.forgit
	  fishPlugins.hydro
	  fishPlugins.grc
  ];
  programs.fish = {
    enable = true;
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
