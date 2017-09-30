#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:14208334:7b7b7392523ca6e3812faa2b62dcd6e618384a84; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:12395850:d718550ceb60ac137a2c9232f9bd87f787c18eeb EMMC:/dev/block/bootdevice/by-name/recovery 7b7b7392523ca6e3812faa2b62dcd6e618384a84 14208334 d718550ceb60ac137a2c9232f9bd87f787c18eeb:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
