# bluecandle

Hands off immutable OS based on [Bluefin OS](https://projectbluefin.io/) for [niri](https://github.com/niri-wm/niri) users, or people that are curious about tiling/scrolling window managers.

**⚠️ ATTENTION: This project is in development, I'm not even using it myself on bare metal yet. It's not close to completion, expect frequent changes**

This project piggybacks off the wonderful work of the Bluefin OS, niri and [Noctalia](https://noctalia.dev/) developers. The objective is shipping a easy to use scrolling window manager enviroment, with a robust OS base that you can install and forget about. Explicitly:

1. Feature parity with Bluefin OS (except GNOME especific programs)
2. Beautiful and easy to use Niri configuration, bootstrap by Noctalia
3. Acommodating to new users, liberating for power users

## Roadmap
Here's what I want to accomplish, in order of importance:

- OS
  - [ ] Ship pre-configured Noctalia
  - [ ] Default programs
    - [x] Browser: Firefox
	- [x] Terminal: [Ghostty](https://ghostty.org/)
	- [ ] File manager: ?
	- [ ] Image viewer: ?
	- [ ] Video player: ?
	- [ ] Music player: ?
    - [ ] Screenshot tool: [Gradia](https://gradia.alexandervanhee.be/) (Flatpak?)
	- [ ] System monitor:
	  - [ ] htop
	    - [ ] Fix fuzzel entry to open with ghostty
	  - [ ] [Resources](https://apps.gnome.org/app/net.nokyan.Resources/)
	- [ ] Software store: [Bazaar](https://usebazaar.org/)
  - [ ] Ship Noctalia templates through `skel` directory
    - [ ] Niri
    - [ ] Firefox
	- [ ] Ghostty
    - [ ] Other graphical programs if possible
  - [ ] Make sure automatic updating is working for the image, flatpaks, firmware and devbox containers
  - [ ] Make sure user `systemd` daemons are working
  - [ ] Make sure Brew is working
  - [ ] Make sure distrobox is working, and has GUI package
  - [ ] Fancy terminal tooling (make sure the script for installing extra development tools is working, ignoring VSCode)

- [Building](project-readme.md)
  - [ ] Image Signing
  - [ ] SBOM Attestation
  - [ ] Image Rechunking
  - [ ] User Provisioning (?)
  - [ ] Anaconda Installer
  - [ ] NVIDIA Image & `ujust` script for layering necessary drivers and deps

- Project
  - [ ] Logo (blue candle with niri flame)
  - [ ] Backgrounds
  - [ ] Fancy landing page
  - [ ] Reorganize the READMEs scattered around
   - [ ] Propper contributing documentation
  - [ ] Get Jorge Castro to see my project :3

- Optional sidequests
  - [ ] Ghostty integration with distrobox, if nobody already got to it
  - [ ] Ship Emacs, somehow (brew cask? Package layering?)
  - [ ] Noctalia Dark & Light theme backgrounds, through either plugin || upstream || fork
  - [ ] Noctalia per theme background couple, thorugh either plugin || upstream || fork
  - [ ] Attempt to use the Noctalia menu to change other system settings
  - [ ] A propper original aesthetic, maybe requiring a move away from Noctalia

Only when I finish this roadmap, I would consider the OS anywhere usable by other people
