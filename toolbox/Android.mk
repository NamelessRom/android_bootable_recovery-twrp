LOCAL_PATH := system/core/toolbox
include $(CLEAR_VARS)

OUR_TOOLS := \
    start \
    stop
    
# If busybox does not have SELinux support, provide these tools with toolbox.
# Note that RECOVERY_BUSYBOX_TOOLS will be empty if TW_USE_TOOLBOX == true.
TOOLS_FOR_SELINUX := \
    ls

OUR_TOOLS += $(filter-out $(RECOVERY_BUSYBOX_TOOLS), $(TOOLS_FOR_SELINUX))

ifeq ($(TW_USE_TOOLBOX), true)
    # These are the only toolbox tools in M. The rest are now in toybox.
    BSD_TOOLS := \
        dd \
        du

    OUR_TOOLS := \
        df \
        iftop \
        ioctl \
        ionice \
        log \
        ls \
        lsof \
        mount \
        nandread \
        newfs_msdos \
        ps \
        prlimit \
        renice \
        sendevent \
        start \
        stop \
        top \
        uptime \
        watchprops
endif

LOCAL_SRC_FILES := \
    toolbox.c \
    $(patsubst %,%.c,$(OUR_TOOLS))

ifneq ($(wildcard system/core/toolbox/dynarray.c),)
    LOCAL_SRC_FILES += dynarray.c
endif

LOCAL_CFLAGS += \
    -std=gnu99 \
    -Werror -Wno-unused-parameter \
    -I$(LOCAL_PATH)/upstream-netbsd/include \
    -include bsd-compatibility.h

LOCAL_C_INCLUDES += bionic/libc/bionic

LOCAL_SHARED_LIBRARIES += libcutils libselinux

LOCAL_SHARED_LIBRARIES += \
    libc \
    liblog

# libusbhost is only used by lsusb, and that isn't usually included in toolbox.
# The linker strips out all the unused library code in the normal case.
LOCAL_STATIC_LIBRARIES := libusbhost
LOCAL_WHOLE_STATIC_LIBRARIES := $(patsubst %,libtoolbox_%,$(BSD_TOOLS))

LOCAL_MODULE := toolbox_recovery
LOCAL_MODULE_STEM := toolbox
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/sbin
LOCAL_MODULE_TAGS := optional

# Including this will define $(intermediates) below
include $(BUILD_EXECUTABLE)

$(LOCAL_PATH)/toolbox.c: $(intermediates)/tools.h

ALL_TOOLS := $(BSD_TOOLS) $(OUR_TOOLS)

TOOLS_H := $(intermediates)/tools.h
$(TOOLS_H): PRIVATE_TOOLS := $(ALL_TOOLS)
$(TOOLS_H): PRIVATE_CUSTOM_TOOL = echo "/* file generated automatically */" > $@ ; for t in $(PRIVATE_TOOLS) ; do echo "TOOL($$t)" >> $@ ; done
$(TOOLS_H): $(LOCAL_PATH)/Android.mk
$(TOOLS_H):
	$(transform-generated-source)

# toolbox setenforce is used during init in non-symlink form, so it was
# required to be included as part of the suite above. if busybox already
# provides setenforce, we can omit the toolbox symlink
TEMP_TOOLS := $(filter-out $(RECOVERY_BUSYBOX_TOOLS), $(ALL_TOOLS))
ALL_TOOLS := $(TEMP_TOOLS)

# Make /sbin/toolbox launchers for each tool
SYMLINKS := $(addprefix $(TARGET_RECOVERY_ROOT_OUT)/sbin/,$(ALL_TOOLS))
$(SYMLINKS): TOOLBOX_BINARY := $(LOCAL_MODULE_STEM)
$(SYMLINKS): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
	@echo "Symlink: $@ -> $(TOOLBOX_BINARY)"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf $(TOOLBOX_BINARY) $@

include $(CLEAR_VARS)
LOCAL_MODULE := toolbox_symlinks
LOCAL_MODULE_TAGS := optional
LOCAL_ADDITIONAL_DEPENDENCIES := $(SYMLINKS)
include $(BUILD_PHONY_PACKAGE)

SYMLINKS :=
ALL_TOOLS :=
BSD_TOOLS :=
OUR_TOOLS :=
TEMP_TOOLS :=
TOOLS_FOR_SELINUX :=
