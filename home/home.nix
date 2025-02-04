{ inputs, lib, pkgs, ... }: { 
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
      # better cat
      bat
      # better top
      btop
      discord
      # better ls
      eza
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
      # improved utilities
      "htop" = "btop";
      "cat" = "bat";
      "ls" = "eza";
      
  };

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
    ".config/sketchybar" = {
      source = ./sketchybar;
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

  programs = {
    atuin = import ./atuin.nix {inherit pkgs;};
    git = import ./git.nix {inherit pkgs;};
    kitty = import ./kitty.nix {inherit pkgs;};
    starship = import ./starship.nix {inherit pkgs;};
    zsh = import ./zsh.nix {inherit pkgs;};
  };
  imports = [
    ./sketchybar
  ];
}
