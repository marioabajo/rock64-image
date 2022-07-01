################################################################################
#
# crio
#
################################################################################

CRIO_VERSION = v1.24.1
CRIO_SITE = https://github.com/cri-o/cri-o/archive/refs/tags
CRIO_SOURCE = $(CRIO_VERSION).tar.gz

CRIO_LICENSE = Apache-2.0
CRIO_LICENSE_FILES = LICENSE

CRIO_TAGS = cgo seccomp

CRIO_DEPENDENCIES = libseccomp libgpgme btrfs-progs lvm2

CRIO_BUILD_TARGETS = cmd/crio 

define CRIO_POST_BUILD_PINNS
	cd $(@D)/pinns; \
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) $(CRIO_MAKE_OPTS) all
endef

define CRIO_POST_INSTALL_TARGET_PINNS
	$(INSTALL) -D -m 0755 $(@D)/bin/pinns $(TARGET_DIR)/usr/bin/pinns
endef

define CRIO_POST_INSTALL_TARGET_CONTRIBS
	$(INSTALL) -D -m 0644 $(@D)/contrib/sysconfig/crio $(TARGET_DIR)/etc/sysconfig/crio
	sed -i -e 's|/usr/local/bin|/usr/bin|' $(@D)/contrib/systemd/crio.service
	sed -i -e 's|/usr/local/bin|/usr/bin|' $(@D)/contrib/systemd/crio-wipe.service
	$(INSTALL) -D -m 0644 $(@D)/contrib/systemd/crio.service $(TARGET_DIR)/lib/systemd/system/crio.service
	$(INSTALL) -D -m 0644 $(@D)/contrib/systemd/crio-wipe.service $(TARGET_DIR)/lib/systemd/system/crio-wipe.service
endef

CRIO_POST_BUILD_HOOKS += CRIO_POST_BUILD_PINNS

CRIO_POST_INSTALL_TARGET_HOOKS += CRIO_POST_INSTALL_TARGET_PINNS
CRIO_POST_INSTALL_TARGET_HOOKS += CRIO_POST_INSTALL_TARGET_CONTRIBS

CRIO_INSTALL_BINS = $(notdir $(CRIO_BUILD_TARGETS))

$(eval $(golang-package))

