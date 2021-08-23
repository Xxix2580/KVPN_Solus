#!/bin/bash
# Only for Solus OS.(4.3 Fortitude)
# Needs KVPN installation deb file.(for Ubuntu, 64bit)
# Requires binutils to use "ar" command.
ROOT_UID=0
E_NOTROOT=67

if [ "$UID" -ne "$ROOT_UID" ]
then
	echo "Script have to be executed on Root privilege."
	exit $E_NOTROOT
fi

mkdir /tmp/pulsesecure_fix_sh
mkdir /tmp/pulsesecure_fix_sh/deb_tmp

echo "Given Deb file extracting..."
cp $1 /tmp/pulsesecure_fix_sh/ps_sec.deb
cd /tmp/pulsesecure_fix_sh
ar x /tmp/pulsesecure_fix_sh/ps_sec.deb
tar -zxf /tmp/pulsesecure_fix_sh/data.tar.gz

cd /tmp/pulsesecure_fix_sh/deb_tmp

echo "Dependencies Downloading..."
echo "1. libicu60"
wget http://archive.ubuntu.com/ubuntu/pool/main/i/icu/libicu60_60.2-3ubuntu3_amd64.deb
echo "2. libjavascriptcoregtk1.0"
wget http://archive.ubuntu.com/ubuntu/pool/universe/w/webkitgtk/libjavascriptcoregtk-1.0-0_2.4.11-3ubuntu3_amd64.deb
echo "3. libwebkitgtk-1.0"
wget http://archive.ubuntu.com/ubuntu/pool/universe/w/webkitgtk/libwebkitgtk-1.0-0_2.4.11-3ubuntu3_amd64.deb
echo "4. libgnome-keyring0_3.12"
wget http://ftp.us.debian.org/debian/pool/main/libg/libgnome-keyring/libgnome-keyring0_3.12.0-1+b2_amd64.deb



echo "Installing PulseSecure..."
cd /tmp/pulsesecure_fix_sh/usr/local/pulse
tar -zxf /tmp/pulsesecure_fix_sh/usr/local/pulse/pulse.tgz
# Force-Install like for Ubuntu 20.04
if [ ! -d /usr/local ] ; then
	mkdir /usr/local
fi
mv /tmp/pulsesecure_fix_sh/usr/local/pulse /usr/local/pulse
# Renaming binaries for ubuntu.
mv /usr/local/pulse/pulseUi_Ubuntu_16_x86_64 /usr/local/pulse/pulseUi
mv /usr/local/pulse/libpulseui.so_Ubuntu_16_x86_64 /usr/local/pulse/libpulseui.so

# Dealing with extra dependency problems...
echo "Installing downloaded deb files..."

cd /tmp/pulsesecure_fix_sh/deb_tmp
ar x /tmp/pulsesecure_fix_sh/deb_tmp/libicu60_60.2-3ubuntu3_amd64.deb
tar -xvf /tmp/pulsesecure_fix_sh/deb_tmp/data.tar.xz
rm /tmp/pulsesecure_fix_sh/deb_tmp/data.tar.xz

ar x /tmp/pulsesecure_fix_sh/deb_tmp/libjavascriptcoregtk-1.0-0_2.4.11-3ubuntu3_amd64.deb
tar -xvf /tmp/pulsesecure_fix_sh/deb_tmp/data.tar.xz
rm /tmp/pulsesecure_fix_sh/deb_tmp/data.tar.xz

ar x /tmp/pulsesecure_fix_sh/deb_tmp/libwebkitgtk-1.0-0_2.4.11-3ubuntu3_amd64.deb
tar -xvf /tmp/pulsesecure_fix_sh/deb_tmp/data.tar.xz
rm /tmp/pulsesecure_fix_sh/deb_tmp/data.tar.xz

ar x /tmp/pulsesecure_fix_sh/deb_tmp/libgnome-keyring0_3.12.0-1+b2_amd64.deb
tar -xvf /tmp/pulsesecure_fix_sh/deb_tmp/data.tar.xz
rm /tmp/pulsesecure_fix_sh/deb_tmp/data.tar.xz

# Move that folder.
mkdir /usr/local/pulse/extra
mv /tmp/pulsesecure_fix_sh/deb_tmp/usr /usr/local/pulse/extra/usr

echo "Dealing with extra missing dependencies..."
# Install libenchant.
echo "Installing enchant16 package"
eopkg install enchant16

# Make an symbolic link to libwebp.so.6
echo "Linking libwebp.so.7 as libwebp.so.6"
ln -s /usr/lib64/libwebp.so.7 /usr/lib64/libwebp.so.6

# But, more dependencies will be needed.
# Only GUI works... not net services. -> Executing in Root Shell solves this problem.
# So, Getting Root Privilege in Script and execute by that script will be needed to install.

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/pulse/extra/usr/lib/x86_64-linux-gnu/ && /usr/bin/env LD_LIBRARY_PATH=/usr/local/pulse:$LD_LIBRARY_PATH /usr/local/pulse/pulseUi
#Above is execute command.
