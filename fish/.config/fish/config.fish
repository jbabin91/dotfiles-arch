set fish_greeting

#
### GLOBAL VARIABLES
#

# Editor
set -x EDITOR vim
set -x GIT_EDITOR $EDITOR
set -x SUDO_EDITOR $EDITOR
set -x BUNDLER_EDITOR $EDITOR
set -x VISUAL $EDITOR
set -x WEBITOR code

set -x MANPAGER 'less -X' # Don't clear the screen after quitting a manual page
set -x SOURCE_ANNOTATION_DIRECTORIES 'spec'
set -x RUBY_CONFIGURE_OPTS '--with-opt-dir=/usr/local/opt/openssl:/usr/local/opt/readline:/usr/local/opt/libyaml:/usr/local/opt/gdbm'
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x DOTFILES "$HOME/.dotfiles"
set -x PROJECTS "$HOME/Code"
set -x RIPGREP_CONFIG_PATH "$DOTFILES/ripgreprc"

# ls service (currently supports colorls/exa)
set -x LS_SERVICE exa

# rbenv
if not contains -- "$HOME/.rbenv/bin" $PATH
  set -gx PATH $HOME/.rbenv/bin $PATH
end

#
### ENV
#
if [ -f $HOME/.config/fish/env/index.fish ]
  source $HOME/.config/fish/env/index.fish
end

#
### ALIASES
#
# Main
if [ -f $HOME/.config/fish/aliases/index.fish ]
  source $HOME/.config/fish/aliases/index.fish
end

#
### OTHER
#
# Set locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Oh My Fish
if [ -f $HOME/.config/fish/omf.fish ]
  source $HOME/.config/fish/omf.fish
end

# Fisher
if not functions -q fisher
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
  curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
  fish -c fisher
end

# Enable terminal Nerd Fonts
set -g theme_nerd_fonts yes

# Colorls
# if type -q colorls
#     source (dirname (gem which colorls))/tab_complete.sh
# end

# Load settings
if status is-interactive
    source $XDG_CONFIG_HOME/fish/abbreviations.fish
end

# Theme config
if [ -f $HOME/.config/fish/theme.fish ]
  source $HOME/.config/fish/theme.fish
end

#
### LOCAL CONFIGS OVERRIDE
#
# (local settings or computer specific config for example)
if [ -f $HOME/.config/fish/local.fish ]
  source $HOME/.config/fish/local.fish
end

# Deduplicate PATH entries
# dedup_paths
