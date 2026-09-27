if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Colors live in conf.d/noctalia-colors.fish, rendered from the Noctalia palette.

# A quiet terminal: the prompt already shows everything needed.
function fish_greeting
end

# Pure: one line, no clock, exit status on errors.
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

# User-installed commands; fish_add_path skips entries that are already there.
fish_add_path -g ~/.local/bin
