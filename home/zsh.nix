{
  pkgs,
  ...
}: {
  enable = true;
  autosuggestion = {
      enable = true;
  };
  syntaxHighlighting.enable = true;
  initExtra = "eval \"$(micromamba shell hook --shell zsh)\"";
}
