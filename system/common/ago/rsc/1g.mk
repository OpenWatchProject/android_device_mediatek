# 1GB RAM RSC apks

ifeq ($(strip $(BUILD_GMS)), yes)
$(warning 1g GMS)
MTK_RSC_APKS += \
    CalendarGoogle:PRODUCT:app \
    GoogleContacts:PRODUCT:app \
    GmsSampleIntegrationGo:PRODUCT:app \
    GoogleDialerGo:PRODUCT:priv-app \
    FilesGoogle:PRODUCT:priv-app \
    DuoGo:PRODUCT:app \
    GmsDialerGoConfigOverlay:SYSTEM:overlay \
    GmsDialerGoTelecomOverlay:SYSTEM:overlay

MTK_RSC_MODULES += googledialergo-sysconfig.xml

endif
