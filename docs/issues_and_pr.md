# Issues and Pull requests

## Issues

### reporting

Support will be available to the latest stable version AND the entire `dev` and `main` branches. Additionally, building from the tag corresponding to the latest stable release is also supported.

### How to report

- Go to [Github issues](https://github.com/aerocyber/sitemarker/issues)
- Create a new issue. Use template if apt for the type of issue you are reporting. Else, remove everything and report it.

## Pull Requests

All pull requests are to be done against the `dev` branch. Doing so against the `main` branch will result in the pr getting ignored or closed.

This is maintained so as not to make the `main` branch polluted. The `main` branch represents the next stable release. So, unless a fix is to be done against the `next release`, no PR must be opened against the `main` branch.

### PR against the `dev` branch

Feel free to open a PR against the dev branch! We very much appreciate it!

### PR against the `main` branch

The PRs against the `main` branch are considered ONLY if:

- The issue affects the *next* stable release.
- The PR has `[TO MAIN]` in the title. It can be placed either at the beginning or at the end of the subject line.

