#!/bin/zsh

# Quick help/full install process:
#   - Install Rust from rustup.rs 
#   - `git clone https://github.com/jtroo/kanata.git` in home (`~/`), then `cd kanata` and `cargo build`
#   - Install https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice version: ^5.0.0
#   - Allow Input Monitoring for latter somewhere in macOS' settings
#   - `chmod +x kanata.sh` this file after creation!

# Activate Karabiner-VirtualHIDDevice-Manager (actually needs to be done only once but yeah)
sudo /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate

# Run Karabiner-VirtualHIDDevice-Daemon
sudo '/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon'&


# Execute kanata with the provided parameter
sudo ~/kanata/target/debug/kanata -nc ~/.config/kanata/kanata.kdb
