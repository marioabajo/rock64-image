################################################################################
#
# slirp4netns
#
################################################################################

SLIRP4NETNS_VERSION = v1.1.12
SLIRP4NETNS_SITE = $(call github,rootless-containers,slirp4netns,$(SLIRP4NETNS_VERSION))

SLIRP4NETNS_LICENSE = GPL-2.0+
SLIRP4NETNS_LICENSE_FILES = COPYING

SLIRP4NETNS_DEPENDENCIES = libglib2 libslirp libcap libseccomp

define SLIRP4NETNS_RUN_AUTOGEN
        cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
SLIRP4NETNS_PRE_CONFIGURE_HOOKS += SLIRP4NETNS_RUN_AUTOGEN


$(eval $(autotools-package))
