{ pkgs, ... }: { 
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "simon";
  home.homeDirectory = "/Users/simon";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
      git
      # terminal emulator
      kitty
      starship
      zsh
  ];

  home.file = {
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
  };

  home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "code";
  };

  home.shellAliases = {
      # aliases for common dirs
      "home" = "cd ~";
      # misc  aliases
      ".." = "cd ..";
      "x" = "exit";
      "vi" = "nvim";
      "mm" = "micromamba";
      # git aliases
      "add" = "git add";
      "commit" = "git commit";
      "pull" = "git pull";
      "gss" = "git status --short";
      "stat" = "git status";
      "gdiff" = "git diff HEAD";
      "vdiff" = "git difftool HEAD";
      "log" = "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      "push" = "git push";
      "g" = "lazygit";
      "gaa" = "git add .";
      "gac" = "git add .; git commit -m 'auto-commit'; git push";
      "gacpp" = "git add .; git commit -m 'auto-commit'; git push; ssh disco-world 'cd /itet-stor/siwachte/net_scratch/fingnn && git pull'";
      # keybinding help
      "helpskhd" = "cat ~/.config/skhd/skhdrc";
      "helpyabai" = "cat ~/.config/yabai/yabairc";
      "ssh" = "TERM=xterm-256color ssh";
  };

  programs.zsh = {
      enable = true;
      autosuggestion = {
          enable = true;
      };
      syntaxHighlighting.enable = true;
  };
  
  programs.starship.enable = true;

  programs.git = {
      enable = true;
      userName = "niedo";
      userEmail = "57731234+ni3do@users.noreply.github.com";
      ignores = [ ".DS_Store" ];
      extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
      };
  };

  programs.kitty = {
      enable = true;
      font = {
          name = "JetBrainsMono Nerd Font";
          size = 13.0;
      };
      themeFile = "tokyo_night_moon";
      settings = {
          macos_quit_when_last_window_closed = "yes";
          hide_window_decorations = "titlebar-only";
          tab_bar_edge = "top";
          tab_bar_style = "powerline";
          tab_powerline_style = "round";
          tab_activity_symbol = "";
          tab_title_max_length = 45;
          tab_title_template = "{fmt.fg.red}{bell_symbol}{fmt.fg.tab} {index}: ({tab.active_oldest_exe}) {title} {activity_symbol}";
      };
  };
}
