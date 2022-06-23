# PlasticSCM AppImage Build Script

June, 2022

This repository contains scripts to package Plastic SCM's Linux
client as an AppImage.

This appears to work, but has not yet undergone extensive testing.

Also, it's a complete band-aid until Plastic SCM is updated to
run on modern distros that only have GTK3.

This currently builds against Ubuntu 18.04 since Plastic SCM
requires GTK2 libraries.

This only exposes the GUIs, not the command line `cm` tool or
server software.

Pull requests welcome to fix bugs or add capability.

Plastic SCM folks: Please, please fix the Linux version.

## Prerequisites

You only need access to a Linux machine with Docker on it.

## Usage

```
$ git clone https://github.com/ahrbe1/plasticscm-appimage.git
$ cd plasticscm-appimage
$ ./build-appimage.sh
$ ./out/Plastic_SCM_Client.glibc2.25-x86_64.AppImage
```

