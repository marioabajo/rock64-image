################################################################################
#
# cri-tools
#
################################################################################

CRI_TOOLS_VERSION = v1.24.2
CRI_TOOLS_SITE = https://github.com/kubernetes-sigs/cri-tools/archive/refs/tags
CRI_TOOLS_SOURCE = $(CRI_TOOLS_VERSION).tar.gz

CRI_TOOLS_LICENSE = Apache-2.0
CRI_TOOLS_LICENSE_FILES = LICENSE

CRI_TOOLS_TAGS = selinux

CRI_TOOLS_BUILD_TARGETS = cmd/crictl

CRI_TOOLS_INSTALL_BINS = $(notdir $(CRI_TOOLS_BUILD_TARGETS))

$(eval $(golang-package))

#define CRI_TOOLS_BUILD_CMDS 
#	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) all
#endef

#define CRI_TOOLS_INSTALL_TARGET_CMDS
#	$(INSTALL) -D -m 0755 $(@D)/crictl $(TARGET_DIR)/usr/bin
#endef

#$(eval $(generic-package))
