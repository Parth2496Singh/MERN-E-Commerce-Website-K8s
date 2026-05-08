# 🛒 MERN E-Commerce Store — Production-Style Kubernetes Deployment with AWS EKS Exposure

Production-style Kubernetes deployment of a full-stack MERN e-commerce application featuring containerized services, MongoDB StatefulSet, Ingress-based routing, autoscaling, observability, and cloud-native infrastructure practices.

## 📌 Overview
This repository contains the complete Kubernetes infrastructure and deployment setup for a MERN-based e-commerce application. 

The project focuses on real-world DevOps concepts including:
- Kubernetes orchestration
- Stateful application deployment
- Ingress networking
- Horizontal autoscaling
- Monitoring & observability
- Secrets management
- Containerized workloads

## 👨‍💻 Project Ownership

### Application Code
The original MERN e-commerce application (React frontend, Node.js/Express backend, MongoDB integration) was developed by [HuXn-WebDev](https://github.com/HuXn-WebDev/MERN-E-Commerce-Store).

### My Contribution
I designed and implemented the complete DevOps and Kubernetes deployment workflow for this project, including:
- Docker containerization
- Kubernetes manifests
- MongoDB StatefulSet deployment
- Persistent storage configuration
- Ingress routing
- Horizontal Pod Autoscaler (HPA)
- Kubernetes Secrets management
- Monitoring stack integration using Prometheus & Grafana
- Helm-based deployment packaging

## 🏛️ Architecture
The application follows a 3-tier architecture deployed on Kubernetes.

                        User Traffic
                              │
                              ▼
                    NGINX Ingress Controller
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
        Frontend Service                Backend Service
          (React + NGINX)              (Node.js + Express)
                                                  │
                                                  ▼
                                        MongoDB StatefulSet
                                                  │
                                                  ▼
                                      Persistent Volume Storage

## ✨ Features
- ✅ Kubernetes-based 3-tier deployment
- ✅ React frontend containerized with Docker
- ✅ Node.js backend deployment with Kubernetes
- ✅ MongoDB deployed using StatefulSet
- ✅ Persistent storage using PV & PVC
- ✅ Ingress-based traffic routing
- ✅ Horizontal Pod Autoscaler (HPA)
- ✅ Kubernetes Secrets for sensitive configuration
- ✅ Monitoring stack using Prometheus & Grafana
- ✅ Helm-based deployment support
- ✅ Namespace isolation for application and monitoring stack

## 🛠️ Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Frontend** | React, NGINX |
| **Backend** | Node.js, Express |
| **Database** | MongoDB |
| **Containerization** | Docker |
| **Orchestration** | Kubernetes |
| **Networking** | Ingress NGINX |
| **Monitoring** | Prometheus, Grafana |
| **Packaging** | Helm |
| **Scaling** | Horizontal Pod Autoscaler |
| **Storage** | Persistent Volumes & PVC |
| **Security** | Kubernetes Secrets |

## ☸️ Kubernetes Components Used

| Component | Purpose |
| :--- | :--- |
| **Namespace** | Logical isolation of workloads |
| **Deployment** | Stateless application management |
| **StatefulSet** | Persistent MongoDB deployment |
| **Service** | Internal networking between components |
| **Ingress** | External traffic routing |
| **Secret** | Secure storage of credentials |
| **HPA** | Automatic scaling based on CPU usage |
| **PV/PVC** | Persistent database storage |

## 📂 Project Structure

    .
    ├── backend/
    ├── frontend/
    ├── k8s/
    │   ├── frontend/
    │   ├── backend/
    │   ├── database/
    │   ├── ingress/
    │   ├── monitoring/
    │   └── namespace.yaml
    ├── mern-helm/
    ├── .gitignore
    ├── Automatic-deploy.sh
    ├── ec2-bootstrap.sh
    ├── example-env.env
    ├── mern-helm-0.1.0.tgz
    ├── package-lock.json
    ├── package.json
    ├── thumb.png
    └── README.md

## 🚀 Deployment Guide

You can deploy this application using either **Helm** (recommended for ease of use) or standard **Kubernetes Manifests**.

### 🛳️ Option A: Deploy via Helm (Recommended)
Helm simplifies the deployment process by packaging all resources together. To deploy the entire application in one command, run:

    helm install dev-mern-helm mern-helm -n mern-ecommerce --create-namespace

### ☸️ Option B: Deploy via Standard Manifests

**1️⃣ Create Namespace**
    kubectl create namespace mern-ecommerce

**2️⃣ Deploy Kubernetes Resources**
    kubectl apply -f k8s/

*This deploys:*
- Frontend Deployment & Service
- Backend Deployment & Service
- MongoDB StatefulSet
- Persistent Volume & PVC
- Kubernetes Secrets
- Ingress Resources
- Horizontal Pod Autoscaler

---

### 3️⃣ Verify Cluster Resources
    kubectl get all -n mern-ecommerce

### 🌐 Access Application
**Start Ingress Port Forward:**
    kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80

Then open: [http://localhost:8080](http://localhost:8080)
## ⚡ Automated Provisioning & Cloud Bootstrap

To streamline the infrastructure setup, this repository includes automation scripts for zero-touch provisioning.

### 1. One-Click Deployment (`Automatic-deploy.sh`)
This script automates the complete environment setup on a fresh Linux instance. It handles the following operations:
- **Dependency Installation:** Automatically installs Docker, Kind, Kubectl, and Helm.
- **Cluster Provisioning:** Creates a local Kubernetes cluster named `mycluster`.
- **Core Add-ons:** Deploys the NGINX Ingress Controller and Metrics Server (required for HPA).
- **Application Deployment:** Clones the repository and applies all Kubernetes manifests for the MERN stack.
- **Observability:** Deploys the `kube-prometheus-stack` via Helm into the `monitoring` namespace.
- **Network Access:** Configures automatic port-forwarding for the application, Grafana, and Prometheus to `0.0.0.0`.

**Usage:**
```bash
bash <(curl -s [https://raw.githubusercontent.com/Parth2496Singh/MERN-E-Commerce-Website-K8s/main/Automatic-deploy.sh](https://raw.githubusercontent.com/Parth2496Singh/MERN-E-Commerce-Website-K8s/main/Automatic-deploy.sh))
```
 ### ☁️ 2. AWS EC2 Bootstrap (`ec2-bootstrap.sh`)
-  Designed specifically for cloud environments, this script is intended to be passed as **User Data** when launching a fresh AWS EC2 instance.
-  Updates system packages and installs foundational tools (`curl`, `git`).
-  Automatically downloads and executes the `Automatic-deploy.sh` script.
- **Result:** The EC2 instance boots up with the entire Kubernetes infrastructure, application, and monitoring stack fully deployed and operational, requiring zero manual SSH intervention.

## 📊 Monitoring & Observability
The project includes monitoring integration using:
- **Prometheus** for metrics collection
- **Grafana** for visualization and dashboards

### Install Monitoring Stack
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update

    helm install prometheus-stack prometheus-community/kube-prometheus-stack \
      --namespace monitoring \
      --create-namespace

### Access Prometheus
    kubectl port-forward svc/prometheus-stack-kube-prom-prometheus -n monitoring 9090:9090 &

Open: [http://localhost:9090](http://localhost:9090)

### Access Grafana
    kubectl port-forward svc/prometheus-stack-grafana -n monitoring 3000:80 &

Open: [http://localhost:3000](http://localhost:3000)

## 📈 Horizontal Pod Autoscaling
The backend service is configured with a Horizontal Pod Autoscaler.

**Check HPA Status:**
    kubectl get hpa -n mern-ecommerce

**Scaling Configuration:**

| Setting | Value |
| :--- | :--- |
| Minimum Replicas | 2 |
| Maximum Replicas | 5 |
| CPU Utilization Threshold | 75% |

## 🔐 Secrets Management
Sensitive application configuration is managed using Kubernetes Secrets, including:
- MongoDB credentials
- Backend environment variables
- JWT secret keys

## 🧪 API Routes

| Route | Purpose |
| :--- | :--- |
| `/` | Frontend Application |
| `/api/*` | Backend API |

## 🐳 Docker Images

| Service | Image |
| :--- | :--- |
| **Frontend** | parthsingh2496/mern-frontend |
| **Backend** | parthsingh2496/mern-backend |

## 🧠 Key Learnings
This project helped me gain hands-on experience with:
- Kubernetes workload management
- Stateful vs stateless applications
- Ingress networking and traffic routing
- Persistent storage in Kubernetes
- Horizontal autoscaling concepts
- Monitoring and observability
- Kubernetes debugging workflows
- Secrets management
- Helm-based application packaging

## ⚠️ Current Limitations
- HTTPS/TLS not yet configured
- CI/CD pipeline not yet integrated
- Health probes still pending implementation
- Monitoring dashboards can be further customized

## 🛑 Critical Infrastructure Challenge: Disk Exhaustion

* **The Problem:** Pods perpetually failed with `ImagePullBackOff` and `ErrImagePull`. Deep inspection of the container logs revealed a fatal `no space left on device` error in the containerd overlay filesystem.
* **The Cause:** Running Kubernetes via `Kind` means running an entire cluster node *inside* a single Docker container. Pulling heavy Node.js and MongoDB images into this nested architecture rapidly exhausted the default 8GB AWS EC2 root volume.
* **The Fix:** Upgraded the underlying EC2 EBS volume beyond the free-tier 8GB limit to safely accommodate the massive storage overhead of Docker-in-Docker Kubernetes virtualization.

* ## ☁️ AWS EKS Deployment Exposure

As part of extending this project beyond local Kubernetes environments, the application was also deployed on Amazon EKS to gain hands-on exposure to managed Kubernetes infrastructure on AWS.

Key concepts explored during the deployment process:

- EKS cluster provisioning using eksctl
- Worker node management
- Docker image push workflow using Amazon ECR
- Kubernetes LoadBalancer services on AWS
- Persistent storage provisioning using EBS CSI Driver
- MongoDB StatefulSet deployment on EKS
- Prometheus & Grafana monitoring setup
- IAM/OIDC integration exposure
- Kubernetes troubleshooting in cloud environments

  <img width="2867" height="1334" alt="Screenshot from 2026-05-09 01-33-12" src="https://github.com/user-attachments/assets/b01642b7-8bda-4931-9581-35579d84b799" />


This deployment was primarily focused on practical learning and infrastructure understanding rather than production-grade optimization.

## 🚀 Future Improvements
- [ ] Implement CI/CD using GitHub Actions
- [ ] Add readiness & liveness probes
- [ ] Configure HTTPS using cert-manager
- [ ] Deploy on AWS EKS
- [ ] Implement GitOps using ArgoCD
- [ ] Add centralized logging stack
- [ ] Improve Grafana dashboards
- [ ] Add OpenTelemetry instrumentation

## 📸 Screenshots

- Kubernetes Pods Running
  <img width="2647" height="1330" alt="Screenshot from 2026-05-07 12-46-53" src="https://github.com/user-attachments/assets/c63ff536-5114-403e-aaaf-810ce6abb9a0" />

- Grafana Dashboard
  <img width="2875" height="1262" alt="Screenshot from 2026-05-07 12-55-40" src="https://github.com/user-attachments/assets/a08c2100-1aad-441c-bc9f-8a3bce5a35a0" />

<img width="2875" height="1547" alt="Screenshot from 2026-05-07 12-56-47" src="https://github.com/user-attachments/assets/5d374884-5919-4228-b06c-d771893ff776" />


## 🧭 DevOps Focus
This project primarily focuses on:
- Infrastructure deployment
- Kubernetes orchestration
- Scalability
- Reliability
- Monitoring
- Cloud-native operational practices

## 📄 License
This project is intended for educational and learning purposes.
