{ pkgs
, ...
}:
let
  sketchybar = "${pkgs.sketchybar}/bin/sketchybar";
  aerospace = "${pkgs.aerospace}/bin/aerospace";
  jq = "${pkgs.jq}/bin/jq";
  sketchyAppBarFontName = "sketchybar-app-font";
  # export a function __icon_map that map the name of the app to the icon
  # Call it `__icon_map "Figma"`
  # Then you will have the result in the variable $icon_result (for example ":figma:")
  sketchyAppBarFontSh = builtins.fetchurl {
    url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/icon_map.sh";
    sha256 = "0dryim93c6ln2h6whlb0cs5y50yyz8klp4aq6cfl2ys4aj21ad8n";
  };
  nerdfontFontName = "FiraCode Nerd Font";
  sfProFontName = "SF Pro";
  sfProYOffset = "1";

  frontAppPlugin = pkgs.writeShellScript "front_app.sh" ''
    source "${sketchyAppBarFontSh}"
    if [ "$SENDER" = "front_app_switched" ]; then
      __icon_map "''${INFO}"
      ${sketchybar} --set "$NAME" label="$INFO" icon=$icon_result
    fi
  '';

  frontAppTitlePlugin = pkgs.writeShellScript "front_app_title.sh" ''
    focused_window_title=$(${aerospace} list-windows --focused --format "%{window-title}")
    ${sketchybar} --set "$NAME" label="$focused_window_title"
  '';

  queryAerospaceWorkspace = "${aerospace} list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json";
  queryAerospaceWindows = "${aerospace} list-windows --all --format '%{app-name} %{workspace}' --json";

  highlightSpaceIconColor = "0xFFFFB74D";
  highlightSpaceLabelColor = "0xC0FFB74D";
  highlightSpaceBorderColor = "0xF0FFB74D";
  highlightSpaceBorderWidth = "2";

  normalSpaceIconColor = "0xFFFFFFFF";
  normalSpaceLabelColor = "0xFF992B3F5";
  normalSpaceBorderColor = "0xA092B3F5";
  normalSpaceBorderWidth = "1";

  # Called when the workspace change
  # https://nikitabobko.github.io/AeroSpace/guide#exec-on-workspace-change-callback
  # AEROSPACE_FOCUSED_WORKSPACE - the workspace user switched to
  # AEROSPACE_PREV_WORKSPACE - the workspace user switched from
  # It is important for this call to be fast, we will let the update loop correctly highlight visible workspaces as such
  # Any call to aerospace here is slow AF
  # If aerospace queries get cheaper in the future we can do more, but for now this is just too slow
  onWorkspaceChangedPlugin = pkgs.writeShellScript "on_workspace_changed.sh" ''
    ${sketchybar} --set "space.$1" background.border_color=${highlightSpaceBorderColor} label.color=${highlightSpaceLabelColor} icon.color=${highlightSpaceIconColor} background.border_width=${highlightSpaceBorderWidth}

    if [ "$2" = "" ]; then
      exit 0
    fi

    # For quick feedback, always reset the previous workspace
    # This heuristic will fail when changing monitor, but it's a good enough approximation
    ${sketchybar} --set "space.$2" background.border_color=${normalSpaceBorderColor} label.color=${normalSpaceLabelColor} icon.color=${normalSpaceIconColor} background.border_width=${normalSpaceBorderWidth}
  '';

  # We are stuck with 2 call to aerospace minimum
  # One to get the list of workspaces
  # One to get all applications
  #
  # The loop is responsible:
  # - to update the current opened windows in the workspace
  # - to update the current window title
  # - update the workspace display
  updateLoop = pkgs.writeShellScript "update_loop.sh" ''
    # Those query take a lot of time (100ms)
    workspace_query_json=$(${queryAerospaceWorkspace})
    windows_query_json=$(${queryAerospaceWindows})

    # Update per workspace
    for workspace in $(echo $workspace_query_json | ${jq} -r ".[] | .workspace"); do
      workspace_display_id=$(echo "$workspace_query_json" | ${jq} -r ".[] | select(.workspace == \"$workspace\") | .\"monitor-appkit-nsscreen-screens-id\"")

      # Get all the windows in the workspace
      windows_in_workspace=$(echo "$windows_query_json" | ${jq} -r ".[] | select(.workspace == \"$workspace\") | .\"app-name\"")

      # check if any windows in the workspace
      if [ "$windows_in_workspace" = "" ]; then
        label="-"
        label_font="${nerdfontFontName}:Bold:12.0"
      else
        source "${sketchyAppBarFontSh}"
        label=""
        label_font="${sketchyAppBarFontName}:Normal:12.0"
        # Set IFS to newline to handle multi-word app names correctly
        IFS=$'\n'
        for window in $windows_in_workspace; do
          __icon_map "$window"
          icon_result=$icon_result
          label="$label$icon_result"
        done
        # Reset IFS to its default value
        unset IFS
      fi

      ${sketchybar} --set "space.$workspace" \
        label="$label" \
        label.font="$label_font" \
        display="$workspace_display_id"
    done

    # Update the current front app title
    focused_window_title=$(${aerospace} list-windows --focused --format "%{window-title}")
    ${sketchybar} --set "front_app.title" label="$focused_window_title"
  '';

  infiniteUpdateLoop = pkgs.writeShellScript "infinite_update_loop.sh" ''
    while true; do
      ${pkgs.bash}/bin/bash -c ${updateLoop}
      sleep 1
    done
  '';

  batteryPlugin = pkgs.writeShellScript "battery.sh" ''
    PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
    CHARGING="$(pmset -g batt | grep 'AC Power')"

    if [ "$PERCENTAGE" = "" ]; then
      exit 0
    fi

    case "''${PERCENTAGE}" in
      9[0-9]|100) ICON="􀛨"
      ;;
      [6-8][0-9]) ICON="􀺸"
      ;;
      [3-5][0-9]) ICON="􀺶"
      ;;
      [1-2][0-9]) ICON="􀛩"
      ;;
      *) ICON="􀛪"
    esac

    if [[ "$CHARGING" != "" ]]; then
      ICON="􀢋"
    fi

    # The item invoking this script (name $NAME) will get its icon and label
    # updated with the current battery status
    ${sketchybar} --set "$NAME" icon="$ICON" label="''${PERCENTAGE}%"
  '';

  clockPlugin = pkgs.writeShellScript "clock.sh" ''
    sketchybar --set "$NAME" label="$(date '+%d/%m %H:%M')"
  '';

  volumePlugin = pkgs.writeShellScript "volume.sh" ''
    if [ "$SENDER" = "volume_change" ]; then
      VOLUME="$INFO"

      case "$VOLUME" in
        [6-9][0-9]|100) ICON="󰕾"
        ;;
        [3-5][0-9]) ICON="󰖀"
        ;;
        [1-9]|[1-2][0-9]) ICON="󰕿"
        ;;
        *) ICON="󰖁"
      esac

      ${sketchybar} --set "$NAME" icon="$ICON" label="$VOLUME%"
    fi
  '';
