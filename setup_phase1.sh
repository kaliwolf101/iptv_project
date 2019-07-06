#! /bin/sh
cd ../ && apt-get update && apt-get upgrade && apt-get install python3 python3-setuptools git
git clone https://github.com/fastogt/iptv && cd iptv
git submodule update --init --recursive && cd build
git clone https://github.com/fastogt/pyfastogt && cd pyfastogt
python3 setup.py install && cd ../
rm -rf pyfastogt
./iptv/build/build_env.py && echo "build finished! Your licence key is below. Copy it to a notepad and also append to next command"
license_gen