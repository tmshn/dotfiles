set -x PATH "$HOME/bin" $PATH

# ==========================================================
# Aliases/tools
# ----------------------------------------------------------
alias ssh 'set -l SHELL /bin/sh; command ssh'

set -x EDITOR micro

set -x FZF_DEFAULT_OPTS '--border --cycle --height 30% --layout reverse --exit-0 --select-1'

alias cat bat
alias ll 'exa --git --long --group --classify --header --tree --level=1 --created --modified --accessed --time-style=iso'

function __cd_candidate
    function __label_cd_list
        sed -E (printf 's#^%s/#~/#; s/$/\\\\x0 \\033[93m(%s)\\033[0m/' "$HOME" "$argv")
    end

    begin
        ghq list --full-path                            | __label_cd_list GHQ
        git rev-parse --show-cdup 2> /dev/null | grep . | __label_cd_list Repo root
        find . -maxdepth 1 -mindepth 1 -type d          | __label_cd_list Current dir
        echo -s $dirprev\n | grep . | sort -u           | __label_cd_list History
    end | fzf --no-multi --query="$argv" --ansi \
        | cut -d '' -f 1 | string escape --no-quoted | sed -E 's/^\\\\~/~/'
end

function __my_complete
    set -l _argv (commandline -o)
    set -l _cmd $_argv[1]
    set -e _argv[1]
    switch "$_cmd"
        case 'cd'
            commandline (printf 'cd %s' (__cd_candidate $_argv))
    end
    commandline -f repaint
end

function fish_user_key_bindings
    bind \t forward-char
    bind \t\t complete
    bind -k btab __my_complete
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
