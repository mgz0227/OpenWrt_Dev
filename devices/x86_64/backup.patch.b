        make defconfig

        echo "🔧 Disabling sound packages (soft-router build)"
        # 关掉所有 sound / alsa / usb-audio 相关包选择
        sed -i -E '
          s/^(CONFIG_PACKAGE_kmod-(sound|snd-|usb-audio|ac97|pcspkr).*)=.*/# \1 is not set/;
          s/^(CONFIG_PACKAGE_alsa-lib)=.*/# \1 is not set/;
          s/^(CONFIG_PACKAGE_alsa-utils)=.*/# \1 is not set/;
        ' .config
        # 彻底关掉 mac80211 / cfg80211 / wifi 驱动，避免 backports 编译 ath9k
        sed -n '/# Wireless Drivers/,/# end of Wireless Drivers/p' .config | sed -e 's/=m/=n/' >> .config
        sed -i "s/\(kmod-qca.*\)=m/\1=n/" .config
        sed -n '/# Video Support/,/# end of Video Support/p' .config | sed -e 's/=m/=n/' >> .config
        sed -i -E '
          s/^(CONFIG_PACKAGE_kmod-drm.*)=.*/# \1 is not set/;
          s/^(CONFIG_PACKAGE_kmod-gpu.*)=.*/# \1 is not set/;
          s/^(CONFIG_PACKAGE_kmod-video.*)=.*/# \1 is not set/;
          s/^(CONFIG_PACKAGE_kmod-cec)=.*/# \1 is not set/;
        ' .config    
        make defconfig



CONFIG_PACKAGE_kmod-v4l2loopback=n
CONFIG_PACKAGE_kmod-ovpn-dco-v2=n
CONFIG_PACKAGE_kmod-usb-serial-xr_usb_serial_common=n
CONFIG_PACKAGE_kmod-openvswitch=n
CONFIG_PACKAGE_kmod-nat46=n
CONFIG_PACKAGE_kmod-r8101=n
CONFIG_PACKAGE_kmod-r8127=n
CONFIG_PACKAGE_kmod-r8127-rss=n
CONFIG_PACKAGE_kmod-r8168=n
CONFIG_PACKAGE_kmod-r8168-rss=n
CONFIG_PACKAGE_kmod-r8169=n
CONFIG_DEFAULT_kmod-r8169=n
CONFIG_DEFAULT_kmod-r8169=n
CONFIG_PACKAGE_r8152-firmware=n
CONFIG_PACKAGE_r8169-firmware=n