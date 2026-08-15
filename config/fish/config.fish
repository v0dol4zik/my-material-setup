if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Catppuccin palette (kept local so it works without extra plugins).
set -g fish_color_normal cdd6f4
set -g fish_color_command a6e3a1 --bold
set -g fish_color_keyword f38ba8
set -g fish_color_quote f9e2af
set -g fish_color_redirection 94e2d5
set -g fish_color_end fab387
set -g fish_color_error f38ba8 --bold
set -g fish_color_param cdd6f4
set -g fish_color_comment 6c7086 --italics
set -g fish_color_selection 1e1e2e --background=89b4fa
set -g fish_color_search_match 1e1e2e --background=f9e2af
set -g fish_color_operator 94e2d5
set -g fish_color_escape cba6f7
set -g fish_color_autosuggestion 6c7086
set -g fish_pager_color_progress 6c7086
set -g fish_pager_color_prefix a6e3a1 --bold
set -g fish_pager_color_completion cdd6f4
set -g fish_pager_color_description 6c7086

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
    set_color fab387
    printf '󰈺  %s, %s' $hello $USER
    set_color 6c7086
    printf '  ·  %s\n' (date '+%d.%m · %H:%M')
    set_color normal
end

# Pure prompt: Catppuccin colors and useful status information.
set -g pure_color_primary fab387
set -g pure_color_info 89b4fa
set -g pure_color_mute 6c7086
set -g pure_color_success a6e3a1
set -g pure_color_danger f38ba8
set -g pure_color_warning f9e2af
set -g pure_color_current_directory fab387
set -g pure_color_git_branch a6e3a1
set -g pure_color_git_dirty f9e2af
set -g pure_color_git_stash cba6f7
set -g pure_color_git_unpushed_commits 89b4fa
set -g pure_color_git_unpulled_commits 94e2d5
set -g pure_color_command_duration f9e2af
set -g pure_enable_git true
set -g pure_show_numbered_git_indicator true
set -g pure_show_exit_status true
set -g pure_threshold_command_duration 3000
set -g pure_truncate_prompt_current_directory_keeps 3
