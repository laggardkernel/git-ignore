# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2019-02-14
### Added
- Completion for command options. (Only template keywords are supported before)
- Customize templates location with environment variable `GI_TEMPLATE` with fallback
  1. `.git-ignore` directory under this plugin's root folder
  2. `$XDG_DATA_HOME/git-ignore`
  3. `$HOME/.local/share/git-ignore`

### Changed
- Separate `compdef` into file `function/_git-ignore` to speed thing up.
- Improve globbing for template fetching.
- Move default template location to compliant with XDG base directory

### Fixed
- Correct folder name `function` as `functions`
- Quit `fzf` menu directly if no item is selected, skip the later output prompt.

## [1.1.0] - 2019-01-23
### Added
- New CLI with many useful options.
- `git` sub-command `git ignore`.

### Changed
- Separate the core function as script `git-ignore`.
  - `-l`, list all template names.
  - `-s`, search with keyword for available templates.
  - `-u`, init/update templates repo.
  - `-c`, clean local templates repo.
  - `-h`, help menu.
  - `-v`, version display.
- Command name `gitignore` is changed as `git-ignore`.

### Removed
- Unnecessary external command `basename`.
- Pre-defined settings for `bat`.

## [1.0.0] - 2019-01-23
### Added
- Simple completion for templates implemented using `compadd`.
- Preview in README.
- Support for general plugin mangers with `*.plugin.zsh` filename pattern.

### Changed
- Get back the output menu after selection made in `fzf`. Cancel the removal made by forgit.

### Fixed
- Scroll the preview section in `fzf` with mouse.

### Removed
- Unnecessary `fzf` option `--bind='ctrl-s:toggle-sort'`.
  - The input for it is already sorted.
- Optimize the script by using glob and variable expansion, removing:
    - Unnecessary external command `find`.
    - Unnecessary external command `sed`.
    - Unnecessary external command `awk`.
    - Unnecessary pipes `|`.

[Unreleased]: https://github.com/laggardkernel/git-ignore/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/laggardkernel/git-ignore/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/laggardkernel/git-ignore/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/laggardkernel/git-ignore/compare/11f3ff62...v1.0.0
