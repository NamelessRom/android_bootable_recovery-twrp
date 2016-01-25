**Fork of TWRP**

This fork differs from the original in the following ways:

*   Designed to be built with CyanogenMod 13.0 only
*   Require fstab v2 syntax (see examples and supported flags below)
*   Use external repositories for pigz, exfat, fuse
*   Power key toggles screen on/off
*   Support grayscale splash to trim the size of recovery by 100-200 KB depending on screen resolution. Use `TW_REDUCED_GRAPHICS := true` to enable this option
*   Remove the need to specify either `DEVICE_RESOLUTION` or `TW_THEME` so long as `TARGET_SCREEN_HEIGHT` and `TARGET_SCREEN_WIDTH` are set
*   Other minor customizations (see change history)

**Examples of fstab v2 for TWRP**

Example fstab v2 for device [mt2](https://github.com/mdmower/android_device_huawei_mt2):  

_Worth noting in this example: `encryptable=` does not need to be specified if encryption keys are stored at the footer of `/data`. This is the default, assumed location._

    # device                                          mount_point     fstype  mount_flags                             fs_mgr_flags   twrp_flags
    /dev/block/platform/msm_sdcc.1/by-name/boot       /boot           emmc    defaults                                defaults
    /dev/block/platform/msm_sdcc.1/by-name/cache      /cache          ext4    noatime,nosuid,nodev                    defaults
    /dev/block/platform/msm_sdcc.1/by-name/userdata   /data           ext4    noatime,nosuid,nodev,noauto_da_alloc    length=-16384
    /dev/block/platform/msm_sdcc.1/by-name/modem      /firmware       vfat    ro                                      defaults       twrp=display="Firmware";mounttodecrypt
    /dev/block/platform/msm_sdcc.1/by-name/log        /log            ext4    defaults                                defaults       twrp=display="Log"
    /dev/block/platform/msm_sdcc.1/by-name/misc       /misc           emmc    defaults                                defaults
    /dev/block/platform/msm_sdcc.1/by-name/recovery   /recovery       emmc    defaults                                defaults
    /dev/block/platform/msm_sdcc.1/by-name/system     /system         ext4    defaults                                defaults

    /dev/block/mmcblk1p1                              /external_sd    vfat    defaults                                defaults       twrp=display="MicroSD";storage;wipeingui;removable
    /dev/block/sda1                                   /usb-otg        vfat    defaults                                defaults       twrp=display="USB OTG";storage;wipeingui;removable

Example fstab v2 for device [jewel](https://github.com/mdmower/twrp-htc-jewel):  

    # device                                           mount_point     fstype  mount_flags                           fs_mgr_flags                                              twrp_flags
    /dev/block/platform/msm_sdcc.1/by-name/boot        /boot           emmc    defaults                              defaults
    /dev/block/platform/msm_sdcc.1/by-name/cache       /cache          ext4    noatime,nosuid,nodev                  defaults
    /dev/block/platform/msm_sdcc.1/by-name/userdata    /data           ext4    noatime,nosuid,nodev,noauto_da_alloc  encryptable=/dev/block/platform/msm_sdcc.1/by-name/extra
    /dev/block/platform/msm_sdcc.1/by-name/devlog      /devlog         ext4    noatime,nosuid,nodev                  defaults                                                  twrp=display="Devlog"
    /dev/block/platform/msm_sdcc.1/by-name/misc        /misc           emmc    defaults                              defaults
    /dev/block/platform/msm_sdcc.1/by-name/recovery    /recovery       emmc    defaults                              defaults
    /dev/block/platform/msm_sdcc.1/by-name/system      /system         ext4    noatime                               defaults

    /dev/block/mmcblk1p1                               /external_sd    vfat    defaults                              defaults                                                  twrp=display="MicroSD";storage;wipeingui;removable
    /dev/block/sda1                                    /usb-otg        vfat    defaults                              defaults                                                  twrp=display="USB OTG";storage;wipeingui;removable

**Supported fstab v2 flags in TWRP**

Recognized mount flags (Column 4):  
_Syntax:_ comma separated

* `bind`
* `defaults`
* `noatime`
* `nodev`
* `nodiratime`
* `noexec`
* `nosuid`
* `private`
* `rec`
* `remount`
* `ro`
* `rw`
* `shared`
* `slave`
* `unbindable`

Recognized fs\_mgr flags (Column 5):  
_Syntax:_ comma separated

* `defaults`
* `encryptable=`
* `length=`

Recognized twrp flags (Column 6):  
_Syntax:_ semicolon separated, begin with `twrp={flags}`

* `andsec`
* `backup=`
* `backupname=`
* `blocksize=`
* `canbewiped`
* `canencryptbackup=`
* `display=`
* `flashimg`
* `forceencrypt=`
* `ignoreblkid`
* `length=`
* `mounttodecrypt`
* `removable`
* `retainlayoutversion`
* `rw`
* `settingsstorage`
* `storage`
* `storagename=`
* `subpartitionof=`
* `symlink=`
* `userdataencryptbackup=`
* `usermrf`
* `wipeduringfactoryreset`
* `wipeingui`
