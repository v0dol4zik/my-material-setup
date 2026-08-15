if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Gruvbox Dark palette (kept local so it works without extra plugins).
set -g fish_color_normal ebdbb2
set -g fish_color_command b8bb26 --bold
set -g fish_color_keyword fb4934
set -g fish_color_quote fabd2f
set -g fish_color_redirection 8ec07c
set -g fish_color_end fe8019
set -g fish_color_error fb4934 --bold
set -g fish_color_param ebdbb2
set -g fish_color_comment 928374 --italics
set -g fish_color_selection 282828 --background=83a598
set -g fish_color_search_match 282828 --background=fabd2f
set -g fish_color_operator 8ec07c
set -g fish_color_escape d3869b
set -g fish_color_autosuggestion 928374
set -g fish_pager_color_progress 928374
set -g fish_pager_color_prefix b8bb26 --bold
set -g fish_pager_color_completion ebdbb2
set -g fish_pager_color_description 928374

# Minimal greeting without a system-information dump.
function fish_greeting
    set -l hour (date +%H)
    set -l hello Доброй_ночи

    if test $hour -ge 5 -a $hour -lt 12
        set hello Доброе_утро
    else if test $hour -ge 12 -a $hour -lt 18
        set hello Добрый_день
    else if test $hour -ge 18 -a $hour -lt 23
        set hello Добрый_вечер
    end

    set hello (string replace _ ' ' $hello)
    set_color fe8019
    printf '󰈺  %s, %s' $hello $USER
    set_color 928374
    printf '  ·  %s\n' (date '+%d.%m · %H:%M')
    set_color normal
end

# Pure prompt: Gruvbox colors and useful status information.
set -g pure_color_primary fe8019
set -g pure_color_info 83a598
set -g pure_color_mute 928374
set -g pure_color_success b8bb26
set -g pure_color_danger fb4934
set -g pure_color_warning fabd2f
set -g pure_color_current_directory fe8019
set -g pure_color_git_branch b8bb26
set -g pure_color_git_dirty fabd2f
set -g pure_color_git_stash d3869b
set -g pure_color_git_unpushed_commits 83a598
set -g pure_color_git_unpulled_commits 8ec07c
set -g pure_color_command_duration d79921
set -g pure_enable_git true
set -g pure_show_numbered_git_indicator true
set -g pure_show_exit_status true
set -g pure_threshold_command_duration 3000
set -g pure_truncate_prompt_current_directory_keeps 3
