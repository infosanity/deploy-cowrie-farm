#!/bin/bash

echo "Moving SSHD Port" >> /home/build.log
cat /etc/ssh/sshd_config | sed s/"#Port 22"/"Port 22222"/ > /tmp/sshd_out
mv /tmp/sshd_out /etc/ssh/sshd_config
service ssh restart

# based on https://cowrie.readthedocs.io/en/latest/INSTALL.html
echo "updating" >> /home/build.log

# manual install of SSM agent - failing on some builds
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

apt -y update 
DEBIAN_FRONTEND=noninteractive apt -y upgrade #dying on graphical question, #TOFIX
apt -y install git python3-virtualenv libssl-dev libffi-dev build-essential libpython3-dev python3-minimal authbind virtualenv

echo "Adding user" >> /home/build.log
adduser --disabled-password --gecos "" cowrie

echo "HereDoc blob" >> /home/build.log 
sudo -H -u cowrie /bin/bash -s << EOF >> /home/cowrie/heredoc.out
cd /home/cowrie/
git clone http://github.com/cowrie/cowrie
cd /home/cowrie/cowrie
virtualenv --python=python3 cowrie-env
source cowrie-env/bin/activate
pip install --upgrade pip
pip install --upgrade -r requirements.txt
bin/cowrie start
EOF
# runs with cowrie.cfg.dist - will need tuning to specific usecase

echo "Mapping to TCP:22" >> /home/build.log
iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
echo "DONE" >> /home/build.log