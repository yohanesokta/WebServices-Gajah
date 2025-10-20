cd resource/linux

wget https://github.com/containerd/containerd/releases/download/v2.0.0/containerd-2.0.0-linux-amd64.tar.gz -O containerd-2.0.0-linux-amd64.tar.gz
tar -xzvf containerd-2.0.0-linux-amd64.tar.gz

wget https://github.com/containernetworking/plugins/releases/download/v1.0.1/cni-plugins-linux-amd64-v1.0.1.tgz
mkdir cni
tar Cxzvvf ./cni cni-plugins-linux-amd64-v1.0.1.tgz

wget https://github.com/containerd/nerdctl/releases/download/v0.17.0/nerdctl-0.17.0-linux-amd64.tar.gz
mkdir nerdctl
tar Cxzvvf ./nerdctl nerdctl-0.17.0-linux-amd64.tar.gz


# Cara running

export PATH="$PATH:$(pwd)/resource/linux/bin"
export PATH="$PATH:$(pwd)/resource/linux/cni"
export PATH="$PATH:$(pwd)/resource/linux/nerdctl"

sudo mkdir -p /opt/cni
root@YohanesLinux:/home/yohanesokta/Documents/Code/WebServices-Gajah# sudo ln -sfn $(pwd)/resource/linux/cni /opt/cni/bin
