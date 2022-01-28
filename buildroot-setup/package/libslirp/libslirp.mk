################################################################################
#
# libslirp
#
################################################################################

LIBSLIRP_VERSION = v4.6.1
LIBSLIRP_SITE = https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.6.1

LIBSLIRP_LICENSE = 
LIBSLIRP_LICENSE_FILES = COPYRIGHT
LIBSLIRP_INSTALL_STAGING = YES

LIBSLIRP_DEPENDENCIES = libglib2

$(eval $(meson-package))
