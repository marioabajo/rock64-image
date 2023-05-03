################################################################################
#
# ignition
#
################################################################################

IGNITION_VERSION = v2.10.1
IGNITION_SITE = $(call github,coreos,ignition,$(IGNITION_VERSION))

IGNITION_LICENSE = Apache-2.0
IGNITION_LICENSE_FILES = LICENSE

IGNITION_LDFLAGS = -X github.com/coreos/ignition/v2/internal/version.Raw=${VERSION}

IGNITION_DEPENDENCIES = libseccomp libgpgme btrfs-progs lvm2

IGNITION_BUILD_TARGETS = cmd/crio 


$(eval $(golang-package))

