# sitemarker

Bookmark management made elegant

## Colors File: The theme creator

The colors file is used for theme customization in Sitemarker. While custom color schemes are not supported yet, this section explains how it is done.
Go to [Material Theme Builder](https://material-foundation.github.io/material-theme-builder/) and create a color scheme.
Export it as JSON file format. Edit it to replace description by a short description of the new theme.
Add a unique id to the theme and give it a theme name. Finally, change the file format to colorsfile.
A theme for Sitemarker is now complete!

Sitemarker do not support custom schemes yet. But you can place it in one of these three places:
  - $XDG_DATA_HOME/themes/ if $XDG_DATA_HOME is defined for your system
  - $SNAP_USERS_COMMON/themes if installation is done using snap
  - ~/.local/share/io.github.aerocyber.sitemarker/themes if neither of the above but you're on Linux OR you're on Mac even without official support

 Theme installation when supported will include an install theme button from where themes are to be installed.
 This is a curent workaround for now. Android users can ONLY install the theme using that button as the themes
 get installed to internal app dir which can be accessed by the app. (For technical users, we use the `getApplicationSupportDirectory` method to determine the support dir)

