# RTL8822BU / RTL88x2BU driver

Out-of-tree USB WiFi driver for the RTL8822BU chipset (used with a generic
"AC1200"-class USB WiFi adapter during development, not a component of the
phone itself).

Source: [morrownr/88x2bu-20210702](https://github.com/morrownr/88x2bu-20210702),
one of the more actively maintained forks of Realtek's vendor driver.

Licence: GPL-2.0, Copyright (c) 2007-2023 Realtek Corporation. See `LICENSE`
in this directory, kept as shipped upstream.

Changes made for this port, on top of the imported source:

- Kconfig/Makefile wiring so the tree builds it as `CONFIG_RTL8822BU`
- `ccflags-y += -Wno-unknown-warning-option`, needed because this device is
  built with clang-9 and the driver passes some GCC-only `-Wno-*` flags that
  clang-9 does not recognise (see the comment in `Makefile`)

No functional changes to the driver itself.