in
{
  fonts.packages = [
    (builtins.fetchurl {
      url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf";
      sha256 = "1ppis4k4g35gc7zbfhlq9rk4jq92k3c620kw5r666rya38lf77p4";
    })
  ];

  # Called when the workspace change
  services.aerospace.settings.exec-on-workspace-change = [
    "${pkgs.bash}/bin/bash"
    "-c"
    "${onWorkspaceChangedPlugin} $AEROSPACE_FOCUSED_WORKSPACE $AEROSPACE_PREV_WORKSPACE"
  ];

  # Our main update loop that runs every second to update the bar
  launchd.user.agents.reivilo_sketchybar_update = {
    script = "${pkgs.bash}/bin/bash -c ${infiniteUpdateLoop}";
    serviceConfig = {
      Label = "com.reivilo.sketchybar.update";
      StartInterval = 1;
      KeepAlive = true;
      RunAtLoad = true;
    };
  };

  services.sketchybar.enable = true;

  # Inspired from: https://github.com/scoiatael/dotfiles/blob/17184e575b4343cdb2b97f747a180bd0cd418833/modules/darwin/sketchybar.nix
  # https://github.com/FelixKratz/dotfiles/tree/e6288b3f4220ca1ac64a68e60fced2d4c3e3e20b/.config/sketchybar
  # https://github.com/neutonfoo/dotfiles/blob/main/.config/sketchybar/sketchybarrc-desktop
  # https://github.com/Tnixc/nix-config/blob/main/home/programs/sketchybar/sketchybar.nix
  # https://www.youtube.com/watch?v=8W06wMNZmo8
  services.sketchybar.config = ''
    ##### Bar Appearance #####
    ${sketchybar} --bar position=top height=34 color=0x00000000 --topmost=on --sticky=off

    ##### Changing Defaults #####
    default=(
      padding_left=4
      padding_right=4
      icon.font="${nerdfontFontName}:Bold:17.0"
      label.font="${nerdfontFontName}:Bold:14.0"
      icon.color=0xffffffff
      label.color=0xffffffff
      icon.padding_left=8
      icon.padding_right=4
      label.padding_left=4
      label.padding_right=8
      background.color=0xC01E2030
      background.border_width=1
      background.border_color=0x9992B3F5
      background.corner_radius=14
      background.height=28
      blur_radius=30
    )

    ${sketchybar} --default "''${default[@]}"

    # Useful to display the current display
    # ${sketchybar} --add item display1 left --set display1 label="Display 1" display=1
    # ${sketchybar} --add item display2 left --set display2 label="Display 2" display=2

    ##### Adding Apple Logo #####

    ${sketchybar} --add item apple_logo left \
      --set apple_logo icon="" label.drawing=off icon.padding_left=9 icon.padding_right=8 icon.y_offset=1 background.corner_radius=8 background.border_width=1 background.border_color=${normalSpaceLabelColor} padding_left=-8

    ##### Adding Workspaces Indicators #####

    workspaces=$(${aerospace} list-workspaces --all)
    for sid in $(echo $workspaces); do

      # Hack to get alignment right
      if [ "$sid" = "1" ]; then
        padding_left=4
      else
        padding_left=2
      fi
      if [ "$sid" = "W" ]; then
        padding_right=4
      else
        padding_right=2
      fi

      ${sketchybar} --add item space.$sid left \
        --set space.$sid \
          icon.font="${nerdfontFontName}:Bold:14.0" \
          icon.color=${normalSpaceIconColor} \
          label.color=${normalSpaceLabelColor} \
          label.font="${sketchyAppBarFontName}:Normal:12.0" \
          padding_left=$padding_left \
          padding_right=$padding_right \
          background.drawing=on \
          background.color=0x00000000 \
          background.border_width=${normalSpaceBorderWidth} \
          background.border_color=${normalSpaceBorderColor} \
          background.height=20 \
          background.corner_radius=10 \
          icon="$sid" \
          click_script="${aerospace} workspace $sid"
    done

    ${sketchybar} --add bracket spaces '/space\..*/'

    ${sketchybar} --add item front_app.app e \
      --set front_app.app \
        icon.font="${sketchyAppBarFontName}:Normal:16.0" \
        icon.color=${highlightSpaceIconColor} \
        label.color=${normalSpaceIconColor} \
        padding_right=0 \
        label.max_chars=16 \
        scroll_texts=on \
        background.drawing=off \
        script="${frontAppPlugin}" \
      --subscribe front_app.app front_app_switched

    ${sketchybar} --add item front_app.title e \
      --set front_app.title \
        label.font="${nerdfontFontName}:Bold:12.0" \
        label.color=${normalSpaceLabelColor} \
        label.max_chars=26 \
        padding_left=0 \
        scroll_texts=on \
        icon.drawing=off \
        background.drawing=off \
        label = "Title" \
        script="${frontAppTitlePlugin}" \
      --subscribe front_app.title front_app_switched

    ${sketchybar} --add bracket front_app '/front_app.*/'

    ${sketchybar} --add item clock right \
           --set clock update_freq=10 icon=  script="${clockPlugin}" padding_right=-8 label.color=${normalSpaceLabelColor} label.font="${nerdfontFontName}:Bold:12.0" \
           --add item volume right \
           --set volume script="${volumePlugin}" label.color=${normalSpaceLabelColor} label.font="${nerdfontFontName}:Bold:12.0" \
           --subscribe volume volume_change \
           --add item battery right \
           --set battery label.font="${nerdfontFontName}:Bold:12.0" update_freq=120 script="${batteryPlugin}" \
           icon.font="${sfProFontName}:Regular:17.0" icon.y_offset=${sfProYOffset} label.color=${normalSpaceLabelColor} \
           --subscribe battery system_woke power_source_change

    # Hack to force focus on the first workspace
    ${onWorkspaceChangedPlugin} "1" ""

    ##### Force all scripts to run the first time (never do this in a script) #####
    ${sketchybar} --update
  '';
}
