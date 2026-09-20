if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Material 2 palette (kept local so it works without extra plugins).
set -g fish_color_normal e8eaed
set -g fish_color_command 81c995 --bold
set -g fish_color_keyword f28b82
set -g fish_color_quote fdd663
set -g fish_color_redirection 78d9ec
set -g fish_color_end 25e075
set -g fish_color_error f28b82 --bold
set -g fish_color_param e8eaed
set -g fish_color_comment 9aa0a6 --italics
set -g fish_color_selection 121212 --background=25e075
set -g fish_color_search_match 121212 --background=fdd663
set -g fish_color_operator 78d9ec
set -g fish_color_escape c58af9
set -g fish_color_autosuggestion 9aa0a6
set -g fish_pager_color_progress 9aa0a6
set -g fish_pager_color_prefix 81c995 --bold
set -g fish_pager_color_completion e8eaed
set -g fish_pager_color_description 9aa0a6

# A quiet terminal: the prompt already shows everything needed.
function fish_greeting
end

# Pure: one line, neutral context, green prompt, red only for errors.
set -g pure_color_primary 25e075
set -g pure_color_info 25e075
set -g pure_color_mute 9aa0a6
set -g pure_color_success 25e075
set -g pure_color_danger f28b82
set -g pure_color_warning 9aa0a6
set -g pure_color_current_directory e8eaed
set -g pure_color_git_branch 9aa0a6
set -g pure_color_git_dirty 25e075
set -g pure_color_git_stash 9aa0a6
set -g pure_color_git_unpushed_commits 9aa0a6
set -g pure_color_git_unpulled_commits 9aa0a6
set -g pure_color_command_duration 9aa0a6
set -g pure_color_prompt_on_success 25e075
set -g pure_color_prompt_on_error f28b82
set -g pure_color_exit_status f28b82
set -g pure_enable_single_line_prompt true
set -g pure_enable_git true
set -g pure_enable_aws_profile false
set -g pure_show_numbered_git_indicator false
set -g pure_show_system_time false
set -g pure_show_exit_status true
set -g pure_symbol_exit_status_prefix '!'
# Pure measures this threshold in seconds, not milliseconds.
set -g pure_threshold_command_duration 5
set -g pure_truncate_prompt_current_directory_keeps 3
