#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
	selected=$1
else
	# selected=$(find ~/work ~/work/spid -mindepth 1 -type d | fzf)
	selected=$( (
		# find ~/work ~/personal -maxdepth 2 -type d -not -path "*/node_modules*" -exec sh -c 'test -d "$1"/.git' -- {} \; -print -prune 2>/dev/null
		fdfind --type d --max-depth 3 --exclude "node_modules" --full-path . ~/work ~/personal | while read -r dir; do
			if [ -d "$dir/.git" ] || [ -f "$dir/HEAD" ]; then
				echo "$dir"
			fi
		done
		find ~/dotfiles -type d -maxdepth 0
	) | fzf)
fi

if [[ -z $selected ]]; then
	exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
	tmux new-session -s "$selected_name" -c "$selected"
	exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
	tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
