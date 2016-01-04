LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_CFLAGS := -fno-strict-aliasing

LOCAL_SRC_FILES := \
    action.cpp \
    animation.cpp \
    blanktimer.cpp \
    button.cpp \
    checkbox.cpp \
    console.cpp \
    fileselector.cpp \
    fill.cpp \
    gui.cpp \
    image.cpp \
    input.cpp \
    keyboard.cpp \
    listbox.cpp \
    mousecursor.cpp \
    object.cpp \
    pages.cpp \
    partitionlist.cpp \
    patternpassword.cpp \
    progressbar.cpp \
    rapidxml.cpp \
    resources.cpp \
    scrolllist.cpp \
    slider.cpp \
    slidervalue.cpp \
    text.cpp \
    textbox.cpp \
    twmsg.cpp

ifneq ($(TWRP_CUSTOM_KEYBOARD),)
    LOCAL_SRC_FILES += $(TWRP_CUSTOM_KEYBOARD)
else
    LOCAL_SRC_FILES += hardwarekeyboard.cpp
endif

LOCAL_SHARED_LIBRARIES += \
    libaosprecovery \
    libc \
    libminuitwrp \
    libminzip \
    libstdc++

LOCAL_MODULE := libguitwrp

#TWRP_EVENT_LOGGING := true
ifeq ($(TWRP_EVENT_LOGGING), true)
    LOCAL_CFLAGS += -D_EVENT_LOGGING
endif
ifneq ($(TW_USE_KEY_CODE_TOUCH_SYNC),)
    LOCAL_CFLAGS += -DTW_USE_KEY_CODE_TOUCH_SYNC=$(TW_USE_KEY_CODE_TOUCH_SYNC)
endif

ifneq ($(TW_NO_SCREEN_BLANK),)
    LOCAL_CFLAGS += -DTW_NO_SCREEN_BLANK
endif
ifneq ($(TW_NO_SCREEN_TIMEOUT),)
    LOCAL_CFLAGS += -DTW_NO_SCREEN_TIMEOUT
endif
LOCAL_CFLAGS += -DHAVE_SELINUX
ifeq ($(TW_OEM_BUILD), true)
    LOCAL_CFLAGS += -DTW_OEM_BUILD
endif
ifneq ($(TW_X_OFFSET),)
    LOCAL_CFLAGS += -DTW_X_OFFSET=$(TW_X_OFFSET)
endif
ifneq ($(TW_Y_OFFSET),)
    LOCAL_CFLAGS += -DTW_Y_OFFSET=$(TW_Y_OFFSET)
endif
ifeq ($(TW_ROUND_SCREEN), true)
    LOCAL_CFLAGS += -DTW_ROUND_SCREEN
endif
ifneq ($(TW_REDUCED_GRAPHICS), true)
    LOCAL_CFLAGS += -DINCLUDE_JPEG_GRAPHICS
endif

LOCAL_C_INCLUDES += \
    system/core/include \
    system/core/libpixelflinger/include

LOCAL_CFLAGS += -DTWRES=\"$(TWRES_PATH)\"

include $(BUILD_STATIC_LIBRARY)

