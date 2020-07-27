# mt6739 platform boardconfig

# Use the common part
include device/mediatek/vendor/common/BoardConfig.mk

# Use the non-open-source part, if present
-include vendor/mediatek/mt6739/BoardConfigVendor.mk

#Force setting vendor parition for MT6739
BOARD_MTK_VENDOR_SIZE_KB := 563200

ifneq ($(TARGET_SUPPORTS_64_BIT_APPS), true)
TARGET_ARCH := arm

TARGET_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_ARCH_VARIANT := armv8-a

else
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=

TARGET_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

TARGET_IS_64_BIT := true

endif

ifeq ($(MTK_K64_SUPPORT), yes)
KERNEL_TARGET_ARCH:= arm64
KERNEL_TARGET_STRIP:= $(KERNEL_CROSS_COMPILE)strip
else
KERNEL_TARGET_ARCH:= arm
KERNEL_TARGET_STRIP:= $(KERNEL_CROSS_COMPILE)strip
endif

# adjust partition size for low ram device
BOARD_MTK_GMO_SYSTEM_SIZE_KB := 1250976
BOARD_MTK_GMO_CACHE_SIZE_KB := 114688
BOARD_MTK_GMO_VENDOR_SIZE_KB := 307200
BOARD_MTK_GMO_SUPER_SIZE_KB := 1536000

ARCH_ARM_HAVE_TLS_REGISTER := true
TARGET_BOARD_PLATFORM ?= mt6739
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_NO_FACTORYIMAGE := true

# MTK, Nick Ko, 20140305, Add Display {
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := false

# Basic package can not set VSYNC_EVENT_PHASE_OFFSET_NS
# If VSYNC_EVENT_PHASE_OFFSET_NS is not 0, it will cause compiler error of SF
ifneq ($(MTK_BASIC_PACKAGE), yes)
ifneq ($(MTK_DISPLAY_120HZ_SUPPORT), yes)
VSYNC_EVENT_PHASE_OFFSET_NS := 8300000
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 8300000
PRESENT_TIME_OFFSET_FROM_VSYNC_NS := 0
else
VSYNC_EVENT_PHASE_OFFSET_NS := 0
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 0
PRESENT_TIME_OFFSET_FROM_VSYNC_NS := 0
endif
else
VSYNC_EVENT_PHASE_OFFSET_NS := 0
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 0
PRESENT_TIME_OFFSET_FROM_VSYNC_NS := 0
endif

ifneq (,$(filter $(strip $(MTK_LCM_PHYSICAL_ROTATION)), 90 270))
    SF_PRIMARY_DISPLAY_ORIENTATION := $(MTK_LCM_PHYSICAL_ROTATION)
endif

PRESENT_TIME_OFFSET_FROM_VSYNC_NS := 0
ifneq ($(FPGA_EARLY_PORTING), yes)
MTK_HWC_SUPPORT := yes
TARGET_USES_HWC2 := true
else
MTK_HWC_SUPPORT := no
TARGET_USES_HWC2 := false
endif

# MTK, Nick Ko, 20140305, Add Display }
MTK_HWC_VERSION := 2.0.0

BOARD_CONNECTIVITY_VENDOR := MediaTek
BOARD_USES_MTK_AUDIO := true

ifeq ($(strip $(BOARD_CONNECTIVITY_VENDOR)), MediaTek)
BOARD_MEDIATEK_USES_GPS := true
endif

# mkbootimg header, which is used in LK
BOARD_KERNEL_BASE = 0x40000000
ifneq ($(MTK_K64_SUPPORT), yes)
BOARD_KERNEL_OFFSET = 0x00008000
else
BOARD_KERNEL_OFFSET = 0x00080000
endif
BOARD_RAMDISK_OFFSET = 0x05000000
BOARD_TAGS_OFFSET = 0x4000000
TARGET_USES_64_BIT_BINDER := true
ifneq ($(MTK_K64_SUPPORT), yes)
BOARD_KERNEL_CMDLINE = bootopt=64S3,32S1,32S1
else
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
        device/mediatek/mt6739/sepolicy/basic
endif
ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        device/mediatek/mt6739/sepolicy/basic \
        device/mediatek/mt6739/sepolicy/bsp
endif
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        device/mediatek/mt6739/sepolicy/basic \
        device/mediatek/mt6739/sepolicy/bsp \
        device/mediatek/mt6739/sepolicy/full
endif
endif

MTK_GPU_VERSION := rgx auckland 1.8ED
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


#Enable cpusets
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# ODM image
ifneq ($(filter $(MAKECMDGOALS),custom_images),)
ifeq (yes,$(strip $(TARGET_COPY_OUT_ODM)))
PRODUCT_CUSTOM_IMAGE_MAKEFILES += device/mediatek/mt6739/odm/odm.mk
endif
endif

-include device/mediatek/build/core/target_brm_platform.mk

BOARD_SIGN_IMG = yes

ifneq ($(wildcard vendor/mediatek/internal/sboot_disable),)
BOARD_BUILD_SBOOT_DIS_PL:=yes
else
BOARD_BUILD_SBOOT_DIS_PL:=no
endif

TARGET_KERNEL_USE_CLANG := true

ifneq ($(call math_gt_or_eq,$(PRODUCT_SHIPPING_API_LEVEL),29),)
BOARD_ROOT_EXTRA_FOLDERS += metadata
BOARD_USES_METADATA_PARTITION := true
endif
