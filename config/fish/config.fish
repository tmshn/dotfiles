# Disable greeting
set fish_greeting

pushd (dirname (status -f))
    source tools.fish
    source prompt.fish
    source secret.fish
popd
