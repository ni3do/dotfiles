# Nushell Environment Config File

$env.EDITOR = "nvim"

# *nix locale
$env.LC_ALL = "en_US.UTF-8"

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# macOS ARM64 / Apple Silicon
if (sys host | get name) == "Darwin" {
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/simon/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin')
}

# ...but ~/bin should take priority over linuxbrew
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/bin" )

if (sys host | get name) == "Darwin" {
    # useful on macOS (TODO: I don't remember why, is this necessary?)
    $env.PATH = ($env.PATH | split row (char esep) | append "/usr/local/bin" )
}

zoxide init nushell | save -f ~/.zoxide.nu
