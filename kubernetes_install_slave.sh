#!/bin/bash

if [ ! -f /var/lib/kubelet/config.yaml ]; then

    # bridge control
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
    sudo sysctl --system


    sudo apt-get update && sudo apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl socat ipvsadm
    sudo apt-mark hold kubelet kubeadm kubectl

    # join to master
    echo "This does not auto joins to master.  Use the join token as mentioned in https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/"
fi