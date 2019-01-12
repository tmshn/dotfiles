set -x PATH "$HOME/bin" $PATH

# ==========================================================
# Aliases/tools
# ----------------------------------------------------------
alias ssh 'set -l SHELL /bin/sh; command ssh'

set -x EDITOR micro

set -x FZF_DEFAULT_OPTS '--border --cycle --height 30% --layout reverse --exit-0 --select-1'

alias cat bat
alias ll 'exa --git --long --group --classify --header --tree --level=1 --created --modified --accessed --time-style=iso'

function cdrepo --description 'Choose git repo and cd to its root'
    set repo (ghq list | fzf -q "$argv")
    test -n "$repo"; and cd (ghq root)/$repo
end

# ==========================================================
# Languages
# ----------------------------------------------------------
# Go
set -x GOPATH $HOME

# Anyenv
set -x PATH "$HOME/.anyenv/bin" $PATH
status --is-interactive; and source (anyenv init -|psub)

# Pipenv
set -x PIPENV_VENV_IN_PROJECT true

# ==========================================================
# Brewed tools
# ----------------------------------------------------------
# Openssl
set -x PATH "/usr/local/opt/openssl/bin" $PATH

# GNU compaliants
for t in coreutils findutils gnu-sed gnu-tar gnu-time grep
    set -x PATH "/usr/local/opt/$t/libexec/gnubin" $PATH
    set -x MANPATH "/usr/local/opt/$t/libexec/gnuman" $MANPATH
end
