LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    dynarray.c \
    getprop.c \
    setprop.c \
    toolbox.c

LOCAL_CFLAGS += \
    -std=gnu99 \
    -Werror \
    -Wno-unused-parameter

LOCAL_SHARED_LIBRARIES += libcutils

LOCAL_C_INCLUDES += system/core/include

LOCAL_MODULE := micro.toolbox
LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/sbin
LOCAL_MODULE_TAGS := optional

include $(BUILD_EXECUTABLE)

$(LOCAL_PATH)/toolbox.c: $(intermediates)/tools.h

TOOLS_H := $(intermediates)/tools.h
$(TOOLS_H): PRIVATE_TOOLS := $(shell cat $(LOCAL_PATH)/micro.toolbox-links)
$(TOOLS_H): PRIVATE_CUSTOM_TOOL = echo "/* file generated automatically */" > $@ ; for t in $(PRIVATE_TOOLS) ; do echo "TOOL($$t)" >> $@ ; done
$(TOOLS_H): $(LOCAL_PATH)/Android.mk
$(TOOLS_H):
	$(transform-generated-source)
