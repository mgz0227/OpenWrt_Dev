        echo "🔧 Disabling sound packages (soft-router build)"
        # 关掉所有 sound / alsa / usb-audio 相关包选择
        sed -i -E '
          s/^(CONFIG_PACKAGE_kmod-(sound|snd-|usb-audio|ac97|pcspkr).*)=.*/# \1 is not set/;
          s/^(CONFIG_PACKAGE_alsa-lib)=.*/# \1 is not set/;
          s/^(CONFIG_PACKAGE_alsa-utils)=.*/# \1 is not set/;
        ' .config




        sed -n '/# Video Support/,/# end of Video Support/p' .config | sed -e 's/=m/=n/' >> .config
        sed -i -E '
          s/^(CONFIG_PACKAGE_kmod-drm.*)=.*/# \1 is not set/;
          s/^(CONFIG_PACKAGE_kmod-gpu.*)=.*/# \1 is not set/;
          s/^(CONFIG_PACKAGE_kmod-video.*)=.*/# \1 is not set/;
          s/^(CONFIG_PACKAGE_kmod-cec)=.*/# \1 is not set/;
        ' .config       