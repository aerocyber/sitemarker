# Installation Guide

This guide covers how to install sitemarker.

## Stable Version

### From Flathub

The stable version can easily be installed via flathub. First, if you haven't already, go to [flathub](https://flathub.org) and click on Set Up and set up flatpak for your system. Then, open terminal and enter the following commands:

```bash
flatpak install flathub io.github.aerocyber.sitemarker
```

### Building from source

The stable version can also be installed after building it from source. 

#### Installation without flatpak

The instructions assume the following packages are installed for your system:
 
- Clang
- CMake
- git
- GTK development headers
- Ninja build
- pkg-config
- liblzma-dev
- libstdc++-12-dev

For building, follow the commands in terminal:

```bash
# Get the source code
git clone https://github.com/aerocyber/sitemarker

# Checkout the version to install.
git checkout 1.2.3

# Build it
meson build

# Install it
cd build
sudo ninja install

# The installation fails due to the executable (sitemakrer) not having enough permissions. Fix it.
sudo chmod +x $(which sitemarker)
```

#### Installation with flatpak

Building for installing with flatpak is fairly simple.

Get the source and open move to the stable version

```bash
# Get the source code
git clone https://github.com/aerocyber/sitemarker

# Checkout the version to install.
git checkout 1.1.0
```

Install [GNOME Builder](https://flathub.org/apps/org.gnome.Builder).

Open the project in GNOME Builder and export it.
Then, open terminal and execute:

```bash
flatpak install --user Path/to/io.github.aerocyber.sitemarker.flatpak
```

### Windows and Mac

Not officially supported yet.

## Development Version

### From Flathub

Development/beta versions are **not** available to install from Flathub.

### Building from source

The development version can be installed after building it from source. 

#### Installation without flatpak

The instructions assume the following packages are installed for your system:
 
- Clang
- CMake
- git
- GTK development headers
- Ninja build
- pkg-config
- liblzma-dev
- libstdc++-12-dev

For building, follow the commands in terminal:

```bash
# Get the source code
git clone https://github.com/aerocyber/sitemarker

# Checkout the dev branch to install.
git checkout dev

# Set platform. Platform should be  either of apk, linux or windows
PLATFORM=linux

# Build it
flutter build --release $PLATFORM

# Open the directory location
xdg-open ./build/

```

#### Installation with flatpak

Run:

```bash
./build-flatpak.sh
```

### Windows and Mac

Building on Windows require the installation of Visual Studio. Follow the official [flutter documentation](https://docs.flutter.dev/get-started/install/windows/desktop)

```bash
# Get the source code
git clone https://github.com/aerocyber/sitemarker

# Checkout the dev branch to install.
git checkout dev

# Set platform. Platform should be  either of apk, linux or windows
PLATFORM=windows

# Build it
flutter build --release $PLATFORM

# Open the directory location
xdg-open ./build/

```

Mac is NOT officially supported. But you can try to run it.
