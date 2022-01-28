################################################################################
#
# the Shadow Password Suite
#
################################################################################

SHADOW_VERSION = v4.11.1
SHADOW_SITE = $(call github,shadow-maint,shadow,$(SHADOW_VERSION))

SHADOW_LICENSE = Artistic-1.0-Perl
SHADOW_LICENSE_FILES = COPYING

SHADOW_CONF_DEPENDENCIES = libsemanage host-libxslt host-libsemanage
SHADOW_CONF_OPTS = --disable-man --with-sysroot=$(STAGING_DIR) --enable-maintainer-mode --enable-shared --without-libpam --with-selinux
SHADOW_CONF_ENV = CFLAGS="-O2 -Wall"

define SHADOW_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) autoreconf -v -f --install
endef
SHADOW_PRE_CONFIGURE_HOOKS += SHADOW_RUN_AUTOGEN

$(eval $(autotools-package))
