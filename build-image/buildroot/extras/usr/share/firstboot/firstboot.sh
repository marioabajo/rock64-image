#!/bin/bash

set -x -e
exec 2> /tmp/first-boot.log

trap "echo HUP detected" HUP

title="First boot script"
FIRSTBOOT_DIR="/usr/share/firstboot"
TASK_DIR="$FIRSTBOOT_DIR/tasks"
script="$( mktemp )"

cat <<- EOF > "$script"
	#!/bin/sh
	# \$Id: gauge,v 1.7 2010/01/13 10:20:03 tom Exp $

	TOTAL=\$( ls -1 $TASK_DIR | wc -l )
	STEP=\$( expr 100 / \$TOTAL )
	PCT=\$STEP
	(
	for task in $TASK_DIR/*
	do
		cat <<- EOF2
			XXX
			\$PCT
			\$( awk '/^# Desc:$/ {getline; print substr(\$0,3)}' "\$task" )
			XXX
		EOF2
		PCT=\$( expr \$PCT + \$STEP )
		echo "#### \$task :" >> /tmp/first-boot.log
		bash -e "\$task" >> /tmp/first-boot.log 2>&1
	done
	) | TERM="vt100" dialog --title "$title" "\$@" --gauge "Running configuration tasks" 7 70 0
EOF

tmux new-session -d "/bin/sh $script"
SCRIPT_PID="$( tmux list-panes -a -F "#{pane_pid}" )"
tmux split-window -v "tail -f /tmp/first-boot.log --pid $SCRIPT_PID"
tmux attach-session -d

# Remove temp files with scripts
rm -f "$script"

# Last steps:
$FIRSTBOOT_DIR/last_step.sh
