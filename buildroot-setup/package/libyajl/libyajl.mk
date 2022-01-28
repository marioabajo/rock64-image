################################################################################
#
# yajl - Yet Another JSON Library
#
################################################################################

LIBYAJL_VERSION = 2.1.0
LIBYAJL_SITE = $(call github,lloyd,yajl,$(LIBYAJL_VERSION))
LIBYAJL_INSTALL_STAGING = YES
LIBYAJL_INSTALL_TARGET = YES

$(eval $(cmake-package))
