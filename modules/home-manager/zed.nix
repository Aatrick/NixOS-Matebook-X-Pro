{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
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
      "make"
      "neocmake"
    ];

    userSettings = {
      git_panel = {
        status_style = "icon";
        sort_by_path = true;
        collapse_untracked_diff = false;
        tree_view = true;
      };
      colorize_brackets = true;
      inlay_hints = {
        show_type_hints = false;
      };
      always_treat_brackets_as_autoclosed = false;
      toolbar = {
        code_actions = false;
      };
      hover_popover_delay = 200;

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
        folder_icons = false;
        file_icons = false;
        auto_reveal_entries = false;
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
      session = {
        trust_all_worktrees = true;
      };
      indent_guides = {
        enabled = false;
      };

      # Git
      git = {
        inline_blame = {
          enabled = false;
        };
      };

      file_scan_exclusions = [
        "**/.git"
        "**/node_modules"
        "**/target"
        "**/dist"
        "**/.venv"
        "**/build"
      ];
      base_keymap = "VSCode";

      # Layout & Appearance
      cursor_blink = false;
      bottom_dock_layout = "full";
      tab_bar = {
        show = false;
      };
      preview_tabs = {
        enabled = false;
      };
      minimap = {
        show = "never";
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
      ensure_final_newline_on_save = true;
      buffer_line_height = "comfortable";
      restore_on_startup = "last_session";
      ui_font_size = 16;
      buffer_font_size = 17.0;
      buffer_font_family = "MonaspiceNe Nerd Font";

      # Terminal
      terminal = {
        font_size = 17.0;
        font_family = "MonaspiceNe Nerd Font";
        button = false;
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
        model_parameters = [ ];
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
            "ty"
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
