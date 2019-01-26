# git-ignore

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

ZSH plugin. Generate `.gitignore` with templates from [gitignore.io](https://www.gitignore.io/) **offline**, taking the advantage of [`fzf`](https://github.com/junegunn/fzf) fuzzy finder, [`bat`](https://github.com/sharkdp/bat) syntax highlighting and ZSH completion.

![images/preview-01.jpg](../assets/images/preview-01.jpg?raw=true)

## Feature
- Use `git-ignore` command to generate `.gitignore` files
  - `git` sub-command `git ignore` is also supported now
- Templates selection helped by fuzzy finder with preview
- ZSH completion for command `git-ignore`
  - Only for `git-ignore`, not `git ignore`
- Use the same [`.gitignore` templates](https://github.com/dvcs/gitignore) used by [gitignore.io](https://www.gitignore.io/) from [dvcs/gitignore](https://github.com/dvcs/gitignore)
- Imitate templates generation behavior of [gitignore.io](https://www.gitignore.io/) exactly
- Pull/Update templates from [dvcs/gitignore](https://github.com/dvcs/gitignore) with `git-ignore --update`.
  - No need to update this plugin regularly to get updated templates.

## Installation

### [Zplugin](https://github.com/zdharma/zplugin)

The only ZSH plugin manager solves the time-consuming init for `nvm`, `nodenv`, `pyenv`, `rvm`, `rbenv`, `thefuck`, `fasd`, etc, with its amazing async [Turbo Mode](https://github.com/zdharma/zplugin#turbo-mode-zsh--53).

```zsh
# add it into ur .zshrc
zplugin ice pick'init.zsh' blockf atload'alias gi="git-ignore"'
zplugin light laggardkernel/git-ignore
```

Update the plugin with

```zsh
$ zplg update laggardkernel/git-ignore
```

### [Prezto](https://github.com/sorin-ionescu/prezto)

The only framework does **optimizations** in plugins with sophisticated coding skill:
- [Refreshing `.zcompdump` every 20h](https://github.com/sorin-ionescu/prezto/blob/4abbc5572149baa6a5e7e38393a4b2006f01024f/modules/completion/init.zsh#L31-L41)
- [Compiling `.zcompdump` as bytecode in the background](https://github.com/sorin-ionescu/prezto/blob/4abbc5572149baa6a5e7e38393a4b2006f01024f/runcoms/zlogin#L9-L15)
- [Caching init script for fasd](https://github.com/sorin-ionescu/prezto/blob/4abbc5572149baa6a5e7e38393a4b2006f01024f/modules/fasd/init.zsh#L22-L36)
- Saving `*env` startup time with [`init - --no-rehash` for `rbenv`, `pyenv`, `nodenv`](https://github.com/sorin-ionescu/prezto/blob/4abbc5572149baa6a5e7e38393a4b2006f01024f/modules/python/init.zsh#L22)
- [Removing the horribly time-consuming `brew command` from `command-not-found`](https://github.com/sorin-ionescu/prezto/blob/4abbc5572149baa6a5e7e38393a4b2006f01024f/modules/command-not-found/init.zsh)

```zsh
mkdir -p ${ZDOTDIR:-$HOME}/.zprezto/contrib &>/dev/null
git clone git@github.com:laggardkernel/git-ignore.git ${ZDOTDIR:-$HOME}/.zprezto/contrib/git-ignore

# or use HTTPS instead
git clone https://github.com/laggardkernel/git-ignore.git ${ZDOTDIR:-$HOME}/.zprezto/contrib/git-ignore
```

### Others

Sorry, I don't care much.

## Usage

```zsh
$ alias gi="git-ignore"

# With fzf installed
$ gi # then press <Enter>

# Separate params with spaces or commas
$ gi macos linux windows vim emacs >> ./.gitignore

# Overwrite existing .gitignore
$ gi macos,linux,windows vim emacs >| ./.gitignore
```

### New CLI （`v1.1.0+`)

```zsh
❯ alias gi="git-ignore"

❯ gi -h
git-ignore 1.1.0 by laggardkernel <laggardkernel@gmail.com>
https://github.com/laggardkernel/git-ignore

Generates .gitignore files offline using templates from gitignore.io

Usage:
  git-ignore [options]
  git-ignore keyword1 keyword2 keyword3

Example:
  git-ignore macos,linux,windows vim emacs >> ./.gitignore

Options:
  -l, --list                List available templates
  -s, --search keyword      Search template with keyword in filenames
  -u, --update              Init/Update local templates repo
  -c, --clean               Clean local gitignore templates repo
  -h, --help                Display this help screen
  -v, --version             Display version information and exit

❯ gi -l
1C,1C-Bitrix,A-Frame,Actionscript,Ada,Adobe,AdvancedInstaller,Agda,AL...
# omitted because it is too long
Total: 468

❯ gi -s py # then press <Tab> for completion
pycharm      pycharm+all  pycharm+iml  pydev        python

❯ gi -u
[Info] Updating gitignore repo...
Already up to date.

❯ gi -c
[Info] No available local gitignore repo
[Info] Use `gi -u` to init
```

## Optional Dependencies
- [`fzf`](https://github.com/junegunn/fzf): Command-line fuzzy finder
- [`bat`](https://github.com/sharkdp/bat): Syntax highlighting for `.gitignore` templates.

### Default Keybindings for `fzf`

| Keybind                                       | Action                  |
| :-------------------------------------------: | ----------------------- |
| <kbd>Enter</kbd>                              | Confirm                 |
| <kbd>Tab</kbd>                                | Toggle mark             |
| <kbd>?</kbd>                                  | Toggle preview window   |
| <kbd>Ctrl</kbd> - <kbd>R</kbd>                | Toggle selection        |
| <kbd>Alt</kbd> - <kbd>W</kbd>                 | Toggle preview wrap     |
| <kbd>Ctrl</kbd> - <kbd>K</kbd> / <kbd>P</kbd> | Selection up            |
| <kbd>Ctrl</kbd> - <kbd>J</kbd> / <kbd>N</kbd> | Selection down          |
| <kbd>Alt</kbd> - <kbd>K</kbd> / <kbd>P</kbd>  | Preview up              |
| <kbd>Alt</kbd> - <kbd>J</kbd> / <kbd>N</kbd>  | Preview down            |

## Todo

- [ ] Support all types of templates files from [dvcs/gitignore](https://github.com/dvcs/gitignore#files)
  - [x] Templates
  - [x] Patch
  - [x] Stack
  - [ ] Order
- [x] Remove unnecessary external dependencies: ~~`sed`~~, ~~`awk`~~
- [x] ZSH completion
  - [x] Separate `compdef` into file `functions/_git-ignore`
- [x] `git` sub-command `git ignore`
- [x] Options like `--list`, `--update`, `--search`, etc
- ~~[ ] Configure the plugin with `zstyle`~~
- [ ] Script file compatible with BASH

## Related projects

[wfxr/forgit](https://github.com/wfxr/forgit): [git-ignore](https://github.com/laggardkernel/git-ignore) was designed to be a feature of it. And generating `.gitignore` files **offline** was first introduced by me into it. Later, [git-ignore](https://github.com/laggardkernel) is separated from forgit because of disagreement on implementation.

[dvcs/gitignore](https://github.com/dvcs/gitignore): The largest collection of useful `.gitignore` templates, used by [https://www.gitignore.io](https://www.gitignore.io)

[simonwhitaker/gibo](https://github.com/simonwhitaker/gibo): Another `.gitignore` generator using templates from [github/gitignore](https://github.com/github/gitignore) written in POSIX sh.

## License

The MIT License (MIT)

Copyright (c) 2019 laggardkernel

Copyright (c) 2019 Wenxuan Zhang