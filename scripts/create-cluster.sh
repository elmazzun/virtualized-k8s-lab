#!/bin/bash

echo 'export PATH="/home/vagrant/kubernetes/third_party/etcd:${PATH}"' >> /home/vagrant/.profile
echo 'export PATH="/home/vagrant/kubernetes/third_party/etcd:${PATH}"' >> /home/vagrant/.bashrc

echo 'export PATH="$GOPATH/src/k8s.io/kubernetes/third_party/etcd:${PATH}"' >> /home/vagrant/.profile
echo 'export PATH="$GOPATH/src/k8s.io/kubernetes/third_party/etcd:${PATH}"' >> /home/vagrant/.bashrc

cd /home/vagrant/kubernetes
./hack/install-etcd.sh

echo 'export CONTAINER_RUNTIME_ENDPOINT="unix:///run/containerd/containerd.sock"' >> /home/vagrant/.profile
echo 'export CONTAINER_RUNTIME_ENDPOINT="unix:///run/containerd/containerd.sock"' >> /home/vagrant/.bashrc

./hack/local-up-cluster.sh -O

# https://github.com/kubernetes/community/blob/master/contributors/devel/running-locally.md#container-runtime
echo 'export KUBECONFIG=/var/run/kubernetes/admin.kubeconfig'  >> /home/vagrant/.profile
echo 'export KUBECONFIG=/var/run/kubernetes/admin.kubeconfig'  >> /home/vagrant/.bashrc

./cluster/kubectl.sh get pods
