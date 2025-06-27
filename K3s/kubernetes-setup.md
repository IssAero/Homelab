Setting up Kubernetes using K3s:

    🛠️ Step-by-Step Installation (Single Node)

    1. Update the system -->
    sudo apt update && sudo apt upgrade -y  #for Debian/Ubuntu
    <!-- # or -->
    sudo yum update -y  #for RHEL/CentOS

    <!-- 2. Install K3s (as root or with sudo) -->
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik --flannel-backend=none" sh -

    <!-- 3. Check K3s status -->
    sudo systemctl status k3s
    
    <!-- 4. install K3s on additional nodes -->
    curl -sfL https://get.k3s.io | K3S_URL=https://<SERVER_IP>:6443 K3S_TOKEN=<NODE_TOKEN> sh -

        <!-- 4.1. Get the server_ip -->
        ip a | grep inet

        <!-- 4.2. Get the node_token -->
        sudo cat /var/lib/rancher/k3s/server/node-token

    <!-- 5. Verify it's running -->
    sudo k3s kubectl get nodes

    <!-- 6. Installing Helm -->
    wget https://get.helm.sh/helm-v3.18.3-linux-amd64.tar.gz && tar -zxvf helm-v3.18.3-linux-amd64.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm

    <!-- 7. Install Calico -->
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/calico.yaml

    <!-- 8. Labeling Nodes -->
    Labeling each node for specific role:
    kubectl label node <media-node> role=mediakubectl get pods -n kube-system | grep calico
    kubectl label node <cloud-node> role=cloud
    kubectl label node <monitor-node> role=network

    <!-- 9. Install ingress-Nginx -->
    helm upgrade --install ingress-nginx ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    --namespace ingress-nginx --create-namespace \
    --set controller.nodeSelector."kubernetes\.io/hostname"=monitoring-node


    <!-- That’s it! 🎉 You now have a Kubernetes cluster running.


