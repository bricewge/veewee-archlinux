#!/bin/bash

# Requires
#   pacman.sh

ip=`ip addr show dev eth0 | grep 'inet ' | awk '{print $2}'`
gateway=`ip route show | grep 'default' | awk '{print $3}'`
dns=`ip route show | grep 'default' | awk '{print $3}'`

# Chroot into the new system and set up SSH access
arch-chroot /mnt <<ENDCHROOT
# Get the actual network configuration
ip=`ip addr show dev eth0 | grep 'inet ' | awk '{print $2}'`
gateway=`ip route show | grep 'default' | awk '{print $3}'`
dns=`ip route show | grep 'default' | awk '{print $3}'`

# Make the actual network configuration persitent accros reboot
cp /etc/netctl/examples/ethernet-static /etc/netctl/eth0
sed -i "s~Address=('192.168.1.23/24' '192.168.1.87/24')~Address=('${ip}')~g" /etc/netctl/eth0
sed -i "s~Gateway='192.168.1.1'~Gateway='${gateway}'~g" /etc/netctl/eth0
sed -i "s~DNS=('192.168.1.1')~DNS=('${dns}')~g" /etc/netctl/eth0
netctl enable eth0

# ip addr add 192.168.122.233/24 dev eth0
ENDCHROOT
