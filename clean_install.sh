#!/bin/sh


################################### NOTES  ###########################################################################
#   ****  DISCLAIMER:  THIS IS PROVIDED AS OPENSOURCE PRODUCT AND IS UNDER DEVELOPEMENT.  RUN AT YOUR OWN RISK.  ****

# This is an bash script to install fastogt to a fresh ubuntu server.  
# You must run the Script as root <su root>
# Load script to your root@/home/user directory, <wget https://raw.githubusercontent.com/gear259/iptv_project/master/clean_install.sh
# Run command bash ./clean_install.sh

####################################  Progress Code   ################################################################


function delay()
{
    sleep 0.2;
}


#set -ex
#################################### INFO ######################################

# This is the first script phase for installing IPTV BACKEND server

################################################################################

echo "The task is in progress, please wait a few seconds"
echo "going to download IPTV Phase 1 files from git"
echo
progress 0 "Initialize"

# exports
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

# variables
USER=iptv_cloud

# update system and prepare dependencies
apt-get update
apt-get install -y git python3-setuptools python3-pip mongodb --no-install-recommends
echo "Dependencies installed"

#make the files
cd /home/user
mkdir iptv_project
cd iptv_project
git clone https://github.com/fastogt/iptv
git clone https://github.com/fastogt/iptv_admin

# sync modules
cd iptv
git submodule update --init --recursive
echo "Success"

#pre-build
#progress 30 "Changing Directory"
cd build

# install pyfastogt
git clone https://github.com/fastogt/pyfastogt
echo "Success"
cd pyfastogt
python3 setup.py install
echo "Success! Now deleting uneeded files"
cd ../
rm -rf pyfastogt

# build env for service
echo "This will take a long time. If running, come back in 15 minutes and check on progress. Starting in 2 seconds."
sleep 2
./build_env.py

echo "Build Package Installed"
echo "Nearly done now, lets get the key"

# build service with key
LICENSE_KEY=$(license_gen)
./build.py release $LICENSE_KEY

# add user
useradd -m -U -d /home/$USER $USER -s /bin/bash

#################################### INFO ######################################

# This is the second script phase for installing IPTV FRONT-END (UI) server

################################################################################

echo "going to download iptv_admin files from git"
echo

sleep 1

#move from iptv_project/iptv/build to iptv_project/iptv_admin
cd /iptv_admin
git submodule update --init --recursive
echo
echo "Processing requirements"
pip3 install -r requirements.txt
#
sleep 5
#creating admin user to log in to web panel - replace test@example.com and 1234567 with your email and 7 character password below or leave default

./scripts/create_provider.py --email=test@example.com --password=1234567

#
echo "Fetching your key"
echo "your unique license key is below. Copy it to a notepad and then append to server you setup up in panel for activation"
license_gen >>home/user/iptv_project/license_key.txt
sleep 4
echo
echo
echo "loading up IPTV Admin panel"
echo "keep this console open"

systemctl enable streamer_service.service
systemctl start streamer_service.service
./server.py
