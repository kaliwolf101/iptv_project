# iptv_project FASTOGT

# Auto-Install Backend Media Service (FastoCloud Node) and Front-end (FastoCloud Panel_admin (formally iptv_admin)) using this bash script

# Code:
su root
wget https://raw.githubusercontent.com/gear259/iptv_project/master/clean_install.sh && bash ./clean_install.sh


# NOTE:
# Start your server from shell login directory ./iptv_project/iptv_admin/server.py
# Input url example http://134.209.176.72:8000/0/5cf41492f88cad02af1953b0/10/master.m3u8
# Output url http://localhost:8000/master.m3u8
# change 'localhost'to your public address in your server settings and each channel will automatically change from localhost to your domain.
# Restart commamd after reboot: 
screen
cd /fastocloud_admin
./server.py
