#!/bin/bash
if [[ $(virsh -c qemu:///system list | awk '($2 == "Windows11") { print $3}') != 'running' ]]
then
virsh --connect qemu:///system start Windows11
sleep 20
else
  echo "VM already running"
fi
xfreerdp -grab-keyboard /kbd:0x00000807 +clipboard /v:192.168.122.218 /u:fabia /p:toaster85 /cert-ignore /size:100% /d: /dynamic-resolution /gfx-h264:avc444 +gfx-progressive &
