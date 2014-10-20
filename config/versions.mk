# Bliss Versioning System

# Bliss Version
BLISS_VERSION_MAJOR = 4.4
BLISS_VERSION_MINOR = 4.065
BLISS_VERSION_MAINTENANCE =
VERSION := $(BLISS_VERSION_MAJOR).$(BLISS_VERSION_MINOR)$(BLISS_VERSION_MAINTENANCE)

# Set BLISS_BUILDTYPE
ifdef BLISS_NIGHTLY
BLISS_BUILDTYPE := NIGHTLY
endif
ifdef BLISS_EXPERIMENTAL
BLISS_BUILDTYPE := EXPERIMENTAL
endif
ifdef BLISS_RELEASE
BLISS_BUILDTYPE := RELEASE
endif

# Set Unofficial if no buildtype set (Buildtype should ONLY be set by Bliss Devs!)
ifdef BLISS_BUILDTYPE
else
BLISS_BUILDTYPE := UNOFFICIAL
BLISS_VERSION_MAJOR := 4.4
BLISS_VERSION_MINOR := 4.001
endif

# Set BLISS version
ifdef BLISS_RELEASE
BLISS_VERSION := "Bliss-v"$(VERSION)
else
BLISS_VERSION := "$(TARGET_PRODUCT)-v$(VERSION)-$(BLISS_BUILDTYPE)"-$(shell date +%Y%m%d-%H%M)
endif

PRODUCT_PROPERTY_OVERRIDES += \
ro.modversion=$(BLISS_VERSION) \
ro.bliss.version=$(VERSION)-$(BLISS_BUILDTYPE)
ro.bs=true \
