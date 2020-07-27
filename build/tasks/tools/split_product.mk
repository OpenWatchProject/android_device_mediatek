

name := $(TARGET_PRODUCT)-product_target_files-$(FILE_NAME_TAG)
intermediates := $(call intermediates-dir-for,PACKAGING,product_target_files)
$(MTK_SPLIT_IMAGES_DIR)/prd.target_files.zip: intermediates := $(intermediates)
$(MTK_SPLIT_IMAGES_DIR)/prd.target_files.zip: zip_root := $(intermediates)/$(name)
$(MTK_SPLIT_IMAGES_DIR)/prd.target_files.zip: \
	    vendor/mediatek/proprietary/scripts/releasetools/pre_process_misc_info.py \
	    $(wildcard vendor/mediatek/proprietary/scripts/releasetools/system_misc_info_keys.txt)
$(MTK_SPLIT_IMAGES_DIR)/prd.target_files.zip: \
	    $(INSTALLED_FILES_FILE_PRODUCT)
$(MTK_SPLIT_IMAGES_DIR)/prd.target_files.zip: \
	    $(INTERNAL_PRODUCTIMAGE_FILES) \
	    $(INTERNAL_PRODUCT_SERVICESIMAGE_FILES) \
	    $(PRODUCT_PRODUCT_BASE_FS_PATH) \
	    $(PRODUCT_PRODUCT_SERVICES_BASE_FS_PATH) \
	    $(SELINUX_FC) \
	    $(SOONG_ZIP) \
	    $(HOST_OUT_EXECUTABLES)/fs_config \
	    $(HOST_OUT_EXECUTABLES)/imgdiff \
	    $(HOST_OUT_EXECUTABLES)/bsdiff \
	    $(HOST_OUT_EXECUTABLES)/care_map_generator \
	    $(BUILD_IMAGE_SRCS) \
	    $(wildcard vendor/mediatek/proprietary/scripts/releasetools/*.py) \
	    $(BUILT_PRODUCT_MANIFEST) \
	    | $(ACP)
	@echo "Package target files: $@"
	$(hide) mkdir -p $(TARGET_OUT)
	$(call create-system-product-symlink)
	$(call create-system-product_services-symlink)
	$(hide) rm -rf $@ $(zip_root).list $(zip_root)
	$(hide) mkdir -p $(dir $@) $(zip_root)
ifdef BUILDING_PRODUCT_IMAGE
	@# Contents of the product image
	$(hide) $(call package_files-copy-root, \
	    $(TARGET_OUT_PRODUCT),$(zip_root)/PRODUCT)
endif
ifdef BUILDING_PRODUCT_SERVICES_IMAGE
	@# Contents of the product_services image
	$(hide) $(call package_files-copy-root, \
	    $(TARGET_OUT_PRODUCT_SERVICES),$(zip_root)/PRODUCT_SERVICES)
endif
	$(hide) mkdir -p $(zip_root)/META
ifneq ($(PRODUCT_PRODUCT_BASE_FS_PATH),)
	$(hide) cp $(PRODUCT_PRODUCT_BASE_FS_PATH) \
	  $(zip_root)/META/$(notdir $(PRODUCT_PRODUCT_BASE_FS_PATH))
endif
ifneq ($(PRODUCT_PRODUCT_SERVICES_BASE_FS_PATH),)
	$(hide) cp $(PRODUCT_PRODUCT_SERVICES_BASE_FS_PATH) \
	  $(zip_root)/META/$(notdir $(PRODUCT_PRODUCT_SERVICES_BASE_FS_PATH))
endif
	@# Run fs_config on all the system, vendor, boot ramdisk,
	@# and recovery ramdisk files in the zip, and save the output
ifdef BUILDING_PRODUCT_IMAGE
	$(hide) $(call fs_config,$(zip_root)/PRODUCT,product/) > $(zip_root)/META/product_filesystem_config.txt
endif
ifdef BUILDING_PRODUCT_SERVICES_IMAGE
	$(hide) $(call fs_config,$(zip_root)/PRODUCT_SERVICES,product_services/) > $(zip_root)/META/product_services_filesystem_config.txt
endif
# MTK
	$(hide) mkdir -p $(zip_root)/META_TEMP
ifdef BUILT_PRODUCT_MANIFEST
	$(hide) cp $(BUILT_PRODUCT_MANIFEST) $(zip_root)/META_TEMP/built_product_manifest.xml
endif
ifdef INSTALLED_FILES_FILE_PRODUCT
	$(hide) cp $(INSTALLED_FILES_FILE_PRODUCT) $(zip_root)/META_TEMP/
endif
# MTK
	@# Zip everything up, preserving symlinks and placing META/ files first to
	@# help early validation of the .zip file while uploading it.
	$(hide) find $(zip_root)/META | sort >$(zip_root).list
	$(hide) find $(zip_root) -path $(zip_root)/META -prune -o -print | sort | sed -e 's/\[/\\\[/g' -e 's/\]/\\\]/g' >>$(zip_root).list
	$(hide) $(SOONG_ZIP) -d -o $@ -C $(zip_root) -l $(zip_root).list


.PHONY: prd_images
prd_images: $(MTK_SPLIT_IMAGES_DIR)/prd.target_files.zip
	@echo $@: $^

