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
      # top bar for macos
      sketchybar
      sketchybar-app-font
    ];

    services.skhd.enable = true;
    services.sketchybar.enable = true;
    services.yabai.enable = true;
    services.jankyborders.enable = true;

    homebrew = {
        enable = true;
        brews = [
          "mas"
          "rust"
        ];
        casks = [
        "cursor"
        "firefox"
        "font-sf-pro"
        "macs-fan-control"
        "nordvpn"
        "karabiner-elements"
        # temporary office
        "microsoft-teams"
        "zoom"
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
      nerd-fonts.fira-mono
      nerd-fonts.profont

    ];

    # Custom MacOS settings
    system = {
      startup.chime = false;
      defaults = {
        dock = {
          autohide = true;
          persistent-apps = [];
          persistent-others = ["/Users/simon/Downloads"];
          tilesize = 44;
        };
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          FXEnableExtensionChangeWarning = false;
          FXPreferredViewStyle = "Nlsv";
          NewWindowTarget = "Home";
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowPathbar = true;
          ShowRemovableMediaOnDesktop = false;
          ShowStatusBar = true;
          _FXShowPosixPathInTitle = true;
        };
        LaunchServices = {
          LSQuarantine = false;
        };
        screencapture = {
          disable-shadow = true;
          location = "~/Desktop";
          target = "clipboard";
        };
        trackpad = {
          Clicking = true;
        };
        NSGlobalDomain = {
          "AppleICUForce24HourTime" = true;
          "AppleScrollerPagingBehavior" = true;
          # Change trackpad speed
          "com.apple.trackpad.scaling" = 3.0;
          # Hide Menu bar
          "_HIHideMenuBar" = true;
          "InitialKeyRepeat" = 15;
          "KeyRepeat" = 1;
        };
        CustomSystemPreferences = {
          # defaults write com.apple.dock autohide -bool true
          # defaults write com.apple.dock "mru-spaces" -bool "false"
        };
      };
    };

    # Add sudo by fingerprint
    security.pam.enableSudoTouchIdAuth = true;

    # Auto upgrade nix package and the daemon service
    services.nix-daemon.enable = true;
    # nix.package = pkgs.nix;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Enable alternative shell support in nix-darwin.
    programs.zsh.enable = true; # default shell on catalina

    # TODO
    # Set Git commit hash for darwin-version.
    # system.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
}
