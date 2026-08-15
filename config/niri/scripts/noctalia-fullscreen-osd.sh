#!/usr/bin/env bash

# Noctalia has one shared screen-edge offset for OSDs. Keep the bar's reserved
# area in normal mode, but release it while the focused window is fullscreen so
# overlay OSDs can anchor to the physical top edge.
bar_mode=reserved

sync_bar_reservation() {
    if niri msg -j focused-window 2>/dev/null | grep -q '"is_fullscreen":true'; then
        wanted_mode=overlay
    else
        wanted_mode=reserved
    fi

    if [[ "$wanted_mode" != "$bar_mode" ]]; then
        if noctalia msg bar-reserve-toggle main >/dev/null 2>&1; then
            bar_mode=$wanted_mode
        fi
    fi
}

sync_bar_reservation

niri msg -j event-stream 2>/dev/null | while IFS= read -r _event; do
    sync_bar_reservation
done
