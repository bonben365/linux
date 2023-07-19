sudo apt update -y
sudo apt install virtualbox-guest-additions-iso -y
sudo mkdir -p /mnt/cdrom
sudo mkdir -p /tmp/cdrom
sudo mount /usr/share/virtualbox/VBoxGuestAdditions.iso /mnt/cdrom
sudo cp -r /mnt/cdrom/* /tmp/cdrom
cd /tmp/cdrom
chmod +x VBoxLinuxAdditions.run
sudo ./VBoxLinuxAdditions.run
