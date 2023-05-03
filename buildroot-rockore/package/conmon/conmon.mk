################################################################################
#
# podman
#
################################################################################

CONMON_VERSION = v2.1.7
CONMON_SITE = https://github.com/containers/conmon/archive/refs/tags
CONMON_SOURCE = $(CONMON_VERSION).tar.gz

CONMON_LICENSE = Apache-2.0
CONMON_LICENSE_FILES = LICENSE

CONMON_DEPENDENCIES = libglib2 host-go
CONMON_BUILD_TARGETS = bin/conmon

CONMON_INSTALL_BINS = $(notdir $(CONMON_BUILD_TARGETS))

define CONMON_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(ZIP_TARGET_CFLAGS) $(ZIP_CFLAGS)" \
		AS="$(TARGET_CC) -c" \
		-f Makefile
endef

define CONMON_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) -f Makefile install \
		PREFIX=$(TARGET_DIR)/usr
endef

$(eval $(generic-package))
