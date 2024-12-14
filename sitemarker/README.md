# sitemarker

Bookmark management made elegant

## Colors File: The theme creator

The colors file is used for theme customization in Sitemarker. While custom color schemes are not supported yet, this section explains how it is done.
Go to [Material Theme Builder](https://material-foundation.github.io/material-theme-builder/) and create a color scheme.
Export it as JSON file format. Edit it to replace description by a short description of the new theme.
Add a unique id to the theme and give it a theme name. Finally, change the file format to colorsfile.
A theme for Sitemarker is now complete!

Sitemarker do not support custom schemes yet. But, you can place it inside `assets/themes` directory followed by editing the `lib/core/data_types/sm_theme.dart` file
to include your theme in the themeStore list of type ``
