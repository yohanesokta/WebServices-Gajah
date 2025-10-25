# DOWNLOADING RUNTIMES
wget https://github.com/containerd/containerd/releases/download/v2.0.0/containerd-2.0.0-linux-amd64.tar.gz -O containerd-2.0.0-linux-amd64.tar.gz
sudo mkdir -p /opt/gajah/containerd
sudo tar Cxzvvf /opt/gajah/containerd containerd-2.0.0-linux-amd64.tar.gz

wget https://github.com/containernetworking/plugins/releases/download/v1.0.1/cni-plugins-linux-amd64-v1.0.1.tgz
sudo mkdir -p /opt/cni/bin/
sudo tar Cxzvvf /opt/cni/bin cni-plugins-linux-amd64-v1.0.1.tgz

wget https://github.com/containerd/nerdctl/releases/download/v0.17.0/nerdctl-0.17.0-linux-amd64.tar.gz
sudo mkdir /opt/gajah/nerdctl
sudo tar Cxzvvf /opt/gajah/nerdctl nerdctl-0.17.0-linux-amd64.tar.gz

wget https://github.com/opencontainers/runc/releases/download/v1.4.0-rc.2/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc

wget https://github.com/moby/buildkit/releases/download/v0.25.1/buildkit-v0.25.1.linux-amd64.tar.gz
sudo mkdir -p /opt/gajah/buildkit
sudo tar Cxzvvf /opt/gajah/buildkit buildkit-v0.25.1.linux-amd64.tar.gz

# MAKE SYSTEMD SERVICE

sudo cp ./resource/linux/gbuildkit.service /usr/local/lib/systemd/system/
sudo cp ./resource/linux/gbuildkit.socket /usr/local/lib/systemd/system/
sudo cp ./resource/linux/gcontainerd.service /usr/local/lib/systemd/system/

sudo systemctl enable --now gbuildkit
sudo systemctl enable --now gcontainerd
