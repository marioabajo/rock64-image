#!/bin/bash

# Github based repositories
repo="cri-o/cri-o containers/conmon containernetworking/plugins kubernetes-sigs/cri-tools containers/crun containers/podman shadow-maint/shadow rootless-containers/slirp4netns"

for i in $repo
do
	printf "%-50s " $i
	curl -sL https://api.github.com/repos/$i/releases/latest | jq -r ".tag_name"
done

# kernel
printf "%-50s " linux-kernel
curl -s https://www.kernel.org/releases.json | jq '.latest_stable.version' -r

