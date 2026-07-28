#
# Makefile for the Linux Bluetooth subsystem.
#

obj-$(CONFIG_BT)	+= bluetooth.o
# Samsung had these three lines commented out. With them commented, kbuild
# never descends into the subdirectories, so RFCOMM/BNEP/HIDP were not built
# even though CONFIG_BT_{RFCOMM,BNEP,HIDP}=y - the same class of change as the
# commented-out body of hci_sock.c. Note that /proc/config.gz still reports the
# options as enabled, so the only reliable check is runtime state
# (/proc/net/protocols).
#
# Without BNEP there is no Bluetooth tethering, without RFCOMM no serial
# profiles, without HIDP no Bluetooth keyboard/mouse. Re-enabled.
obj-$(CONFIG_BT_RFCOMM)	+= rfcomm/
obj-$(CONFIG_BT_BNEP)	+= bnep/
obj-$(CONFIG_BT_CMTP)	+= cmtp/
obj-$(CONFIG_BT_HIDP)	+= hidp/
obj-$(CONFIG_BT_6LOWPAN) += bluetooth_6lowpan.o

bluetooth_6lowpan-y := 6lowpan.o

bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
	hci_sock.o hci_sysfs.o l2cap_core.o l2cap_sock.o smp.o lib.o \
	ecc.o hci_request.o mgmt_util.o

bluetooth-$(CONFIG_BT_BREDR) += sco.o
bluetooth-$(CONFIG_BT_HS) += a2mp.o amp.o
bluetooth-$(CONFIG_BT_LEDS) += leds.o
bluetooth-$(CONFIG_BT_DEBUGFS) += hci_debugfs.o
bluetooth-$(CONFIG_BT_SELFTEST) += selftest.o

subdir-ccflags-y += -D__CHECK_ENDIAN__
