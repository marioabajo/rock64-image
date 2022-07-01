################################################################################
#
# container networking plugins
#
################################################################################

CONTAINERNETWORKING_PLUGINS_VERSION = v1.1.1
CONTAINERNETWORKING_PLUGINS_SITE = https://github.com/containernetworking/plugins/archive/refs/tags
CONTAINERNETWORKING_PLUGINS_SOURCE = $(CONTAINERNETWORKING_PLUGINS_VERSION).tar.gz

CONTAINERNETWORKING_PLUGINS_LICENSE = Apache-2.0
CONTAINERNETWORKING_PLUGINS_LICENSE_FILES = LICENSE

CONTAINERNETWORKING_PLUGINS_BUILD_TARGETS = plugins/meta/bandwidth plugins/meta/firewall plugins/meta/portmap plugins/meta/sbr plugins/meta/tuning plugins/meta/vrf
CONTAINERNETWORKING_PLUGINS_BUILD_TARGETS += plugins/main/bridge plugins/main/host-device plugins/main/ipvlan plugins/main/loopback plugins/main/macvlan plugins/main/ptp plugins/main/vlan
CONTAINERNETWORKING_PLUGINS_BUILD_TARGETS += plugins/ipam/dhcp plugins/ipam/static plugins/ipam/host-local

CONTAINERNETWORKING_PLUGINS_INSTALL_BINS = $(notdir $(CONTAINERNETWORKING_PLUGINS_BUILD_TARGETS))

define CONTAINERNETWORKING_PLUGINS_POST_INSTALL_HELPER
	mkdir -p $(TARGET_DIR)/usr/libexec/cni; \
	for i in $(CONTAINERNETWORKING_PLUGINS_BUILD_TARGETS); do \
		PLUGIN_FILENAME=$$(basename $$i); \
		mv $(TARGET_DIR)/usr/bin/$$PLUGIN_FILENAME $(TARGET_DIR)/usr/libexec/cni/$$PLUGIN_FILENAME; \
	done
endef

CONTAINERNETWORKING_PLUGINS_POST_INSTALL_TARGET_HOOKS += CONTAINERNETWORKING_PLUGINS_POST_INSTALL_HELPER

$(eval $(golang-package))
