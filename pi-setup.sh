# setup ssh key login

cd ~ 
pwd 
mkdir .ssh
cd .ssh
nano authorized_keys

# Set permissions
ls -l
chmod 700 ~/.ssh/
chmod 600 ~/.ssh/authorized_keys
ls -l

# Setup agent

sudo nano /etc/ssh/sshd_config

# set PasswordAuthentication no

sudo /etc/init.d/ssh restart
sudo reboot

# Setup USB Drive

sudo apt update
sudo apt upgrade
sudo apt install ntfs-3g
sudo fdisk -l

# Get USB UUID
sudo ls -l /dev/disk/by-uuid/

sudo mkdir /mnt/usb

# Add Mount
UUID=xxxx-xxxx        /mnt/usb        vfat    uid=pi,gid=pi     0       0

sudo mount -a

# Install Docker

curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh

# Update DNS

sudo nano /etc/dhcpcd.conf
static domain_name_servers=1.1.1.1 1.0.0.1
sudo service dhcpcd restart

# Validate DNS

sudo nano /etc/resolv.conf
sudo apt-get install dnsutils
dig yahoo.com

# https://www.novaspirit.com/2017/06/22/raspberry-pi-vpn-router-w-pia/

# Setup VPN

sudo apt-get install openvpn

wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
unzip openvpn.zip -d openvpn

sudo cp openvpn/ca.rsa.2048.crt openvpn/crl.rsa.2048.pem /etc/openvpn/
sudo cp openvpn/US New York.ovpn /etc/openvpn/US.conf

sudo nano /etc/openvpn/login

###
# username
# password
###

sudo nano /etc/openvpn/US.conf
auth-user-pass /etc/openvpn/login
ca /etc/openvpn/ca.rsa.2048.crt

# Test the VPN

sudo openvpn --config /etc/openvpn/US.conf
sudo systemctl enable openvpn@US