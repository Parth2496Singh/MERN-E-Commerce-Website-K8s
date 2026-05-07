#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
export KUBECONFIG=/root/.kube/config

install_docker(){

    if command -v docker >/dev/null 2>&1; then
        echo "Docker is already installed. Skipping installation."
        docker --version
        return
    fi

    echo "Docker not found. Installing Docker..."


    echo "Removing old Docker versions (if any)..."
    sudo apt remove -y docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc || true
    sudo apt autoremove -y || true

    echo "Updating system..."
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg git

    echo "Creating keyring..."
    sudo install -m 0755 -d /etc/apt/keyrings

    sudo rm -f /etc/apt/keyrings/docker.gpg

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg

    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo "Adding Docker repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo "Installing Docker..."
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Enabling Docker..."
    sudo systemctl enable docker
    sudo systemctl start docker

    echo "Waiting for Docker daemon..."
    until docker info >/dev/null 2>&1; do
        sleep 2
    done

    echo "Adding ubuntu user to docker group..."
    sudo groupadd docker || true
    sudo usermod -aG docker ubuntu
    sudo systemctl restart docker
}

install_kind(){
    if ! command -v kind &>/dev/null; then
        echo "📦 Installing Kind..."

    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
    elif [ "$ARCH" = "aarch64" ]; then
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-arm64
    else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
    fi

    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
    echo "✅ Kind installed successfully."
    else
    echo "✅ Kind is already installed."
    fi
}
install_kubectl(){

    if ! command -v kubectl &>/dev/null; then
        echo "📦 Installing kubectl (latest stable version)..."

        ARCH=$(uname -m)
        VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)

        if [ "$ARCH" = "x86_64" ]; then
            curl -Lo ./kubectl "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"
        elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
            curl -Lo ./kubectl "https://dl.k8s.io/release/${VERSION}/bin/linux/arm64/kubectl"
        else
            echo "❌ Unsupported architecture: $ARCH"
            exit 1
        fi

        chmod +x ./kubectl
        sudo mv ./kubectl /usr/local/bin/kubectl
        echo "✅ kubectl installed successfully."
    else
        echo "✅ kubectl is already installed."
    fi
}


cluster_create(){

    if kind get clusters | grep -q "mycluster"; then
        echo "✅ Kind cluster already exists."
        return
    fi
    curl -LO https://raw.githubusercontent.com/Parth2496Singh/MERN-E-Commerce-Website-K8s/main/k8s/cluster-configure.yml
    kind create cluster --name=mycluster --config=cluster-configure.yml

    echo "Waiting for Kubernetes API..."

    until kubectl cluster-info >/dev/null 2>&1; do
        sleep 5
    done
    echo "Kubernetes API ready."
    mkdir -p /home/ubuntu/.kube
    cp /root/.kube/config /home/ubuntu/.kube/config
    chown -R ubuntu:ubuntu /home/ubuntu/.kube

    kubectl create clusterrolebinding kubernetes-admin-binding \
        --clusterrole=cluster-admin \
        --user=kubernetes-admin || true
}

install_ingress_nginx(){
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
}
install_metrics_server(){
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml && \
    kubectl patch deployment metrics-server -n kube-system --type='json' \
    -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"},{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-preferred-address-types=InternalIP,Hostname,ExternalIP"}]' && \
    kubectl rollout restart deployment metrics-server -n kube-system
}

install_helm(){
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
    chmod 700 get_helm.sh
    ./get_helm.sh
}
deploy_project(){
    if [ -d "MERN-E-Commerce-Website-K8s" ]; then
        echo "Repo exists → pulling latest changes"
        cd MERN-E-Commerce-Website-K8s
        git pull
    else
        git clone https://github.com/Parth2496Singh/MERN-E-Commerce-Website-K8s.git
        cd MERN-E-Commerce-Website-K8s
    fi

    cd k8s
    kubectl apply -f namespace.yml
    kubectl apply -f .
    kubectl port-forward service/ingress-nginx-controller -n ingress-nginx 8080:80 --address=0.0.0.0 &

}

deploy_monitoring(){
    kubectl create ns monitoring
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    --set prometheus.service.nodePort=30000 \
    --set grafana.service.nodePort=31000 \
    --set prometheus.service.type=NodePort \
    --set grafana.service.type=NodePort
    kubectl port-forward svc/prometheus-stack-kube-prom-prometheus -n monitoring 9090:9090 --address=0.0.0.0 &
    kubectl port-forward svc/prometheus-stack-grafana -n monitoring 3000:80 --address=0.0.0.0 &
}

main(){

    install_docker
    install_kind
    install_kubectl
    cluster_create
    install_ingress_nginx
    install_metrics_server
    install_helm
    deploy_project
    deploy_monitoring

}

main

rm -f cluster-configure.yml
rm -f get_helm.sh


