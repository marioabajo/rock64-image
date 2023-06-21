################################################################################
#
# Openvswitch
#
################################################################################

OPENVSWITCH_VERSION = v3.1.1
OPENVSWITCH_SITE = https://github.com/openvswitch/ovs/archive/refs/tags
OPENVSWITCH_SOURCE = $(OPENVSWITCH_VERSION).tar.gz

OPENVSWITCH_LICENSE = Apache-2.0
OPENVSWITCH_LICENSE_FILES = LICENSE

OPENVSWITCH_AUTORECONF = YES
OPENVSWITCH_AUTORECONF_OPTS = --install --force
OPENVSWITCH_DEPENDENCIES = libglib2
OPENVSWITCH_CONF_OPTS = --enable-shared
OPENVSWITCH_INSTALL_TARGET = YES

$(eval $(autotools-package))
