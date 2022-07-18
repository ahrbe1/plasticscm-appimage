# PlasticSCM AppImage Packaging Utility

June, 2022

This repository contains scripts to package Plastic SCM's Linux
client as a portable AppImage.

This script can also optionally be used to install/uninstall the
resulting AppImage.

The intention here is to provide a "one-click" install
alternative to wrangling Plastic SCM's dependencies on
modern distros.

## How it works

This utility pulls the Ubuntu 18.04 docker image and then
downloads, extracts, and repackages the Plastic SCM clients
and all dependencies using AppImage's `pkg2appimage` tool.
See https://github.com/AppImage/pkg2appimage

## Prerequisites

You only need access to a Linux machine with Docker on it
to build the AppImage. 

Once built, the AppImage is a standalone program that has
no dependency on docker.

If you've never used docker, basically you just need to
install it via your system's package manager, and then add
yourself to the `docker` group. Log out, log back in, and
you should be ready to go.

## Usage

**TLDR; Build and Install**

```
$ git clone https://github.com/ahrbe1/plasticscm-appimage.git
$ cd plasticscm-appimage
$ ./build-appimage.sh --install
```

Will build the AppImage and install it for you. The build will
take a few minutes to download and package everything. Once
built, the script will install the following files:

* AppImage -> `~/.local/opt/`
* command-line tools -> `~/.local/bin`
* .desktop files -> `~/.local/share/applications`
* icons -> `~/.local/share/plasticscm/icons`

**Uninstall**

```
$ ./build-appimage.sh --uninstall
```

**Build Only**

```
$ ./build-appimage.sh
```

The resulting AppImage can be found in the `out` folder.

```
$ ls out/*.AppImage
out/Plastic_SCM_Client-11.0.16.7195-glibc2.25-x86_64.AppImage
```

**Program Usage**

```
$ ./build-appimage.sh -h
usage: build-appimage.sh [-i|--install] [-u|--uninstall]
         [-p|--prune] [-h|--help] [-v|--version]

options:
  -i|--install    install the application
  -u|--uninstall  uninstall the application
  -p|--prune      run 'docker image prune' after build
  -h|--help       show this help text
  -v|--version    show version information

```

No modifications are made to your system unless `--install`,
`--uninstall`, or `--prune` are used.

## Command Line Tools

The build now exposes the command-line tools as well as the GUIs.
If you chose not to do an automatic install, you can manually
create the following symlinks to the AppImage and it will autodetect
which tool you want to start:

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

Be sure to add `~/.local/bin` to your `$PATH` (e.g. in `~/.bashrc`)

Then you can use those commands to start the relevant tools from the AppImage.

## Limitations

You will need to rebuild the AppImage when new versions of the
Plastic SCM utilities are available.

## Contributing

Pull requests welcome to fix bugs or add capability. File a ticket
if you bump into issues and I'll see what I can do.

## License

The Unlicense, <https://unlicense.org>

