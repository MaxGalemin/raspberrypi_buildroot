################################################################################
#
# imagemagick
#
################################################################################

IMAGEMAGICK_VERSION = 6.9.1-4
IMAGEMAGICK_SOURCE = ImageMagick-$(IMAGEMAGICK_VERSION).tar.xz
IMAGEMAGICK_SITE = http://www.imagemagick.org/download/releases
IMAGEMAGICK_LICENSE = Apache-2.0
IMAGEMAGICK_LICENSE_FILES = LICENSE

IMAGEMAGICK_INSTALL_STAGING = YES
IMAGEMAGICK_CONFIG_SCRIPTS = \
	$(addsuffix -config,Magick MagickCore MagickWand Wand)

ifeq ($(BR2_INSTALL_LIBSTDCPP)$(BR2_USE_WCHAR),yy)
IMAGEMAGICK_CONFIG_SCRIPTS += Magick++-config
endif

IMAGEMAGICK_CONF_ENV = ac_cv_sys_file_offset_bits=64

IMAGEMAGICK_CONF_OPTS = \
	--program-transform-name='s,,,' \
	--disable-openmp \
	--without-perl \
	--without-wmf \
	--without-openexr \
	--without-jp2 \
	--without-jbig \
	--without-gvc \
	--without-djvu \
	--without-dps \
	--without-gslib \
	--without-fpx \
	--without-x

IMAGEMAGICK_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
IMAGEMAGICK_CONF_OPTS += --with-fontconfig
IMAGEMAGICK_DEPENDENCIES += fontconfig
else
IMAGEMAGICK_CONF_OPTS += --without-fontconfig
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
IMAGEMAGICK_CONF_OPTS += --with-freetype
IMAGEMAGICK_CONF_ENV += \
	ac_cv_path_freetype_config=$(STAGING_DIR)/usr/bin/freetype-config
IMAGEMAGICK_DEPENDENCIES += freetype
else
IMAGEMAGICK_CONF_OPTS += --without-freetype
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
IMAGEMAGICK_CONF_OPTS += --with-jpeg
IMAGEMAGICK_DEPENDENCIES += jpeg
else
IMAGEMAGICK_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
IMAGEMAGICK_CONF_OPTS += --with-png
IMAGEMAGICK_DEPENDENCIES += libpng
else
IMAGEMAGICK_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_LIBRSVG),y)
IMAGEMAGICK_CONF_OPTS += --with-rsvg
IMAGEMAGICK_DEPENDENCIES += librsvg
else
IMAGEMAGICK_CONF_OPTS += --without-rsvg
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
IMAGEMAGICK_CONF_OPTS += --with-xml
IMAGEMAGICK_CONF_ENV += ac_cv_path_xml2_config=$(STAGING_DIR)/usr/bin/xml2-config
IMAGEMAGICK_DEPENDENCIES += libxml2
else
IMAGEMAGICK_CONF_OPTS += --without-xml
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
IMAGEMAGICK_CONF_OPTS += --with-tiff
IMAGEMAGICK_DEPENDENCIES += tiff
else
IMAGEMAGICK_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_FFTW),y)
# configure script misdetects these leading to build errors
IMAGEMAGICK_CONF_ENV += ac_cv_func_creal=yes ac_cv_func_cimag=yes
IMAGEMAGICK_CONF_OPTS += --with-fftw
IMAGEMAGICK_DEPENDENCIES += fftw
else
IMAGEMAGICK_CONF_OPTS += --without-fftw
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
IMAGEMAGICK_CONF_OPTS += --with-zlib
IMAGEMAGICK_DEPENDENCIES += zlib
else
IMAGEMAGICK_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
IMAGEMAGICK_CONF_OPTS += --with-bzlib
IMAGEMAGICK_DEPENDENCIES += bzip2
else
IMAGEMAGICK_CONF_OPTS += --without-bzlib
endif

$(eval $(autotools-package))
