**Fork of TWRP**

This fork differs from the original in the following ways:

*   Stripped support for building in any Android tree other than CyanogenMod 13.0
*   Require fstab v2 syntax ([example](https://github.com/mdmower/android_device_huawei_mt2/commit/2cf14490ce3d0c9cd5d087e4d9422dbc0831bf7c)) -- see `TWPartition::Process_Flags()` in [partition.cpp](https://github.com/mdmower/twrp/blob/cm-13.0/partition.cpp) for supported TWRP flags
*   Prefer toybox utilities over busybox where available
*   Use external repositories for pigz, exfat, fuse
*   Support reduced graphics to slightly trim the size of recovery
*   Remove the need to specify either `DEVICE_RESOLUTION` or `TW_THEME` so long as `TARGET_SCREEN_HEIGHT` and `TARGET_SCREEN_WIDTH` are set
*   Other minor customizations (see change history)
