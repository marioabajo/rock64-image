#!/bin/bash

version=2023.02
repo=(containers/conmon containers/podman kubernetes-sigs/cri-tools cri-o/cri-o shadow-maint/shadow rootless-containers/slirp4netns slirp/libslirp)
PACKAGES=(conmon podman cri-tools crio shadow slirp4netns libslirp)

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
	echo "---- Creating patch for: ${PACKAGES[i]}"
	pkg=${PACKAGES[i]}

	cd buildroot-${version}-b

	# Create hash file
	pkg2=${pkg/-/_}
	current="$(awk "/${pkg2^^}_VERSION =/ {print \$3}" ../../buildroot-setup/package/${pkg}/${pkg}.mk)"
	echo "Current version: $current"
	file="$(curl -sL https://api.github.com/repos/${repo[i]}/releases | jq '.[] | select(.tag_name == "'${current}'") | .tarball_url')"
	echo "source file: $file"
	#wget -q -O - https://api.github.com/repos/${repo[i]}/tarball/${current} | sha256sum > ../../buildroot-setup/package/$pkg/$pkg.hash
	#source_defined="$( awk "/${pkg2^^}_SOURCE =/ {print \$3}" ../../buildroot-setup/package/${pkg}/${pkg}.mk))"
	#if [ ! -z "$source_defined" ]; then
	#	sed -i -e 's/-/'${pkg}'-'${source_defined}'/' ../../buildroot-setup/package/$pkg/$pkg.hash
	#else
	#	sed -i -e 's/-/'${pkg}'-'${current}'-br1.tar.gz/' ../../buildroot-setup/package/$pkg/$pkg.hash
	#fi

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
