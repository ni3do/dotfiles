{
  pkgs,
  ...
}: {
  enable = true;
  userName = "niedo";
  userEmail = "57731234+ni3do@users.noreply.github.com";
  ignores = [ ".DS_Store" ];
  extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
  };
}
