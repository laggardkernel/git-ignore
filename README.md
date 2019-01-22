# git-ignore

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

ZSH plugin. Generate `.gitignore` with templates from [gitignore.io](https://www.gitignore.io/) **offline**, taking the advantage of [`fzf`](https://github.com/junegunn/fzf) fuzzy finder, [`bat`](https://github.com/sharkdp/bat) syntax highlighting and ZSH completion.

![images/preview-01.jpg](../assets/images/preview-01.jpg?raw=true)

## Feature
- Use `gitignore` command to generate `.gitignore` files
    - may be changed to `git ignore` later
- Templates selection helped by fuzzy finder with preview
- ZSH completion for command `gitignore`
- Use same [`.gitignore` templates](https://github.com/dvcs/gitignore) used by [gitignore.io](https://www.gitignore.io/)
- Imitate templates generation behavior as [gitignore.io](https://www.gitignore.io/) exactly

## Installation

[`fzf`](https://github.com/junegunn/fzf) is not a must, but it's highly recommended to use `git-ignore` with it. There's

### [Zplugin](https://github.com/zdharma/zplugin)

The only ZSH plugin manager solves the time-consuming init for nvm, nodenv, pyenv, rnv, rbenv, thefuck, fasd, etc, with its amazing async [Turbo Mode](https://github.com/zdharma/zplugin#turbo-mode-zsh--53).

```zsh
zplugin light laggardkernel/git-ignore
```

Update the plugin with

```zsh
zplg update laggardkernel/git-ignore
```

### [Prezto](https://github.com/sorin-ionescu/prezto)

The only framework does **optimizations** for plugins with sophisticated coding skill:
- [refreshing `.zcompdump` every 20h](https://github.com/sorin-ionescu/prezto/blob/4abbc5572149baa6a5e7e38393a4b2006f01024f/modules/completion/init.zsh#L31-L41)
- [compiling bytecode for `.zcompdump` at the background](https://github.com/sorin-ionescu/prezto/blob/4abbc5572149baa6a5e7e38393a4b2006f01024f/runcoms/zlogin#L9-L15)
- [caching init script for fasd](https://github.com/sorin-ionescu/prezto/blob/4abbc5572149baa6a5e7e38393a4b2006f01024f/modules/fasd/init.zsh#L22-L36)
- saving `*env` startup time with [`init - --no-rehash` for `rbenv`, `pyenv`, `nodenv`](https://github.com/sorin-ionescu/prezto/blob/4abbc5572149baa6a5e7e38393a4b2006f01024f/modules/python/init.zsh#L22)
- [removing the horribly time-consuming `brew command` from `command-not-found`](https://github.com/sorin-ionescu/prezto/blob/4abbc5572149baa6a5e7e38393a4b2006f01024f/modules/command-not-found/init.zsh)

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
alias gi="gitignore"

# with fzf installed
gi

# or, gi string1 string2
gi macos linux windows vim emacs > ./.gitignore
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

- [x] Remove unnecessary external dependencies: ~~`sed`, `awk`~~
- [ ] ZSH completion (half done)
- [ ] Configure the plugin with `zstyle`
- [ ] Migrate `gitignore` as sub command `git ignore`

## Credits

[Git-ignore](https://github.com/laggardkernel) is originally based on [wfxr/forgit](https://github.com/wfxr/forgit). [laggardkernel](https://github.com/laggardkernel) added the feature to generate `.gitignore` files using templates **offline**. Later, this function is separated as [laggardkernel/git-ignore](https://github.com/laggardkernel) because of disagreement on implementation.

## License

The MIT License (MIT)

Copyright (c) 2019 laggardkernel

Copyright (c) 2019 Wenxuan Zhang
