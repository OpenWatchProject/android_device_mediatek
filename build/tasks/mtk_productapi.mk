# ProductApi check

MTK_PRODUCT_API_CHECK_TOOL := device/mediatek/build/mcs/ProductApiChecker.jar
MTK_PRODUCT_CURRENT_TXT := vendor/mediatek/proprietary/frameworks/base/api/product-current.txt
MTK_PRODUCT_CURRENT_TXT2 := frameworks/base/api/product-current.txt
MTK_BASIC_API_TXT := device/mediatek/build/mcs/Q0.basic_hiddenapi-stub-flags.txt
MTK_BSP_API_TXT := $(OUT_DIR)/soong/hiddenapi/hiddenapi-stub-flags.txt
MTK_APK_API_LIST_DIR := $(PRODUCT_OUT)/mtk_product_api_check
MTK_APK_API_MLIST := $(MTK_APK_API_LIST_DIR)/mtkModifyApi.txt
MTK_CURRENT_API_LIST1 := $(MTK_APK_API_LIST_DIR)/mtkProductApi1.txt
MTK_CURRENT_API_LIST2 := $(MTK_APK_API_LIST_DIR)/mtkProductApi2.txt
MTK_API_CHECK_CMD := java -jar $(MTK_PRODUCT_API_CHECK_TOOL) \
			-mtkModifyApi=$(MTK_APK_API_MLIST)
MTK_API_DIFF_CMD := python device/mediatek/build/tasks/mtk_productapi.py

.PHONY: mtk-check-product-api
mtk-check-product-api:

$(MTK_APK_API_MLIST): $(MTK_BSP_API_TXT)
	@echo 'Product API: generating MTK modified api list...'
	@mkdir -p $(dir $@)
	$(MTK_API_CHECK_CMD) -basic=$(MTK_BASIC_API_TXT) -bsp=$(MTK_BSP_API_TXT)

$(MTK_CURRENT_API_LIST1): $(MTK_APK_API_MLIST) $(MTK_PRODUCT_CURRENT_TXT)
	@echo 'Product API: generating MTK product api list1...'
	@mkdir -p $(dir $@)
	$(MTK_API_CHECK_CMD) -current=$(MTK_PRODUCT_CURRENT_TXT) -signature=$@

$(MTK_CURRENT_API_LIST2): $(MTK_APK_API_MLIST) $(MTK_PRODUCT_CURRENT_TXT2)
	@echo 'Product API: generating MTK product api list2...'
	@mkdir -p $(dir $@)
	$(MTK_API_CHECK_CMD) -current=$(MTK_PRODUCT_CURRENT_TXT2) -signature=$@

ifeq (true, $(strip $(MTK_PRODUCT_API_CHECK)))
droidcore sys_images: mtk-check-product-api
endif

define mtk-product-api-check
mtk-check-product-api: $(MTK_APK_API_LIST_DIR)/$(2)/$(basename $(notdir $(1))).txt
$(MTK_APK_API_LIST_DIR)/$(2)/$(basename $(notdir $(1))).txt: $(1) $(MTK_APK_API_MLIST) $(MTK_CURRENT_API_LIST1) $(MTK_CURRENT_API_LIST2)
	@echo 'Product API: checking APK product api...'
	@rm -rf $$(dir $$@)
	@mkdir -p $$(dir $$@)
	$(MTK_API_CHECK_CMD) -apk=$(1) -out=$$(dir $$@)
	$(MTK_API_DIFF_CMD) -u $(MTK_APK_API_LIST_DIR)/$(2)/$(basename $(notdir $(1)))_usedMtkModifyApi.txt -c1 $(MTK_CURRENT_API_LIST1) -c2 $(MTK_CURRENT_API_LIST2) -m $(1)
endef

mtk_check_product_module := $(filter $(TARGET_OUT_PRODUCT)/%.apk, $(ALL_DEFAULT_INSTALLED_MODULES))
$(foreach m, $(ALL_MODULES), \
  $(eval v := $(filter $(mtk_check_product_module), $(ALL_MODULES.$(m).INSTALLED))) \
  $(if $(v), \
    $(eval $(call mtk-product-api-check,$(v),$(ALL_MODULES.$(m).MODULE_NAME)))))
