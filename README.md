# PlasticSCM AppImage Build Script

June, 2022

This repository contains scripts to package Plastic SCM's Linux
client as a portable AppImage.

## How it works

This utility pulls the Ubuntu 18.04 docker image and then
downloads, extracts, and repackages the Plastic SCM clients
using AppImage's `pkg2appimage` tool.
See https://github.com/AppImage/pkg2appimage

## Prerequisites

You only need access to a Linux machine with Docker on it.

If you've never used docker, basically you just need to
install it via your system's package manager, and then add
yourself to the `docker` group. Log out, log back in, and
you should be ready to go.

## Usage

```
$ git clone https://github.com/ahrbe1/plasticscm-appimage.git
$ cd plasticscm-appimage
$ ./build-appimage.sh
```

The build will take a few minutes. Once it completes, the
resulting AppImage can be found in the `out` folder. You
can run it with:

```
$ ./out/Plastic_SCM_Client.glibc2.25-x86_64.AppImage
```

## Limitations

The resulting AppImage exposes the Plastic SCM GUIs, but not the
command line `cm` tool or server software. Though support for
those may be added in a future update.

This has been lightly tested on Ubuntu 20.04 and 22.04, but has
not yet been tested on other systems.

Also, this is really just a band-aid until Plastic SCM is updated
to run on modern distros that only have GTK3. Ubuntu 18.04 will
stop receiving security updates soon, and Gtk2 has already been
removed from most modern distros. That may not bode well for the
future of Plastic SCM on Linux.

Plastic SCM folks: Please, please fix the Linux version.

## Contributing

Pull requests welcome to fix bugs or add capability. File a ticket
if you bump into issues and I'll see what I can do.

## License

The Unlicense, <https://unlicense.org>

