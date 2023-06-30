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
 
- pkg-config
- meson
- ninja-build
- python3
- gettext
- gettext-devel
- python3-gobject
- gtk4
- gtk4-devel
- libadwaita
- Gio (Usually installed by gtk or gtk development  headers)
- desktop-file-utils
- appstream-util
- glib2

For building, follow the commands in terminal:

```bash
# Get the source code
git clone https://github.com/aerocyber/sitemarker

# Checkout the version to install.
git checkout 1.1.0

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

Not officially supported.

## Development Version

### From Flathub

Development/beta versions are **not** available to install from Flathub.

### Building from source

The development version can be installed after building it from source. 

#### Installation without flatpak

The instructions assume the following packages are installed for your system:
 
- pkg-config
- meson
- ninja-build
- python3
- gettext
- gettext-devel
- python3-gobject
- gtk4
- gtk4-devel
- libadwaita
- Gio (Usually installed by gtk or gtk development  headers)
- desktop-file-utils
- appstream-util
- glib2

For building, follow the commands in terminal:

```bash
# Get the source code
git clone https://github.com/aerocyber/sitemarker

# Checkout the dev branch to install.
git checkout dev

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

Install [GNOME Builder](https://flathub.org/apps/org.gnome.Builder).

Open the project in GNOME Builder and export it.
Then, open terminal and execute:

```bash
flatpak install --user Path/to/io.github.aerocyber.sitemarker.flatpak
```

### Windows and Mac

Not officially supported.

