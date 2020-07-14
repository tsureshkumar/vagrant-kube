sudo apt update
# don't use snap for docker.  kubeneretes does not work and gives AppArmor policy errors
#sudo snap install docker
sudo apt install docker.io socat

sudo useradd -m docker-user
sudo groupadd docker
sudo usermod -aG docker docker-user

# ubuntu running dockerd with cgroups is conflicting with systemd cgroup management
# change it to systemd
sudo mkdir -p /etc/systemd/system/docker.service.d || :
cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --exec-opt native.cgroupdriver=systemd
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

