#!/bin/bash
set -e

# If buildroot version is not set, quit
if [ -z $VERS ]; then
	echo "ERROR: no buildroot version defined, check \"VERS\" env variable"
	exit 2
fi

# If no build command is supplied, quit
if [ -z $RUNCMD ]; then
	echo "ERROR: no build command defined, check \"RUNCMD\" env variable"
	exit 3
fi

# If no repository is supplied, quit
if [ -z $REPO ]; then
	echo "ERROR: no repository defined, check \"REPO\" env variable"
	exit 4
fi

[ -d build ] || mkdir build
cd build

if [ "$UPDATE_CONFIG" == 1 ] || [ ! -e ".git_clone" ]; then
	[ -d "rock64-image" ] && rm -rf rock64-image
	git clone "$REPO"
	touch .git_clone
fi

./rock64-image/build.sh
