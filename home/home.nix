{ lib, pkgs, ... }: { 
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
      atuin
      # better top
      btop
      discord
      # command-line fuzzy finder
      fzf
      gh
      git
      # colored borders for user windows on macos
      jankyborders
      # terminal emulator
      kitty
      lua
      # python env and package manager
      micromamba
      neovim
      nodejs_23
      # sketchybar dependency
      nowplaying-cli
      pre-commit
      # fzf dependency
      ripgrep
      signal-desktop
      # top bar for macos
      sketchybar
      sketchybar-app-font
      # keyboard shortcut daemon for macos
      skhd
      spotify
      # macos top bar
      sketchybar
      # terminal prompt
      starship
      # sketchybar dependency
      switchaudio-osx
      telegram-desktop
      tmux
      # invert scroll direction of physical scroll wheels
      unnaturalscrollwheels
      vscode
      wget
      whatsapp-for-mac
      # tiling window manager for macos
      yabai
      zsh
  ];

  home.file = {
    ".config/borders" = {
      source = ./borders;
      recursive = true;
    };
    ".config/kanata" = {
      source = ./kanata;
      recursive = true;
    };
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    ".config/skhd" = {
        source = ./skhd;
        recursive = true;
    };
    ".config/yabai" = {
        source = ./yabai;
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

  programs = {
    kitty = import ./kitty.nix {inherit pkgs;};
  }
  programs.zsh = {
      enable = true;
      autosuggestion = {
          enable = true;
      };
      syntaxHighlighting.enable = true;
  };
  
  programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        scan_timeout = 10;
      };
  };

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

  programs.atuin.enable = true;
}