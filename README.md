# Arch Dotfiles

## Installing

You will need `git` and GNU `stow`

Clone into your `$HOME` directory or `~`

``` sh
git clone https://github.com/jbabin91/dotfiles-arch.git ~/.dotfiles
```

Run `stow` to symlink everything or just select what you want

``` sh
stow */ # Everything (the '/' ignores the README)
```

``` sh
stow nvim # Just the nvim config
```
