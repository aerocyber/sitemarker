# File locations

## Version 1.x

Used an .omio file in `$XDG_DATA_DIR` or `~/.local/share/sitemarker`

## Version 2.x

Uses `getApplicationDocumentsDirectory()` of `path_provider` library to store an `sqlite3` database (done using the `drift` package).