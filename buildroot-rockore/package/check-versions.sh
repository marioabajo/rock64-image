#!/bin/bash

# Github based repositories
repo=(containers/conmon containers/podman containernetworking/plugins kubernetes-sigs/cri-tools cri-o/cri-o containers/crun shadow-maint/shadow rootless-containers/slirp4netns lloyd/yajl slirp/libslirp)
PACKAGES=(conmon podman containernetworking-plugins cri-tools crio crun shadow slirp4netns libyajl libslirp)

printf "%-50s %-10s %-10s\n" Package current_v upstream_v

for i in ${!repo[@]}
do
	pkg=${PACKAGES[i]}
	pkg2=${pkg/-/_}
	current="$(awk "/${pkg2^^}_VERSION =/ {print \$3}" ${pkg}/${pkg}.mk)"
	upstream="$(curl -sL https://api.github.com/repos/${repo[i]}/releases | jq '.[].tag_name' | tr -d '[a-zA-Z-]' | sort -rV | head -1)"
	#upstream="null"
	printf "%-50s %-10s %-10s\n" ${repo[i]} ${current} ${upstream//\"/}
done

# kernel
current="$(awk -v FS="=" "/BR2_LINUX_KERNEL_VERSION/{gsub(\"\\\"\",\"\"); print \$2}" ../buildroot.config)"
upstream="$(curl -s https://www.kernel.org/releases.json | jq '.latest_stable.version' -r)"
printf "%-50s %-10s %-10s\n" linux-kernel ${current} ${upstream}
