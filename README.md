# Sitemarker

An open source bookmark manager written in Flutter

## Requirements

Install [Flutter](https://flutter.dev) for building.

Fetch the dependencies using:

```bash
flutter pub get
```

## Building

Building is as simple as running the following command in the root of the project dir:

```bash
flutter build <dist>
```

where `dist` is one of the option in `flutter build` subcommands.

:warning: web is not supported and issues submitted will be closed without notice.

## Releases

Checkout the [releases](https://github.com/aerocyber/sitemarker/releases) page and obtain the latest stable release!

### Distribution packages

The following packages are (or will be) available via package managers:

* Flatpak via Flathub: [Go to flathub page](https://flathub.org/app/io.aerocyber.sitemarker)
* Snap via Snapstore: [Go to Snapstore page](https://snapstore.io/osmata)

## Documentation

See [docs](docs/index.md) [here](https://aerocyber.github.io/sitemarker).

## Reporting issues

Giving accurate bug report is essential for the continuous development of sitemarker. You can report all issues at [Github Issues](https://github.com/aerocyber/sitemarker/issues).

## Contribution

For all contributions to this project, please [open a pull request](https://github.com/aerocyber/sitemarker/pulls). See [Contribution Guidelines](#contribution-guideline) before opening a PR.

You can [sponsor](https://github.com/sponsors/aerocyber) the project as well!

### COntribution Guideline

Contribution guidelines exist to help contrbutors to make contribution to the right place.

There exist different ways to contribute.

* All security fixes are considered with **_topmost_** priority. Hence, they're to be **_committed DIRECTLY to `main` branch and PR opened AGAINST `main`_**.

These PRs MUST be labelled `PRIORITY: 0` and `Security` and will be reviewed under 2 days.

* All code commits MUST go to `dev` branch. They must have a tag which suits the need, say `Feaure Implementation`, `Enhancement`, `Bug fix`.

* All translations MUST go to `dev` branch. They must have a tag of `Translation`. All translations are in the `translations` directory in the root dir.

The translations can be done by copying `base.json` to your `locale.json` file and editing them. Please make sure to **_COPY_** and NOT MOVE the base.json file.

## License

```text
MIT License

Copyright (c) 2023 Aero

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