# Transfer in the resources for the device
include $(CLEAR_VARS)
LOCAL_MODULE := twrp
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)$(TWRES_PATH)
TWRP_RES := $(commands_recovery_local_path)/gui/devices/common/res/*
TWRP_NEW_THEME := true

ifeq ($(TW_CUSTOM_THEME),)
    ifeq ($(TW_THEME),)
        ifeq ($(TARGET_SCREEN_WIDTH),)
            $(error ERROR: TARGET_SCREEN_WIDTH must be defined in your device board files)
        else ifeq ($(TARGET_SCREEN_HEIGHT),)
            $(error ERROR: TARGET_SCREEN_HEIGHT must be defined in your device board files)
        endif
        ifeq ($(shell test $(TARGET_SCREEN_WIDTH) -gt $(TARGET_SCREEN_HEIGHT); echo $$?),0)
            ifeq ($(shell test $(TARGET_SCREEN_WIDTH) -ge 1280; echo $$?),0)
                TW_THEME := landscape_hdpi
            else
                TW_THEME := landscape_mdpi
            endif
        else ifeq ($(shell test $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT); echo $$?),0)
            ifeq ($(shell test $(TARGET_SCREEN_WIDTH) -ge 720; echo $$?),0)
                TW_THEME := portrait_hdpi
            else
                TW_THEME := portrait_mdpi
            endif
        else ifeq ($(shell test $(TARGET_SCREEN_WIDTH) -eq $(TARGET_SCREEN_HEIGHT); echo $$?),0)
            # watch_hdpi does not yet exist
            TW_THEME := watch_mdpi
        endif
    endif
    ifeq ($(TWRP_NEW_THEME),true)
        TWRP_THEME_LOC := $(commands_recovery_local_path)/gui/theme/$(TW_THEME)
        TWRP_RES := $(commands_recovery_local_path)/gui/theme/common/fonts
        TWRP_RES += $(commands_recovery_local_path)/gui/theme/common/languages
        TWRP_RES += $(commands_recovery_local_path)/gui/theme/common/$(word 1,$(subst _, ,$(TW_THEME))).xml
        TWRP_CURTAIN_LOC := $(commands_recovery_local_path)/gui/theme/alt-images/curtain/$(TW_THEME)
        # for future copying of used include xmls and fonts:
        # UI_XML := $(TWRP_THEME_LOC)/ui.xml
        # TWRP_INCLUDE_XMLS := $(shell xmllint --xpath '/recovery/include/xmlfile/@name' $(UI_XML)|sed -n 's/[^\"]*\"\([^\"]*\)\"[^\"]*/\1\n/gp'|sort|uniq)
        # TWRP_FONTS_TTF := $(shell xmllint --xpath '/recovery/resources/font/@filename' $(UI_XML)|sed -n 's/[^\"]*\"\([^\"]*\)\"[^\"]*/\1\n/gp'|sort|uniq)niq)
        ifeq ($(wildcard $(TWRP_THEME_LOC)/ui.xml),)
            $(error ERROR: TW_THEME '$(TW_THEME)' is not one of $(sort $(notdir $(wildcard $(commands_recovery_local_path)/gui/theme/*_*))))
        endif
    else
        TWRP_RES += $(commands_recovery_local_path)/gui/devices/$(word 1,$(subst _, ,$(TW_THEME)))/res/*
        ifeq ($(TW_THEME), portrait_mdpi)
            TWRP_THEME_LOC := $(commands_recovery_local_path)/gui/devices/480x800/res
            TWRP_CURTAIN_LOC := $(commands_recovery_local_path)/gui/devices/alt-images/curtain/480x800
        else ifeq ($(TW_THEME), portrait_hdpi)
            TWRP_THEME_LOC := $(commands_recovery_local_path)/gui/devices/1080x1920/res
            TWRP_CURTAIN_LOC := $(commands_recovery_local_path)/gui/devices/alt-images/curtain/1080x1920
        else ifeq ($(TW_THEME), watch_mdpi)
            TWRP_THEME_LOC := $(commands_recovery_local_path)/gui/devices/320x320/res
            TWRP_CURTAIN_LOC := $(commands_recovery_local_path)/gui/devices/alt-images/curtain/320x320
        else ifeq ($(TW_THEME), landscape_mdpi)
            TWRP_THEME_LOC := $(commands_recovery_local_path)/gui/devices/800x480/res
            TWRP_CURTAIN_LOC := $(commands_recovery_local_path)/gui/devices/alt-images/curtain/800x480
        else ifeq ($(TW_THEME), landscape_hdpi)
            TWRP_THEME_LOC := $(commands_recovery_local_path)/gui/devices/1920x1200/res
            TWRP_CURTAIN_LOC := $(commands_recovery_local_path)/gui/devices/alt-images/curtain/1920x1200
        else
            $(error ERROR: TW_THEME '$(TW_THEME)' is not one of landscape_hdpi landscape_mdpi portrait_hdpi portrait_mdpi watch_mdpi)
        endif
    endif
else
    TWRP_THEME_LOC := $(TW_CUSTOM_THEME)
endif
ifeq ($(TW_REDUCED_GRAPHICS), true)
    TWRP_CURTAIN_IMAGE := $(TWRP_CURTAIN_LOC)/curtain.png
else
    TWRP_CURTAIN_IMAGE := $(TWRP_CURTAIN_LOC)/curtain.jpg
endif

TWRP_RES_GEN := $(intermediates)/twrp
$(TWRP_RES_GEN):
	mkdir -p $(TARGET_RECOVERY_ROOT_OUT)$(TWRES_PATH)
	cp -fr $(TWRP_RES) $(TARGET_RECOVERY_ROOT_OUT)$(TWRES_PATH)
	cp -fr $(TWRP_THEME_LOC)/* $(TARGET_RECOVERY_ROOT_OUT)$(TWRES_PATH)
	cp -f $(TWRP_CURTAIN_IMAGE) $(TARGET_RECOVERY_ROOT_OUT)$(TWRES_PATH)images
	mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/sbin/
	ln -sf pigz $(TARGET_RECOVERY_ROOT_OUT)/sbin/gzip
	ln -sf pigz $(TARGET_RECOVERY_ROOT_OUT)/sbin/gunzip
	ln -sf pigz $(TARGET_RECOVERY_ROOT_OUT)/sbin/unpigz

LOCAL_GENERATED_SOURCES := $(TWRP_RES_GEN)
LOCAL_SRC_FILES := twrp $(TWRP_RES_GEN)
include $(BUILD_PREBUILT)
