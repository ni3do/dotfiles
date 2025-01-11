{
  pkgs,
  ...
}: {
  enable = true;
  settings = {
    add_newline = false;
    scan_timeout = 10;
  };
}
