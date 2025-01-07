{ self, pkgs, lib, config, ... }: {

    # Declare the user that will be running `nix-darwin`.
    users.users.simon = {
        name = "simon";
        home = "/Users/simon";
    };

    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = with pkgs; [
        # better htop
        btop
        discord
        # command-line fuzzy finder
        fzf
        gh
        # colored borders for user windows on macos
        jankyborders
        lua
        # python env and package manager
        micromamba
        neovim
        nodejs_23
        # sketchybar dependency
        nowplaying-cli
        pre-commit
        signal-desktop
        # top bar for macos
        sketchybar
        sketchybar-app-font
        # keyboard shortcut daemon for macos
        skhd
        spotify
        # terminal prompt
        starship
        # sketchybar dependency
        switchaudio-osx
        telegram-desktop
        tmux
        # invert scroll direction of physical scroll wheels
        unnaturalscrollwheels
        wget
        whatsapp-for-mac
        # tiling window manager for macos
        yabai
        zsh-autosuggestions
        zsh-fast-syntax-highlighting
      ];

    services.skhd.enable = true;
    services.sketchybar.enable = false;
    services.yabai.enable = true;


    homebrew = {
        enable = true;
        brews = [
          "mas"
        ];
        casks = [
        "cursor"
        "firefox"
        "font-delugia-mono-complete"
        "macs-fan-control"
        "nordvpn"
        ];
        masApps = {
            "AdGuard for Safari" = 1440147259;
            "Bitwarden" = 1352778147; 
            "Wireguard" = 1451685025;
            "Vimari" = 1480933944;
          };
        onActivation.cleanup = "zap";
      };

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    # system.activationScripts.applications.text = let
    #   env = pkgs.buildEnv {
    #     name = "system-applications";
    #     paths = config.environment.systemPackages;
    #     pathsToLink = "/Applications";
    #   };
    # in
    #   pkgs.lib.mkForce ''
    #     # Set up applications.
    #     echo "setting up /Applications..." >&2
    #     rm -rf /Applications/Nix\ Apps
    #     mkdir -p /Applications/Nix\ Apps
    #     find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
    #     while read -r src; do
    #       app_name=$(basename "$src")
    #       echo "copying $src" >&2
    #       ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
    #     done
    #   '';

    # Add sudo by fingerprint
    security.pam.enableSudoTouchIdAuth = true;

    # Auto upgrade nix package and the daemon service
    services.nix-daemon.enable = true;
    # nix.package = pkgs.nix;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Enable alternative shell support in nix-darwin.
    programs.zsh.enable = true; # default shell on catalina
    # programs.fish.enable = true;

    # TODO
    # Set Git commit hash for darwin-version.
    # system.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
}
