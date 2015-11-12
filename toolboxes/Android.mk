#
# Copyright (C) 2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Hierarchy:
# 1) toybox
# 2) busybox (if !TW_USE_TOOLBOX)
# 3) toolbox

#####################
##      toybox     ##
#####################

LOCAL_PATH := external/toybox

include $(CLEAR_VARS)

LOCAL_MODULE := toybox_recovery
LOCAL_MODULE_STEM := toybox
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/sbin
LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := main.c
LOCAL_WHOLE_STATIC_LIBRARIES := libtoybox
LOCAL_SHARED_LIBRARIES := libcutils libselinux

LOCAL_CFLAGS := \
    -std=c99 \
    -Os \
    -Wno-char-subscripts \
    -Wno-sign-compare \
    -Wno-string-plus-int \
    -Wno-uninitialized \
    -Wno-unused-parameter \
    -funsigned-char \
    -ffunction-sections \
    -fdata-sections \
    -fno-asynchronous-unwind-tables

LOCAL_CXX_STL := none
LOCAL_CLANG := true

LOCAL_ADDITIONAL_DEPENDENCY := toybox-instlist
TOYBOX_INSTLIST := $(HOST_OUT_EXECUTABLES)/toybox-instlist

include $(BUILD_EXECUTABLE)

#####################
##     busybox     ##
#####################

ifneq ($(TW_USE_TOOLBOX),true)

BUSYBOX_LINKS := $(shell cat external/busybox/busybox-full.links)

# Exclusions:
#  fstools provides tune2fs and mke2fs
#  pigz provides gzip gunzip
#  dosfstools provides equivalents of mkdosfs mkfs.vfat
BUSYBOX_EXCLUDE := tune2fs mke2fs mkdosfs mkfs.vfat gzip gunzip

BUSYBOX_TOOLS := $(filter-out $(BUSYBOX_EXCLUDE), $(notdir $(BUSYBOX_LINKS)))

else

BUSYBOX_TOOLS :=

endif

#####################
##     toolbox     ##
#####################

BSD_TOOLS := \
    dd \
    du

TOOLBOX_TOOLS := \
    df \
    getevent \
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
    restart \
    sendevent \
    start \
    stop \
    top \
    uptime \
    watchprops

##############################
##     utility symlinks     ##
##############################

include $(CLEAR_VARS)

utility_symlinks: $(TOYBOX_INSTLIST)
utility_symlinks: TOYBOX_TOOLS=$(shell $(TOYBOX_INSTLIST))
utility_symlinks: BUSYBOX_TOOLS_INSTALLED=$(filter-out $(TOYBOX_TOOLS), $(BUSYBOX_TOOLS))
utility_symlinks: TOOLBOX_TOOLS_INSTALLED=$(filter-out $(TOYBOX_TOOLS) $(BUSYBOX_TOOLS_INSTALLED), $(BSD_TOOLS) $(TOOLBOX_TOOLS))
utility_symlinks:
	@mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/sbin
	@echo -e ${CL_CYN}"Generate toybox links:"${CL_RST} $(TOYBOX_TOOLS)
	$(hide) $(foreach t,$(TOYBOX_TOOLS),ln -sf toybox $(TARGET_RECOVERY_ROOT_OUT)/sbin/$(t);)
	@echo -e ${CL_CYN}"Generate busybox links:"${CL_RST} $(BUSYBOX_TOOLS_INSTALLED)
	$(hide) $(foreach t,$(BUSYBOX_TOOLS_INSTALLED),ln -sf busybox $(TARGET_RECOVERY_ROOT_OUT)/sbin/$(t);)
	@echo -e ${CL_CYN}"Generate toolbox links:"${CL_RST} $(TOOLBOX_TOOLS_INSTALLED)
	$(hide) $(foreach t,$(TOOLBOX_TOOLS_INSTALLED),ln -sf toolbox $(TARGET_RECOVERY_ROOT_OUT)/sbin/$(t);)
