# mt6582 platform boardconfig

# Use the common part
include device/mediatek/vendor/common/BoardConfig.mk

# Use the non-open-source part, if present
-include vendor/mediatek/mt6580/BoardConfigVendor.mk

TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a7
TARGET_CPU_SMP := true
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
ARCH_ARM_HAVE_TLS_REGISTER := true
TARGET_BOARD_PLATFORM := mt6580
TARGET_NO_FACTORYIMAGE:=true

ifeq ($(MTK_EMMC_SUPPORT), yes)
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_FLASH_BLOCK_SIZE := 4096
else
TARGET_USERIMAGES_USE_EXT4 := false
TARGET_USERIMAGES_USE_UBIFS := true

PRODUCT_PACKAGES += mkfs_ubifs
PRODUCT_PACKAGES += ubinize

MKUBIFS = $(HOST_OUT_EXECUTABLES)/mkfs_ubifs$(HOST_EXECUTABLE_SUFFIX)
UBINIZE = $(HOST_OUT_EXECUTABLES)/ubinize$(HOST_EXECUTABLE_SUFFIX)
endif


ifeq ($(MTK_K64_SUPPORT), yes)
KERNEL_TARGET_ARCH:= arm64
KERNEL_TARGET_STRIP:= $(KERNEL_CROSS_COMPILE)strip
else
KERNEL_TARGET_ARCH:= arm
KERNEL_TARGET_STRIP:= $(KERNEL_CROSS_COMPILE)strip
endif

# disable system as root by platform
# will move it to common/device.mk after all platform ready
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# adjust partition size for low ram device
BOARD_MTK_GMO_SYSTEM_SIZE_KB := 1458176
BOARD_MTK_GMO_VENDOR_SIZE_KB := 294912
BOARD_MTK_GMO_CACHE_SIZE_KB := 114688

# display related
ifneq (,$(filter $(strip $(MTK_LCM_PHYSICAL_ROTATION)), 90 270))
    SF_PRIMARY_DISPLAY_ORIENTATION := $(MTK_LCM_PHYSICAL_ROTATION)
endif

TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := false
ifeq ($(FPGA_EARLY_PORTING), no)
MTK_HWC_SUPPORT := yes
else
MTK_HWC_SUPPORT := no
endif

TARGET_USES_HWC2 := true
TARGET_USES_HWC2ON1ADAPTER := false
MTK_HWC_VERSION := 2.0.0
MTK_SF_USE_PROCESSCALLSTACK := true
MTK_GPU_VERSION := mali utgard r10p0-00rel0

BOARD_CONNECTIVITY_VENDOR := MediaTek
BOARD_USES_MTK_AUDIO := true

ifeq ($(strip $(BOARD_CONNECTIVITY_VENDOR)), MediaTek)
BOARD_MEDIATEK_USES_GPS := true
endif

# mkbootimg header, which is used in LK
BOARD_KERNEL_BASE = 0x80000000
BOARD_KERNEL_OFFSET = 0x00008000
BOARD_RAMDISK_OFFSET = 0x04000000
BOARD_TAGS_OFFSET = 0xE000000
TARGET_USES_64_BIT_BINDER := true
ifneq ($(MTK_K64_SUPPORT), yes)
BOARD_KERNEL_CMDLINE = bootopt=64S3,32S1,32S1
else
TARGET_IS_64_BIT := true
BOARD_KERNEL_CMDLINE = bootopt=64S3,32N2,64N2
endif
BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version 2
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_TAGS_OFFSET)
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(MTK_PTGEN_PRODUCT_OUT)/obj/PACKAGING/dtb

ifeq ($(strip $(MTK_DTBO_FEATURE)),yes)
ifeq ($(strip $(MTK_DTBO_UPGRADE_FROM_ANDROID_O)), yes)
BOARD_PREBUILT_DTBOIMAGE := $(MTK_PTGEN_PRODUCT_OUT)/obj/PACKAGING/dtboimage/odmdtbo.img
else
BOARD_PREBUILT_DTBOIMAGE := $(MTK_PTGEN_PRODUCT_OUT)/obj/PACKAGING/dtboimage/dtbo.img
endif
ifneq ($(strip $(MTK_AB_OTA_UPDATER)),yes)
BOARD_INCLUDE_RECOVERY_DTBO := true
endif
endif

#SELinux Policy File Configuration
ifeq ($(strip $(MTK_BASIC_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        device/mediatek/mt6580/sepolicy/basic
endif
ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        device/mediatek/mt6580/sepolicy/basic \
        device/mediatek/mt6580/sepolicy/bsp
endif
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        device/mediatek/mt6580/sepolicy/basic \
        device/mediatek/mt6580/sepolicy/bsp \
        device/mediatek/mt6580/sepolicy/full
endif
endif

#Enable cpusets
ENABLE_CPUSETS := true
# Create vendor partition
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_RECOVERY_FSTAB := $(MTK_PTGEN_PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/fstab.$(MTK_PLATFORM_DIR)

# Enable product partition
TARGET_COPY_OUT_PRODUCT := product
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4

# add product to vbmeta_system partitions
ifeq ($(PRODUCT_USE_DYNAMIC_PARTITIONS), true)
BOARD_AVB_VBMETA_SYSTEM := system product
endif

# ODM image
ifneq ($(filter $(MAKECMDGOALS),custom_images),)
ifeq (yes,$(strip $(TARGET_COPY_OUT_ODM)))
PRODUCT_CUSTOM_IMAGE_MAKEFILES += device/mediatek/mt6580/odm/odm.mk
endif
endif

-include device/mediatek/build/core/target_brm_platform.mk

BOARD_SIGN_IMG = yes

ifneq ($(wildcard vendor/mediatek/internal/sboot_disable),)
BOARD_BUILD_SBOOT_DIS_PL:=yes
else
BOARD_BUILD_SBOOT_DIS_PL:=no
endif

ifneq ($(call math_gt_or_eq,$(PRODUCT_SHIPPING_API_LEVEL),29),)
BOARD_ROOT_EXTRA_FOLDERS += metadata
BOARD_USES_METADATA_PARTITION := true
endif
