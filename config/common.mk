PRODUCT_BRAND ?= bliss

SUPERUSER_EMBEDDED := false
SUPERUSER_PACKAGE_PREFIX := com.android.settings.cyanogenmod.superuser

# To deal with CM9 specifications
# TODO: remove once all devices have been switched
ifneq ($(TARGET_BOOTANIMATION_NAME),)
TARGET_SCREEN_DIMENSIONS := $(subst -, $(space), $(subst x, $(space), $(TARGET_BOOTANIMATION_NAME)))
ifeq ($(TARGET_SCREEN_WIDTH),)
TARGET_SCREEN_WIDTH := $(word 2, $(TARGET_SCREEN_DIMENSIONS))
endif
ifeq ($(TARGET_SCREEN_HEIGHT),)
TARGET_SCREEN_HEIGHT := $(word 3, $(TARGET_SCREEN_DIMENSIONS))
endif
endif

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# clear TARGET_BOOTANIMATION_NAME in case it was set for CM9 purposes
TARGET_BOOTANIMATION_NAME :=

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/bliss/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif

ifdef CM_NIGHTLY
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmodnightly
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmod
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    pm.sleep_mode=0 \
    ro.ril.disable.power.collapse=0 \
    ro.vold.umsdirtyratio=20

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1 \
    persist.sys.root_access=1 \
    persist.sys.dun.override=0

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/bliss/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/bliss/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh \
    vendor/bliss/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# init.d support
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/bliss/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/bliss/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/bliss/prebuilt/common/etc/backup.conf:system/etc/backup.conf \
    vendor/bliss/prebuilt/common/etc/init.d/00check:system/etc/init.d/00check \
    vendor/bliss/prebuilt/common/etc/init.d/01zipalign:system/etc/init.d/01zipalign \
    vendor/bliss/prebuilt/common/etc/init.d/02sysctl:system/etc/init.d/02sysctl \
    vendor/bliss/prebuilt/common/etc/init.d/03firstboot:system/etc/init.d/03firstboot \
    vendor/bliss/prebuilt/common/etc/init.d/05freemem:system/etc/init.d/05freemem \
    vendor/bliss/prebuilt/common/etc/init.d/06removecache:system/etc/init.d/06removecache \
    vendor/bliss/prebuilt/common/etc/init.d/07fixperms:system/etc/init.d/07fixperms \
    vendor/bliss/prebuilt/common/etc/init.d/09cron:system/etc/init.d/09cron \
    vendor/bliss/prebuilt/common/etc/init.d/10sdboost:system/etc/init.d/10sdboost \
    vendor/bliss/prebuilt/common/etc/init.d/11battery:system/etc/init.d/11battery \
    vendor/bliss/prebuilt/common/etc/init.d/12touch:system/etc/init.d/12touch \
    vendor/bliss/prebuilt/common/etc/init.d/13minfree:system/etc/init.d/13minfree \
    vendor/bliss/prebuilt/common/etc/init.d/14gpurender:system/etc/init.d/14gpurender \
    vendor/bliss/prebuilt/common/etc/init.d/15sleepers:system/etc/init.d/15sleepers \
    vendor/bliss/prebuilt/common/etc/init.d/16journalism:system/etc/init.d/16journalism \
    vendor/bliss/prebuilt/common/etc/init.d/17sqlite3:system/etc/init.d/17sqlite3 \
    vendor/bliss/prebuilt/common/etc/init.d/18wifisleep:system/etc/init.d/18wifisleep \
    vendor/bliss/prebuilt/common/etc/init.d/19iostats:system/etc/init.d/19iostats \
    vendor/bliss/prebuilt/common/etc/init.d/20setrenice:system/etc/init.d/20setrenice \
    vendor/bliss/prebuilt/common/etc/init.d/21tweaks:system/etc/init.d/21tweaks \
    vendor/bliss/prebuilt/common/etc/init.d/24speedy_modified:system/etc/init.d/24speedy_modified \
    vendor/bliss/prebuilt/common/etc/init.d/25loopy_smoothness_tweak:system/etc/init.d/25loopy_smoothness_tweak \
    vendor/bliss/prebuilt/common/etc/init.d/98tweaks:system/etc/init.d/98tweaks \
    vendor/bliss/prebuilt/common/etc/helpers.sh:system/etc/helpers.sh \
    vendor/bliss/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/bliss/prebuilt/common/etc/init.d.cfg:system/etc/init.d.cfg

# Added xbin files
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/xbin/zip:system/xbin/zip \
    vendor/bliss/prebuilt/common/xbin/zipalign:system/xbin/zipalign

# userinit support
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# Copy JNI libarary of Term
PRODUCT_COPY_FILES +=  \
    vendor/bliss/prebuilt/apps/Term.apk:system/app/Term.apk \
    vendor/bliss/prebuilt/common/lib/libjackpal-androidterm4.so:system/lib/libjackpal-androidterm4.so \
    vendor/bliss/prebuilt/viper/ViPER4Android.apk:system/app/ViPER4Android.apk \
    vendor/bliss/prebuilt/viper/libv4a_fx_ics.so:system/lib/soundfx/libv4a_fx_ics.so  
    
# SuperSu Flasher
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/bin/supersuflasher.sh:system/bin/supersuflasher.sh

# SuperSU
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/SuperSU/SuperSU.zip:system/etc/supersu.zip      

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/bliss/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/bliss/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is CM!
PRODUCT_COPY_FILES += \
    vendor/bliss/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

# T-Mobile theme engine
include vendor/bliss/config/themes_common.mk

# Required CM packages
PRODUCT_PACKAGES += \
    Development \
    BluetoothExt \
    LatinIME \
    Superuser \
    su

# Optional CM packages
PRODUCT_PACKAGES += \
    VoicePlus \
    VoiceDialer \
    SoundRecorder \
    Basic \
    libemoji

# Custom CM packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Trebuchet \
    audio_effects.conf \
    ScreenRecorder \
    libscreenrecorder \
    BlissPapers \
    BlissUpdater \
    Apollo \
    KernelTweaker \
    MonthCalendarWidget \
    OmniSwitch \
    LockClock \
    DashClock \
    CMHome \
    CMFileManager \
    CMWallpapers

PRODUCT_PACKAGES += \
    CellBroadcastReceiver

PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in CM
PRODUCT_PACKAGES += \
    libsepol \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    vim \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    procmem \
    procrank \
    sqlite3 \
    strace

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# HFM Files
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/etc/hosts.alt:system/etc/hosts.alt \
    vendor/bliss/prebuilt/etc/hosts.og:system/etc/hosts.og

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

PRODUCT_PACKAGE_OVERLAYS += vendor/bliss/overlay/dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/bliss/overlay/common

# Bliss Versioning System
-include vendor/bliss/config/versions.mk

-include vendor/cm-priv/keys/keys.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call inherit-product-if-exists, vendor/extra/product.mk)
