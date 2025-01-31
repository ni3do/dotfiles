{ pkgs
, ...
}:
let
  sketchybar = "${pkgs.sketchybar}/bin/sketchybar";
  yabai = "${pkgs.yabai}/bin/yabai";
  jq = "${pkgs.jq}/bin/jq";
  sketchyAppBarFontName = "sketchybar-app-font";
  # export a function __icon_map that map the name of the app to the icon
  # Call it `__icon_map "Figma"`
  # Then you will have the result in the variable $icon_result (for example ":figma:")
  sketchyAppBarFontSh = builtins.fetchurl {
    url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/icon_map.sh";
    sha256 = "0dryim93c6ln2h6whlb0cs5y50yyz8klp4aq6cfl2ys4aj21ad8n";
  };
  nerdfontFontName = "JetBrainsMono Nerd Font";
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
    focused_window_title=$($yabai -m query --windows --window last | ${jq} '.title')
    ${sketchybar} --set "$NAME" label="$focused_window_title"
  '';

  queryYabaiWorkspace = "${yabai} -m query --windows"; 
  queryYabaiWindows = "${yabai} -m query --spaces";

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
    workspace_query_json=$(${queryYabaiWorkspace})
    windows_query_json=$(${queryYabaiWindows})

    # Update per workspace
    for space_id in $(echo $workspace_query_json | ${jq} -r ".[] | .id"); do
      # Get all the windows in the workspace
      windows_in_workspace=$(echo "$windows_query_json" | ${jq} -r ".[] | select(.space == \"$workspace\") | .\"app\"")

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
    focused_window_title=$(${yabai} -m query --windows --window last | ${jq} '.title');
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

  spacePlugin = pkgs.writeShellScript "space.sh" ''
    if [ "$SELECTED" = "true" ]; then
      sketchybar -m --set $NAME background.color=0xff9399b2
    else
      sketchybar -m --set $NAME background.color=0xff1e1e2e

    fi
  '';

  stockPlugin = pkgs.writeShellScript "stock.sh" ''
    INFO=(
        $(
            perl -e '
                $json = `curl -k -L -s --compressed https://robinhood.com/us/en/stocks/VTI/`;
                if ($json =~ /"quote":\K(\{.*?\})/) {
                    print "$1";
                }
            ' |
            jq -r '.adjusted_previous_close,.last_trade_price'
        )
    )

    change=$((
        ( ($INFO[2] - $INFO[1]) / $INFO[1] ) *100
    ))


    if [[ $change -ge 0 ]]; then 
        ${sketchybar} --set $NAME icon.color=0xff{{ .dracula.hex.green }}
    elif [[ $change -lt 0 ]]; then
        ${sketchybar} --set $NAME icon.color=0xff{{ .dracula.hex.red }}
    fi

    ${sketchybar} --set $NAME label=$(printf "%.*f\n" 2 "$change")
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
  # services.aerospace.settings.exec-on-workspace-change = [
  #   "${pkgs.bash}/bin/bash"
  #   "-c"
  #   "${onWorkspaceChangedPlugin} $AEROSPACE_FOCUSED_WORKSPACE $AEROSPACE_PREV_WORKSPACE"
  # ];

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
    ############### Bar Appearance ##############
    ${sketchybar} --bar position=top height=34 color=0x00000000 topmost=on sticky=off

    ############## GLOBAL DEFAULTS ############## 
    default=(
      padding_left=4
      padding_right=4
      icon.font="${nerdfontFontName}:Bold:16.0"
      label.font="${nerdfontFontName}:Bold:14.0"
      label.y_offset=1
      icon.color=0xffffffff
      label.color=0xffffffff
      icon.padding_left=8
      icon.padding_right=4
      label.padding_left=4
      label.padding_right=8
      background.color=0xff1e1e2e
      background.border_width=1
      background.border_color=0xff6c7086
      background.corner_radius=14
      background.height=28
    )

    ${sketchybar} --default "''${default[@]}"

    ############## PRIMARY DISPLAY SPACES ############## 
    # SPACE 1: CODE ICON
    sketchybar -m --add space code left \
      --set code icon= \
      --set code associated_display=1 \
      --set code associated_space=1 \
      --set code label.padding_right=0 \
      --set code label.padding_left=0 \
      --set code click_script="yabai -m space --focus 1" \
      --set code script="${spacePlugin}" \

    # ${sketchybar} --add item stocks right \
    #     --set stocks update_freq=10 icon=VTI script="${stockPlugin} VTI"
    #       ${sketchybar} --add bracket spaces '/space\..*/'

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
           --set clock update_freq=10 icon= script="${clockPlugin}" padding_right=-8 label.color=${normalSpaceLabelColor} \
           --add item volume right \
           --set volume script="${volumePlugin}" label.color=${normalSpaceLabelColor} \
           --subscribe volume volume_change \
           --add item battery right \
           --set battery update_freq=120 script="${batteryPlugin}" \
           icon.font="${sfProFontName}:Regular:16.0" icon.y_offset=${sfProYOffset} label.color=${normalSpaceLabelColor} \
           --subscribe battery system_woke power_source_change

    # Hack to force focus on the first workspace
    # ${onWorkspaceChangedPlugin} "1" ""

    ##### Force all scripts to run the first time (never do this in a script) #####
    ${sketchybar} --update
  '';
}
