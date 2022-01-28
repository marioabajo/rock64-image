################################################################################
#
# crun
#
################################################################################

CRUN_VERSION = 1.4.2
CRUN_GIT_VERSION = 8e5757a4e68590326dafe8a8b1b4a584b10a1370
CRUN_SITE = git://github.com/containers/crun.git
CRUN_METHOD = git

CRUN_LICENSE = GPL-2.0+
CRUN_LICENSE_FILES = COPYING

CRUN_DEPENDENCIES = libcap libseccomp libyajl
CRUN_GIT_SUBMODULES = YES

define CRUN_RUN_AUTOGEN
	cd $(@D) && \
	echo -e "/* autogenerated.  */\n#ifndef GIT_VERSION\n# define GIT_VERSION \"$(CRUN_GIT_VERSION)\"\n#endif\n" > git-version.h && \
	PATH=$(BR_PATH) ./autogen.sh
endef
CRUN_PRE_CONFIGURE_HOOKS += CRUN_RUN_AUTOGEN


$(eval $(autotools-package))
