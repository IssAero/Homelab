# Installing Kubernetes
Before starting to install the ARR Stack, we first need to have a Kubernetes Cluster running - I've chosen K3s as my desired Kubernetes distro due to its low overhead, but you can use whichever you want.
After many hours lost on getting familiar with the commands, seeing what needs to be enabled and disabled, and many installs and uninstalls, I've nailed the process down to the following steps:

### 🛠️ Step-by-Step Installation (Control Node)
1. Update the system:
```
sudo apt update && sudo apt upgrade -y  #for Debian/Ubuntu
<!-- # or -->
sudo yum update -y  #for RHEL/CentOS
```
2. Install K3s (as root or with sudo):
```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik --flannel-backend=none" sh -
```
3. Check K3s status:
```
sudo systemctl status k3s
```
4. install K3s on additional nodes:
```
⚠️ Get the SERVER_IP and NODE_TOKEN (run this on the control node) ⚠️
ip a | grep inet
sudo cat /var/lib/rancher/k3s/server/node-token

Run this on the worker node:
curl -sfL https://get.k3s.io | K3S_URL=https://<SERVER_IP>:6443 K3S_TOKEN=<NODE_TOKEN> sh -
```
5. Verify the nodes are connected and running:
```
sudo k3s kubectl get nodes
```
6. Installing Helm Package Manager:
```
wget https://get.helm.sh/helm-v3.18.3-linux-amd64.tar.gz && tar -zxvf helm-v3.18.3-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
```
7. Install Calico
```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/calico.yaml
```
8. 🏷️Labeling each node for specific role (optional):
```
kubectl label node <media-node> role=mediakubectl get pods -n kube-system | grep calico
kubectl label node <cloud-node> role=cloud
kubectl label node <monitor-node> role=network
```
9. Install ingress-Nginx (--set nodeSelector is optional, I wanted to only deploy this on a certain node)
```
helm upgrade --install ingress-nginx ingress-nginx \
--repo https://kubernetes.github.io/ingress-nginx \
--namespace ingress-nginx --create-namespace \
--set controller.nodeSelector."kubernetes\.io/hostname"=monitoring-node
```
10. Install Longhorn
```
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.8.1/deploy/longhorn.yaml
```
### That’s it! 🎉 You now have a Kubernetes cluster running.
