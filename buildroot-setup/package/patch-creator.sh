#!/bin/bash

version=2022.05
repo=(cri-o/cri-o containers/conmon containernetworking/plugins kubernetes-sigs/cri-tools containers/crun containers/podman shadow-maint/shadow rootless-containers/slirp4netns)
PACKAGES=(conmon podman containernetworking-plugins cri-tools crio libslirp slirp4netns libyajl crun shadow)

[ $# -ge 1 ] && PACKAGES=$@

[ ! -e ../../temp ] && mkdir ../../temp
cd ../../temp

# download buildroot if it doesn't exist
if ! [ -e buildroot-${version} ]; then
	wget https://buildroot.org/downloads/buildroot-${version}.tar.gz
	tar -zxpf buildroot-${version}.tar.gz
fi

# create the two trees (a and b)
cp -a buildroot-${version} buildroot-${version}-a
cp -a buildroot-${version} buildroot-${version}-b

# Start patch num as:
num=10

for i in ${!PACKAGES[@]}
do
	pkg=${PACKAGES[i]}

	cd buildroot-${version}-b

	# Create hash file
	pkg2=${pkg/-/_}
	current="$(awk "/${pkg2^^}_VERSION =/ {print \$3}" ../../buildroot-setup/package/${pkg}/${pkg}.mk)"
	file="$(curl -sL https://api.github.com/repos/${repo[i]}/releases | jq '.[] | select(.tag_name == "'${current}'") | .tarball_url')"
	if grep -s "^${pkg2^^}_SOURCE" ../../buildroot-setup/package/$pkg/$pkg.mk; then
		echo "TODO: $file"
	fi

	cp -a ../../buildroot-setup/package/$pkg package/
	patch -p1 < ../../buildroot-setup/package/$pkg-config.patch
	rm -f package/Config.in.orig
	cd ..
	diff -uNr --no-dereference buildroot-${version}-a buildroot-${version}-b > ../buildroot-setup/patches/${num}-${pkg}.patch
	cd buildroot-${version}-a
	patch -p1 < ../../buildroot-setup/patches/${num}-${pkg}.patch
	cd ..
	num=$((num + 10))
done
rm -rf buildroot-${version}-a buildroot-${version}-b
