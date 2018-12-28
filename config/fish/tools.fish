set -x PATH "$HOME/bin" $PATH
set -x GOPATH $HOME

set -x EDITOR micro

set -x FZF_DEFAULT_OPTS '--border --cycle --height 30% --layout reverse --exit-0 --select-1'

alias cat bat
alias goto 'cd (ghq root)/(ghq list | fzf)'
alias ll 'exa --git --long --group --classify --header --tree --level=1 --created --modified --accessed --time-style=iso'

set -x PATH "$HOME/.anyenv/bin" $PATH
status --is-interactive; and source (anyenv init -|psub)

# Pipenv
set -x PIPENV_VENV_IN_PROJECT true

# Brewed tools
set -x PATH "/usr/local/opt/openssl/bin" $PATH
set -x PATH "/usr/local/opt/coreutils/libexec/gnubin" $PATH
set -x PATH "/usr/local/opt/findutils/libexec/gnubin" $PATH
set -x PATH "/usr/local/opt/gnu-sed/libexec/gnubin" $PATH
set -x PATH "/usr/local/opt/gnu-tar/libexec/gnubin" $PATH
set -x PATH "/usr/local/opt/gnu-time/libexec/gnubin" $PATH
set -x PATH "/usr/local/opt/grep/libexec/gnubin" $PATH
