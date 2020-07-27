# Bluetooth Configuration
ifeq ($(strip $(MTK_BT_SUPPORT)), yes)
ifneq ($(filter MTK_MT76%, $(MTK_BT_CHIP)),)
  PRODUCT_PACKAGES += libbt-vendor
  PRODUCT_PACKAGES += libbluetooth_mtk
  PRODUCT_PACKAGES += boots_srv
  PRODUCT_PACKAGES += boots
  PRODUCT_PACKAGES += picus
  PRODUCT_PACKAGES += btmtksdio.ko
else
  PRODUCT_PACKAGES += libbt-vendor
  PRODUCT_PACKAGES += libbluetooth_mtk
  PRODUCT_PACKAGES += libbluetooth_mtk_pure
  PRODUCT_PACKAGES += libbluetoothem_mtk
  PRODUCT_PACKAGES += libbluetooth_relayer
  PRODUCT_PACKAGES += libbluetooth_hw_test
  PRODUCT_PACKAGES += autobt
  PRODUCT_PACKAGES += bt_drv.ko
endif
endif

cfg_folder := vendor/mediatek/proprietary/hardware/connectivity/bluetooth/driver/mt66xx
ifneq ($(wildcard $(MTK_PROJECT_FOLDER)/BT_FW.cfg),)
  PRODUCT_COPY_FILES += $(MTK_PROJECT_FOLDER)/BT_FW.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/BT_FW.cfg:mtk
else
  PRODUCT_COPY_FILES += $(cfg_folder)/BT_FW.cfg:$(TARGET_COPY_OUT_VENDOR)/firmware/BT_FW.cfg:mtk
endif

