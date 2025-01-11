{
  pkgs,
  ...
}: {
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
}
