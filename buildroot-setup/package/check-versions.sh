#!/bin/bash

# Github based repositories
repo=(cri-o/cri-o containers/conmon containernetworking/plugins kubernetes-sigs/cri-tools containers/crun containers/podman shadow-maint/shadow rootless-containers/slirp4netns)
package=(crio conmon containernetworking-plugins cri-tools crun podman shadow slirp4netns)

printf "%-50s %-10s %-10s\n" Package current_v upstream_v

for i in ${!repo[@]}
do
	pkg=${package[i]}
	pkg2=${pkg/-/_}
	current="$(awk "/${pkg2^^}_VERSION =/ {print \$3}" ${pkg}/${pkg}.mk)"
	upstream="$(curl -sL https://api.github.com/repos/${repo[i]}/releases | jq '.[].tag_name' | sort -rn | head -1)"
	#upstream="null"
	printf "%-50s %-10s %-10s\n" ${repo[i]} ${current} ${upstream//\"/}
done

# kernel
current="$(awk -v FS="=" "/BR2_LINUX_KERNEL_VERSION/{gsub(\"\\\"\",\"\"); print \$2}" ../buildroot.config)"
upstream="$(curl -s https://www.kernel.org/releases.json | jq '.latest_stable.version' -r)"
printf "%-50s %-10s %-10s\n" linux-kernel ${current} ${upstream}
