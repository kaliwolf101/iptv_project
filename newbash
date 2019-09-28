#!/bin/bash


#

# Automatic FastoCloud Server setup v1 by urgodfather

#

#



echo "#############################################################################"

echo "FastoCloud Install"

sleep 10



apt-get update && apt-get upgrade -y && apt-get install python3 screen python3-setuptools git mongodb -y



echo "#############################################################################"

echo "Let's make sure you are up to date"

sleep 10



git clone https://github.com/fastogt/fastocloud

cd fastocloud

git submodule update --init --recursive

cd build



echo "#############################################################################"

echo "Pulling the latest sources"

sleep 10



git clone https://github.com/fastogt/pyfastogt

cd pyfastogt

python3 setup.py install

cd ../

rm -rf pyfastogt



echo "#############################################################################"

echo "Staging the environment"

sleep 10



./build_env.py



echo "#############################################################################"

echo "Service is now built"

sleep 10



license_gen  &gt; license.key





echo "#############################################################################"

echo "We need to get you a key"

sleep 10

filename='license.key'

n=1

while read line; do

# reading each line

echo "Your license key is : $line"

n=$((n+1))

sleep 10



/build.py release $line

done &lt; $filename



echo "#############################################################################"

echo "Installing the license key"

sleep 10



useradd -m -U -d /home/fastocloud fastocloud -s /bin/bash



echo "#############################################################################"

echo "Making the system user"

sleep 10



systemctl enable fastocloud

systemctl start fastocloud



echo "#############################################################################"

echo "Setting up the service"

sleep 10

echo "#############################################################################"

echo " "

echo "Server has been built."

echo " "

echo " "

echo " "

      read -p "Do you need to install the panel too (y/n)?" CONT

      if [ "$CONT" == "n" ] || [ "$CONT" == "n" ]; then

      reboot

      else

echo "#############################################################################"



cd ~

git clone https://github.com/fastogt/fastocloud_admin

cd fastocloud_admin

 git submodule update --init --recursive

echo "#############################################################################"

echo "Grabbing the latest panel"

sleep 10



pip3 install -r requirements.txt

pip3 install wheel

echo "#############################################################################"

echo "Getting things ready"

sleep 10



screen -d -m -S fasto bash -c 'cd $HOME/fastocloud_admin && ./server.py'



echo "#############################################################################"

echo "Panel is now installed!"

sleep 10



      read -p "Let's make your first login (y/n)?" CONT

      if [ "$CONT" == "n" ] || [ "$CONT" == "n" ]; then

      reboot

      fi



echo "#############################################################################"

sleep 10

# email="USER INPUT"

read -p "Enter an email address: " email



read -p "Continue? (y/n): " CONT

    

      if [ "$CONT" == "n" ] || [ "$CONT" == "n" ]; then

      read -p "you must enter an email address: " email

      else



# pass="random"

date +%s | sha256sum | base64 | head -c 32



./scripts/create_provider.py --email=$email --password=$pass



echo "#############################################################################"

sleep 10



cp ~/fastocloud/build/license.key registration.key

echo $email &gt; registration.key

echo $pass &gt; registration.key



filename='registration.key'



echo "#############################################################################"

echo " "

echo "#############################################################################"

echo " "



echo "Your registration is : "

read $filename



echo " "

echo "#############################################################################"

echo " "

echo "#############################################################################"

sleep 20



echo "#############################################################################"

echo " "

echo "Setup has finished..."

echo " "

echo "Your server will now reboot!!!"

echo " "

      read -p "Reboot now (y/n)?" CONT

      if [ "$CONT" == "y" ] || [ "$CONT" == "Y" ]; then

      reboot

      fi

echo "#############################################################################"

echo "#############################################################################"
