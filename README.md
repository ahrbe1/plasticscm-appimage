# PlasticSCM AppImage Packaging Utility

June, 2022

This repository contains scripts to package Plastic SCM's Linux
client as a portable AppImage.

## How it works

This utility pulls the Ubuntu 18.04 docker image and then
downloads, extracts, and repackages the Plastic SCM clients
and all dependencies using AppImage's `pkg2appimage` tool.
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
$ ./out/Plastic_SCM_Client*.AppImage
```

The build now exposes the command-line tools as well. You
can create the following symlinks to the AppImage and it
will autodetect which tool you want to start:

- cm
- gluon
- gtkmergetool
- gtkplastic
- legacygluon
- legacyplasticgui
- plasticgui
- linplasticx

As an example:

```
$ sudo cp Plastic_SCM_Client*.AppImage /opt/
$ mkdir -p ~/.local/bin
$ for cmd in cm gluon gtkmergetool gtkplastic legacygluon legacyplasticgui plasticgui linplasticx
  do
    ln -s /opt/Plastic_SCM_Client*.AppImage ~/.local/bin/$cmd
  done
```

Be sure to add `~/.local/bin` to your $PATH (e.g. in `~/.bashrc`)

Then you can use those commands to start the relevant tools from the AppImage.

## Limitations

After the build, you may want to run `docker image prune` to reclaim
some disk space. The script doesn't do this for you, because you may
have other docker images that you don't want pruned.

You will need to rebuild the AppImage when new versions of the
PlasticSCM utilities are available.

## Contributing

Pull requests welcome to fix bugs or add capability. File a ticket
if you bump into issues and I'll see what I can do.

## License

The Unlicense, <https://unlicense.org>

