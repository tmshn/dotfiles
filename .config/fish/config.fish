# Disable greeting
set fish_greeting

function ssh --description 'Wrapper of ssh to allow POSIX-shell style proxy commands'
    set -l SHELL /bin/sh
    /usr/bin/ssh $argv
end

pushd (dirname (status -f))
    source tools.fish
    source prompt.fish
popd
