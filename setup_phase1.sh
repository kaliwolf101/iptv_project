#! /bin/sh

#run as root
#set -ex
#progress code
function delay()
{
    sleep 0.2;
}

#
# Description : print out executing progress
# 
CURRENT_PROGRESS=0
function progress()
{
    PARAM_PROGRESS=$1;
    PARAM_PHASE=$2;

    if [ $CURRENT_PROGRESS -le 0 -a $PARAM_PROGRESS -ge 0 ]  ; then echo -ne "[..........................] (0%)  $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 5 -a $PARAM_PROGRESS -ge 5 ]  ; then echo -ne "[#.........................] (5%)  $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 10 -a $PARAM_PROGRESS -ge 10 ]; then echo -ne "[##........................] (10%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 15 -a $PARAM_PROGRESS -ge 15 ]; then echo -ne "[###.......................] (15%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 20 -a $PARAM_PROGRESS -ge 20 ]; then echo -ne "[####......................] (20%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 25 -a $PARAM_PROGRESS -ge 25 ]; then echo -ne "[#####.....................] (25%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 30 -a $PARAM_PROGRESS -ge 30 ]; then echo -ne "[######....................] (30%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 35 -a $PARAM_PROGRESS -ge 35 ]; then echo -ne "[#######...................] (35%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 40 -a $PARAM_PROGRESS -ge 40 ]; then echo -ne "[########..................] (40%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 45 -a $PARAM_PROGRESS -ge 45 ]; then echo -ne "[#########.................] (45%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 50 -a $PARAM_PROGRESS -ge 50 ]; then echo -ne "[##########................] (50%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 55 -a $PARAM_PROGRESS -ge 55 ]; then echo -ne "[###########...............] (55%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 60 -a $PARAM_PROGRESS -ge 60 ]; then echo -ne "[############..............] (60%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 65 -a $PARAM_PROGRESS -ge 65 ]; then echo -ne "[#############.............] (65%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 70 -a $PARAM_PROGRESS -ge 70 ]; then echo -ne "[###############...........] (70%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 75 -a $PARAM_PROGRESS -ge 75 ]; then echo -ne "[#################.........] (75%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 80 -a $PARAM_PROGRESS -ge 80 ]; then echo -ne "[####################......] (80%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 85 -a $PARAM_PROGRESS -ge 85 ]; then echo -ne "[#######################...] (85%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 90 -a $PARAM_PROGRESS -ge 90 ]; then echo -ne "[##########################] (100%) $PARAM_PHASE \r" ; delay; fi;
    if [ $CURRENT_PROGRESS -le 100 -a $PARAM_PROGRESS -ge 100 ];then echo -ne 'Done!                                            \n' ; delay; fi;

    CURRENT_PROGRESS=$PARAM_PROGRESS;

}
#end of progress code
#################################### INFO ######################################

# This is the first script PHASE 1 for installing IPTV

################################################################################

echo "The task is in progress, please wait a few seconds"
echo "going to download IPTV Phase 1 files from git"
echo
progress 0 "Initialize"

# exports
#export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

# variables
USER=iptv_cloud

# update system and prepare dependencies
progress 10 "Prepare System"
apt-get update
progress 15 "Phase 1 - Install Dependencies"
apt-get install -y git python3-setuptools python3-pip mongodb --no-install-recommends
echo "Dependencies installed"

#make the files
cd /
mkdir iptv_project
cd iptv_project
progress 20 "Downloading iptv files from github"
git clone https://github.com/fastogt/iptv

# sync modules
progress 25 "Processing downloaded iptv files"
cd iptv
git submodule update --init --recursive
echo "Success"

#pre-build
progress 30 "Changing Directory"
cd build

# install pyfastogt
progress 35 "Downloading pyfastogt from github"
git clone https://github.com/fastogt/pyfastogt
echo "Success"
progress 40 "Processing pyfastogt files"
cd pyfastogt
python3 setup.py install
echo "Success! Now deleting uneeded files"
cd ../
rm -rf pyfastogt

# build env for service
progress 50 "Processing Build Package"
echo "This will take a long time. If running, come back in 15 minutes and check on progress"
./iptv/build/build_env.py

echo "Build Package Installed"
echo "Did you fall asleep waiting?  Nearly done now, lets get the key"

echo "Fetching your key"
echo "your unique license key is below. Copy it to a notepad and then append to next command"

# build service with key
LICENSE_KEY=$(license_gen)
./build.py release $LICENSE_KEY

# add user
useradd -m -U -d /home/$USER $USER -s /bin/bash

#phase2
echo "going to download iptv_admin files from git"
echo
progress 60 "Initialize"
cd /
progress 70 "Phase 2"
git clone https://github.com/fastogt/iptv_admin
sleep 1
echo "download complete to folder iptv_admin"
progress 80 "processing files"
cd iptv_admin
git submodule update --init --recursive
echo
echo "Processing requirements"
pip3 install -r requirements.txt
#

#creating admin user to log in to web panel
progress 90 "Creating an admin user"
./iptv_project/iptv_admin/scripts/create_provider.py --email=test@example.com --password=1234567


progress 100 "iptv_admin panel ready to start"
#
echo
echo
echo
echo "loading up IPTV Admin panel"
echo "keep this console open"
cd
systemctl enable streamer_service.service
systemctl start streamer_service.service
./iptv_project/iptv_admin/server.py
