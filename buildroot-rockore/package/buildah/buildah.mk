################################################################################
#
# buildah
#
################################################################################

BUILDAH_VERSION = v1.24.4
BUILDAH_SITE = https://github.com/containers/buildah/archive/refs/tags
BUILDAH_SOURCE = $(BUILDAH_VERSION).tar.gz

BUILDAH_LICENSE = Apache-2.0
BUILDAH_LICENSE_FILES = LICENSE

# other available tags: libdm_no_deferred_remove
BUILDAH_TAGS = seccomp
BUILDAH_DEPENDENCIES = libgpgme btrfs-progs libseccomp 

# BUILDAH_DEPENDENCIES += bats containers-common

$(eval $(golang-package))

