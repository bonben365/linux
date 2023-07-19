sudo apt update -y
sudo apt install virtualbox-guest-additions-iso -y
sudo mkdir -p /mnt/cdrom
sudo mount /usr/share/virtualbox/VBoxGuestAdditions.iso /mnt/cdrom
cd /mnt/cdrom
chmod +x VBoxLinuxAdditions.run
sudo ./VBoxLinuxAdditions.run
