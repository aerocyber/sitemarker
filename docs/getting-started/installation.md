# Installation Guide

Sitemarker is available for Linux, Windows and Android. If the user chooses to, Sitemarker can be built to work on Mac, iOS and web, however, no official support will be given from the developer on these unofficial channels.

- To download Sitemarker, go to the latest release page here: [Github Releases](https://github.com/aerocyber/sitemarker/releases/latest).
- Then, download the release suited for your platform.

## Windows

There are two ways to use Sitemarker on Windows:
- After Installing
- Without Installing

### Installing

To install Sitemarker on Windows, download the installer version of the release. This file is usually of the format _`sitemarker-<VERSION>-windows-installer.exe`_. The installation process is straight forward - run the installer and follow the steps. Installing **will** create shortcuts in places you chose during the process.

### Without Installing

To use Sitemarker on Windows without installing, download the archive version of the release. This file is usually of the format _`sitemarker-<VERSION>-windows.zip`_. To use this varient, unzip it to your preferred location and launch it by double-clicking the executable.


## Android

If you know your Android architecture, download the apk corresponding to your device architecture as they are smaller in size. If you do not, download the file of the format _`sitemarker-<VERSION>-android.apk`_ as it works for all architectures supported by Flutter apps. Currently, `armeabi-v7a` and `arm64-v8a` abis are available for download. To install it, sideload the APK. Alternatively, you can also use the [APK from Izzydroid](https://apt.izzysoft.de/fdroid/index/apk/io.github.aerocyber.sitemarker) for installation. If you're using the Izzydroid repo, prefer using an F-Droid client, add the repo and install from there!

## Linux

Sitemarker offers the following usage methods for Linux:
- tarball
- snapstore
- flatpak (through flathub)

### tarballs As Installation Source

Get the tarball from releases. It is compressed as a `.tar.xz` file. Uncompress it to your preferred location. Launch `sitemarker` binary.

### Snapstore

For platforms with snap installed - Ubuntu and most Ubuntu derivatives comes with snap by default - can install sitemarker from snap store. You can either browse to the sitemarker page on your snap store client or install through commandline:

``` bash
sudo snap install sitemarker
```

### Flatpak (Through Flathub)

Sitemarker is available as flatpak from flathub. You can use a flthub client or terminal to install it provided `flatpak` is installed.

``` bash
flatpak install io.github.aerocyber.sitemarker
```