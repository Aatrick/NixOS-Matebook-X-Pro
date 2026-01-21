{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
    package = pkgs-unstable.zed-editor;
    extensions = [
      "html"
      "toml"
      "nix"
      "pyrefly"
      "dockerfile"
      "sql"
      "git-firefly"
      "angular"
      "java"
      "kotlin"
      "material-icon-theme"
      "flat-themes"
      "vue"
    ];

    userSettings = {
      # Notification & Panels
      notification_panel = {
        button = false;
      };
      collaboration_panel = {
        button = false;
      };
      project_panel = {
        hide_hidden = true;
        hide_root = true;
        button = true;
      };
      debugger = {
        button = false;
      };
      search = {
        button = false;
      };
      diagnostics = {
        button = false;
      };
      session= {
        trust_all_worktrees= true;
      };

      # Git
      git = {
        inline_blame = {
          enabled = false;
        };
      };

      # Layout & Appearance
      cursor_blink = false;
      bottom_dock_layout = "full";
      tab_bar = {
        show = false;
      };
      title_bar = {
        show_sign_in = true;
        show_branch_icon = false;
      };
      status_bar = {
        active_language_button = false;
        cursor_position_button = false;
      };
      theme = {
        mode = "system";
        light = "Flat Light";
        dark = "Flat Gray";
      };
      icon_theme = "Material Icon Theme";

      # Editor Settings
      gutter = {
        line_numbers = true;
      };
      soft_wrap = "editor_width";
      scrollbar = {
        axes = {
          horizontal = false;
        };
        show = "auto";
      };
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      buffer_line_height = "comfortable";
      restore_on_startup = "last_session";
      ui_font_size = 16;
      buffer_font_size = 17.0;
      buffer_font_family = "MonaspiceNe Nerd Font";

      # Terminal
      terminal = {
        button = false;
        font_family = "MonaspiceNe Nerd Font";
      };

      # AI & Features
      features = {
        edit_prediction_provider = "copilot";
      };
      edit_predictions = {
        mode = "subtle";
      };
      agent = {
        dock = "left";
        always_allow_tool_actions = true;
        default_profile = "write";
        default_model = {
          provider = "copilot_chat";
          model = "grok-code-fast-1";
        };
        model_parameters = [];
      };

      # Telemetry
      telemetry = {
        diagnostics = true;
        metrics = false;
      };

      # Languages
      languages = {
        "Python" = {
          language_servers = [
            "pyrefly"
            "!pyright"
            "!pylsp"
          ];
          inlay_hints = {
            show_background = false;
            enabled = true;
          };
          soft_wrap = "editor_width";
        };
      };

      # LSP Configuration
      lsp = {
        pyrefly = {
          binary = {
            path = "${pkgs.pyrefly}";
            arguments = ["lsp"];
          };
          settings = {
            python = {
              pythonPath = ".venv/bin/python";
            };
            pyrefly = {
              project_includes = [
                "src/**/*.py"
                "tests/**/*.py"
              ];
              project_excludes = [
                "**/.[!/.]*"
                "**/*venv/**"
              ];
              search_path = ["src"];
              ignore_errors_in_generated_code = true;
            };
          };
        };
        basedpyright = {
          settings = {
            typeCheckingMode = "standard";
            "basedpyright.analysis" = {
              diagnosticMode = "workspace";
              inlayHints = {
                callArgumentNames = false;
              };
            };
          };
        };
        jdtls = {
          settings = {
            lombok_support = true;
          };
        };
      };
      
      load_direnv = "shell_hook";
    };
  };
}
