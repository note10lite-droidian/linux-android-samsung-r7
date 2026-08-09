Kernel — Samsung Galaxy Note10 Lite (`r7`)
============================================

Linux 4.9.191 kernel source for the Samsung Galaxy Note10 Lite (SM-N770F,
codename `r7`, Exynos 9810), packaged for the
[Droidian port](https://github.com/note10lite-droidian/droidian-samsung-r7)
of this device. Based on Samsung's stock kernel source with the patches
needed to boot a mainline-ish Linux userspace (Halium/Droidian) on top of
the stock Android vendor partition.

## Building

Requires the config `exynos9810-r7_halium_defconfig` and AOSP clang
`9.0-r353983c`. Clang version matters here: a kernel built with a newer
toolchain hangs at the boot logo on this device and never proceeds.

Full build instructions, including config-checking without a full build
and every non-obvious pitfall hit while working on this kernel, are in
[docs/BUILDING.md](https://github.com/note10lite-droidian/docs/blob/main/docs/BUILDING.md).

```sh
git clone https://github.com/note10lite-droidian/linux-android-samsung-r7.git \
    linux-android-samsung-r7
cd linux-android-samsung-r7
git checkout droidian
sudo docker run --rm \
  -v $HOME/droidian/packages:/buildd \
  -v $PWD:/buildd/sources \
  -e RELENG_FULL_BUILD=yes \
  -e RELENG_HOST_ARCH=arm64 \
  quay.io/droidian/build-essential:current-amd64 \
  /bin/sh -c 'cd /buildd/sources && releng-build-package'
```

## Related repositories

- [droidian-samsung-r7](https://github.com/note10lite-droidian/droidian-samsung-r7) — image build, releases
- [adaptation-samsung-r7](https://github.com/note10lite-droidian/adaptation-samsung-r7) — device adaptation package
- [docs](https://github.com/note10lite-droidian/docs) — install guide, known issues, feature status
