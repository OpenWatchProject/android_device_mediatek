ifdef MTK_DTBIMAGE_DTS

ifneq (true,$(strip $(TARGET_NO_KERNEL)))
ifneq ($(LINUX_KERNEL_VERSION),)

ifeq (,$(KERNEL_OUT))
include $(LINUX_KERNEL_VERSION)/kenv.mk
endif

MTK_DTBIMAGE_DTB :=
$(foreach i,$(MTK_DTBIMAGE_DTS),\
  $(eval LOCAL_SRC_FILES := $(i))\
  $(eval include device/mediatek/build/core/build_dtb.mk)\
  $(eval MTK_DTBIMAGE_DTB += $(my_kernel_dtb))\
)

my_dtb_id := 0
define mk_dtbimg_cfg
echo $(1) >>$(2);\
echo " id=$(my_dtb_id)" >>$(2);\
$(eval my_dtb_id := (call int_plus,$(my_dtb_id),1))
endef

ifdef BOARD_PREBUILT_DTBIMAGE_DIR
BOARD_PREBUILT_DTBIMAGE := $(BOARD_PREBUILT_DTBIMAGE_DIR)/mtk.dtb
$(shell if [ ! -f $(BOARD_PREBUILT_DTBIMAGE) ]; then mkdir -p $(dir $(BOARD_PREBUILT_DTBIMAGE)); touch $(BOARD_PREBUILT_DTBIMAGE); fi)

INSTALLED_MTK_DTB_TARGET := $(BOARD_PREBUILT_DTBIMAGE_DIR)/mtk_dtb
$(INSTALLED_MTK_DTB_TARGET): $(MTK_DTBIMAGE_DTB)
	$(hide) mkdir -p $(dir $@)
	$(hide) cat $^ > $@

MTK_DTBIMAGE_CFG := $(KERNEL_OUT)/arch/$(KERNEL_TARGET_ARCH)/boot/dts/dtbimg.cfg
$(MTK_DTBIMAGE_CFG): PRIVATE_DTB := $(INSTALLED_MTK_DTB_TARGET)
$(MTK_DTBIMAGE_CFG): $(INSTALLED_MTK_DTB_TARGET)
	$(hide) rm -f $@.tmp
	$(hide) $(foreach f,$(PRIVATE_DTB),$(call mk_dtbimg_cfg,$(f),$@.tmp))
	if ! cmp -s $@.tmp $@; then \
		mv $@.tmp $@; \
	else \
		rm $@.tmp; \
	fi

endif#BOARD_PREBUILT_DTBIMAGE_DIR

endif#TARGET_NO_KERNEL
endif#LINUX_KERNEL_VERSION

endif#MTK_DTBIMAGE_DTS
