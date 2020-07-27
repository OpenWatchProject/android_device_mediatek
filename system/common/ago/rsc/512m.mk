# 512MB RAM RSC apks

ifeq ($(strip $(BUILD_GMS)), yes)
$(warning 512m GMS)
MTK_RSC_APKS += \
    MtkCalendar:PRODUCT:app \
    GmsSampleIntegrationGo512M:PRODUCT:app \
    MtkContacts:PRODUCT:priv-app \
    MtkDialer:PRODUCT:priv-app \
    GoogleCalendarSyncAdapter:PRODUCT:app

MTK_RSC_MODULES += privapp_whitelist_com.android.dialer
MTK_RSC_MODULES += privapp_whitelist_com.android.contacts

endif
