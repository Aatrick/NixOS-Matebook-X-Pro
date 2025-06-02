{ pkgs, pkgs-unstable, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;
    extensions = ["html" "toml" "make" "neocmake"];

    userSettings = {
    agent = {
      default_profile = "minimal";
      inline_assistant_model = {
        provider = "copilot_chat";
        model = "gpt-4.1";
      };
      default_model = {
        provider = "copilot_chat";
        model = "gpt-4.1";
      };
      version = "2";
      button = false;
      enable_experimental_live_diffs = true;
    };

    hour_format = "hour24";
    auto_update = true;
    telemetry.enable = false;
    terminal = {
      alternate_scroll = "off";
      blinking = "off";
      copy_on_select = false;
      dock = "bottom";
      detect_venv = {
        on = {
          directories = [".env" "env" ".venv" "venv"];
          activate_script = "default";
        };
      };
      env = {
        TERM = "alacritty";
      };
      font_features = null;
      font_size = null;
      line_height = "comfortable";
      option_as_meta = false;
      button = false;
      shell = "system";
      #{
      #                    program = "zsh";
      #};
      toolbar = {
          title = false;
      };
      working_directory = "current_project_directory";
    };
    languages = {
    "Python" = {
        language_servers = [ "ruff" "pyright" ];
        format_on_save = "on";
        formatter = [

        ];
    };
    "Nix" = {
        language_servers = [ "nil" ];
        format_on_save = "on";
    };
    };
    lsp = {
      clangd = {
        binary.arguments = [ "--compile-commands-dir=build" ];
      };
      pyright = {
        settings = {
          python.analysis = {
            diagnosticMode = "workspace";
            typeCheckingMode = "strict";
          };
          python = {
            pythonPath = ".venv/bin/python";
          };
        };
      };
      rust-analyzer = {
        binary = {
          path = lib.getExe pkgs.rust-analyzer;
          path_lookup = true;
        };
      };
      nix = {
        binary = {
          path_lookup = true;
        };
      };
    };


    ## tell zed to use direnv and direnv can use a flake.nix enviroment.
    load_direnv = "shell_hook";
    base_keymap = "VSCode";
    icon_theme = "Material Icon Theme";
    theme = {
    mode = "system";
    light = "One Light";
    dark = "Material Theme Darker";
    };
    show_whitespaces = "none" ;
    ui_font_size = 16;
    buffer_font_size = 16;
    diagnostics.include_warnings = true;
    collaboration_panel.button = true;
    chat_panel.button = "when_in_call";
    show_wrap_guides = false;
    tab_bar.show = false;
    show_edit_predictions = true;
    edit_predictions.enabled = true;
    edit_predictions.mode = "subtle";
    soft_wrap = "bounded";
    soft_wrap_column = 80;
    notification_panel.button = false;
    autosave = "on_focus_change";
    open_files_in_new_window = false;

    calls = {
      mute_on_join = true;
      share_on_join = true;
    };

    };
  };
}
