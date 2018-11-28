set -x PATH "$HOME/bin" $PATH
set -x GOPATH $HOME

set -x EDITOR micro

set -x FZF_DEFAULT_OPTS '--border --cycle --height 30% --exit-0 --select-1'

alias cat bat

set -x PATH "$HOME/.anyenv/bin" $PATH
status --is-interactive; and source (anyenv init -|psub)
