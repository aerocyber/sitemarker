# sitemarker

An open source bookmark manager written in Gtk4

## Building 

### Linux

### using `meson`

#### Requirements

The build was tested on Fedora 38 with the following pre-requisite packages:

- glib2-devel
- gettext
- meson
- ninja-build

Install them on Fedora (tested on 38) with:

```bash
sudo dnf install meson ninja-build gettext glib2-devel -y
```

#### Command

```bash
meson build
cd build
sudo ninja install
```

