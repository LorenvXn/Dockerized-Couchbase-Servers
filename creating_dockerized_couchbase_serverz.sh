#!/bin/bash
touch script.sh
chmod +x script.sh
cat> script.sh <<EOF

echo "[dockerrepo]"
echo "name=Docker Repository"
echo "baseurl=https://yum.dockerproject.org/repo/main/centos/`awk -v RS=[0-9]+ '
{print RT+0;exit}' <<< echo "/etc/redhat-release"`"
echo "enabled=1"
echo "gpgchek=1"
echo "gpgkey=https://yum.dockerproject.org/gpg"
EOF

./script.sh &> /etc/yum.repos.d/docker.repo
printf "\n"
echo "Configuration starting....."
echo ".............Docker repo setup.............."
cat /etc/yum.repos.d/docker.repo
printf "\n"
echo ".......Installing package and starting docker service............."
sudo yum install docker-engine
service docker start

echo ".......................Docker status........................"
service docker status

echo ">>>>>>Download couchbase package on physical machine<<<<<"
curl -O
http://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-1-x86_64.rpm

rpm -i couchbase-release-1.0-1-x86_64.rpm
echo "...............create docker cb1 couchbase.........."
docker run -d --name cb3 couchbase
echo "...............create docker cb2 couchbase.........."
docker run -d --name cb2 couchbase 


echo ".................check cb3 IP address docker....................."
docker inspect cb3 | grep IPAddress | awk 'NR==1 {print $NF}' | cut -f1 -d ','
echo ".................check cb2 IP address docker....................."
docker inspect cb2 | grep IPAddress | awk 'NR==1 {print $NF}' | cut -f1 -d ','

