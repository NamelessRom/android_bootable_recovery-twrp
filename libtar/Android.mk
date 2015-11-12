LOCAL_PATH := $(call my-dir)

common_src_files := \
    append.c \
    basename.c \
    block.c \
    decode.c \
    dirname.c \
    encode.c \
    extract.c \
    handle.c \
    libtar_hash.c \
    libtar_list.c \
    output.c \
    strmode.c \
    util.c \
    wrapper.c

include $(CLEAR_VARS)

LOCAL_MODULE := libtar
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := -DHAVE_SELINUX
LOCAL_SRC_FILES := $(common_src_files)
LOCAL_C_INCLUDES += $(LOCAL_PATH) \
                    external/libselinux/include \
                    external/zlib
LOCAL_SHARED_LIBRARIES += libc libselinux libz
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := libtar_static
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := -DHAVE_SELINUX
LOCAL_SRC_FILES := $(common_src_files)
LOCAL_C_INCLUDES += $(LOCAL_PATH) \
                    external/libselinux/include \
                    external/zlib
LOCAL_STATIC_LIBRARIES += libc libselinux libz
include $(BUILD_STATIC_LIBRARY)

common_src_files :=
