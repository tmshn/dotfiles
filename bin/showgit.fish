#!/usr/bin/env fish

if count $argv > /dev/null
    cd $argv[1]
end

if not git status > /dev/null 2>&1
    short-pwd -n 6
    exit
end

# Description of detached HEAD
set __fish_git_prompt_describe_style describe

# Branch state against upstream
set __fish_git_prompt_showupstream informative
set __fish_git_prompt_char_upstream_prefix ' '
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'
set __fish_git_prompt_char_upstream_diverged '+-'

# Color
set __fish_git_prompt_color_merging 'yellow'
set __fish_git_prompt_color_branch_detached 'red'
set __fish_git_prompt_color_upstream 'cyan'

# Local state
set __fish_git_prompt_showdirtystate yes
set __fish_git_prompt_showstashstate yes
set __fish_git_prompt_showuntrackedfiles yes
set __fish_git_prompt_char_dirtystate 'M'
set __fish_git_prompt_char_stashstate '$'
set __fish_git_prompt_char_untrackedfiles '?'
set __fish_git_prompt_char_invalidstate 'x'
set __fish_git_prompt_char_stagedstate 's'

printf '%s%s' (git repo-name) (__fish_git_prompt)
