################################################################################
#
# podman
#
################################################################################

PODMAN_VERSION = v3.4.4
#PODMAN_SOURCE = $(PODMAN_VERSION).tar.gz
#PODMAN_SITE = https://github.com/containers/podman/archive/refs/tags              
PODMAN_SITE = $(call github,containers,podman,$(PODMAN_VERSION))

PODMAN_LICENSE = Apache-2.0
PODMAN_LICENSE_FILES = LICENSE

# other available tags: libdm_no_deferred_remove
PODMAN_TAGS = cgo exclude_graphdriver_devicemapper
PODMAN_DEPENDENCIES = libgpgme conmon btrfs-progs

# Add btrfs support
#ifeq ($(BR2_PACKAGE_BTRFS_PROGS),y)
#PODMAN_DEPENDENCIES += libbtrfs
#else
#PODMAN_TAGS += exclude_graphdriver_btrfs
#endif

# Add seccomp support
ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
PODMAN_TAGS += seccomp
PODMAN_DEPENDENCIES += libseccomp
endif

# Add systemd support
ifeq ($(BR2_PACKAGE_SYSTEMD),y)
PODMAN_TAGS += systemd
PODMAN_DEPENDENCIES += systemd
endif

# Add selinux support
ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
PODMAN_TAGS += selinux
endif

# Add apparmor support
ifeq ($(BR2_PACKAGE_LIBAPPARMOR),y)
PODMAN_TAGS += apparmor
PODMAN_DEPENDENCIES += libapparmor
endif

PODMAN_GOMOD = .
PODMAN_BUILD_TARGETS = cmd/podman
PODMAN_INSTALL_BINS = $(notdir $(PODMAN_BUILD_TARGETS))

# TODO:
# copy file ./vendor/github.com/containers/common/pkg/seccomp/seccomp.json as /usr/share/containers/seccomp.json
# generate file /etc/containers/registries.conf
# wget https://raw.githubusercontent.com/containers/libpod/master/cni/87-podman-bridge.conflist
# copy file /etc/cni/net.d/87-podman-bridge.conflist
# generate file /etc/containers/policy.json for example with ./test/policy.json
# generate file /etc/containers/registries.conf
# create directory /etc/containers/registries.d


$(eval $(golang-package))

