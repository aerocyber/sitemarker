# Sitemarker

An open source bookmark manager written in Flutter

## Support

### GitHub Sponsors and Buy Me a Coffee

[![GitHub Sponsors](https://img.shields.io/github/sponsors/aerocyber?style=for-the-badge&logo=Github&label=GitHub%20Sponsors)](https://github.com/sponsors/aerocyber)
[![Buy Me a Coffee](https://img.shields.io/github/sponsors/aerocyber?style=for-the-badge&logo=Buy%20Me%20a%20Coffee&logoColor=white&label=Buy%20Me%20a%20Coffee&labelColor=yellow)](https://www.buymeacoffee.com/aerocyber)

### Experimental Crypto addresses
Monero: 449w7ivAZ4CB9xG1hxCroqSXrhvPDziJ4NzZ6SHcnvry9EiRFHHaqcFFbhQ1634VCCMcZUQFNRmH3go49aAKeLDC8HdDwcY

Solana: 22ModgrvARKZCkwpcs8VWS9HXkq9M4iMKpLa5fTUHH1r

Ethereum: 0x7CB517dC3b34caf145b7B40759664AB128EcF5FE

Polygon: 0x7CB517dC3b34caf145b7B40759664AB128EcF5FE

### Code contributions

Code contributions are always welcomed! [Please see the Pull Request Guide in the documentation to how to pull a PR for Sitemarker](./docs/issues_and_pr.md#pull-requests)

## Requirements

Install [Flutter](https://flutter.dev) for building.

Fetch the dependencies using:

```bash
flutter pub get
```

## Building

Building is as simple as running the following command in the root of the project dir:

```bash
flutter pub run build_runner build
flutter build <dist>
```

where `dist` is one of the option in `flutter build` subcommands.

Or, alternatively, run:

```bash
./build.sh # For all builds.
```

:warning: web is not supported and issues submitted will be closed without notice.

## Releases

Checkout the [releases](https://github.com/aerocyber/sitemarker/releases) page and obtain the latest stable release!

### Distribution packages

The following packages are (or will be) available via package managers:

[![Get it on Flathub](https://flathub.org/api/badge?locale=en)](https://flathub.org/app/io.github.aerocyber.sitemarker) [![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/sitemarker)

## Documentation

See [docs](docs/index.md) [here](https://aerocyber.github.io/sitemarker).

## Reporting issues

Giving accurate bug report is essential for the continuous development of sitemarker. You can report all issues at [Github Issues](https://github.com/aerocyber/sitemarker/issues).

## Yet to be completed

The following features are not completed.

* Themes Settings: Dark theme, light theme and system preferred.
* Save settings: Save the settings using shared_preferences and make it load on start up
* Introduction screen for new users
* Import/Export of data to/from internal database
* Migration assistant for Sitemarker 1.x to 2
* Recognize URLs without protocols
* Sort based on Tags
* Copy URL to clipboard
* Localization

## Contribution

For all contributions to this project, please [open a pull request](https://github.com/aerocyber/sitemarker/pulls). See [Contribution Guidelines](#contribution-guideline) before opening a PR.

You can [sponsor](#Support) the project as well!

### Contribution Guideline

Contribution guidelines exist to help contrbutors to make contribution to the right place.

There exist different ways to contribute.

* All code commits MUST go to `dev` branch. They must have a tag which suits the need, say `Feaure Implementation`, `Enhancement`, `Bug fix`.

* All translations MUST go to `dev` branch. They must have a tag of `Translation`. All translations are in the `translations` directory in the root dir.

The translations can be done by copying `base.json` to your `<locale_code>.json` file and editing them. Please make sure to **_COPY_** and NOT MOVE the base.json file.

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
