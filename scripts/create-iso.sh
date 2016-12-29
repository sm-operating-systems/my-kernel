#!/bin/bash
# Creates the iso image for the kernel
# Arguments: A list of modules to load
# Dependencies: gnisoimage
#------------------------------------------
GENISOIMAGE_PATH=`which genisoimage`

if [ -z $GENISOIMAGE_PATH ]; then
	echo "Error: Install genisoimage in order to create an iso."
	exit 1
fi

set -e #fail as soon as one command fails

MODULES="$@"
ISO_FOLDER="iso"
GRUB2_STAGE="../tools/stage2_eltorito"

#Create the ISO directory structure
mkdir -p $ISO_FOLDER/boot/grub
mkdir $ISO_FOLDER/modules

#Copy the stage2_eltorito into the correct place
cp $GRUB2_STAGE $ISO_FOLDER/boot/grub/

#Copy the kernel.elf to the correct location
KERNEL=kernel/kernel.elf
cp $KERNEL $ISO_FOLDER/boot/grub/

#Copy all modules to the correct place

for m in $MODULES
do
	MENU="$MENU
module /modules/$m"

echo "$MENU" > $ISO_FOLDER/boot/grub/menu.lst

# build the ISO image
# -R:                   Use the Rock Ridge protocol (needed by GRUB)
# -b file:              The file to boot from (relative to the root folder of 
#                       the ISO)
# -no-emul-boot:        Do not perform any disk emulation
# -boot-load-size sz:   The number 512 byte sectors to load. Apparently most 
#                       BIOS likes the number 4.
# -boot-info-table:     Writes information about the ISO layout to ISO (needed 
#                       by GRUB)
# -o name:              The name of the iso
# -A name:              The label of the iso
# -input-charset cs:    The charset for the input files
# -quiet:               Disable any output from genisoimage
echo "Creating iso image. "
genisoimage -R                              \
            -b boot/grub/stage2_eltorito    \
            -no-emul-boot                   \
            -boot-load-size 4               \
            -A os                           \
            -input-charset utf8             \
            -quiet                          \
            -boot-info-table                \
            -o os.iso                       \
            iso
#Clean up the iso directory
rm -rf $ISO_FOLDER

exit 0

