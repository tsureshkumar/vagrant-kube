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

    # creates a single node cluster
    sudo kubeadm init --apiserver-advertise-address 10.5.121.15 | tee ~/.kubeadm.log

    #kubeconf
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
    for i in 1 2 3 4 5; do
        kubectl get pods --all-namespaces # to check that all calico pods are running
        kubectl get nodes # master node should be ready now
        sleep 30s
    done
    kubectl taint nodes --all node-role.kubernetes.io/master- # so that master nodes can run workloads

fi
