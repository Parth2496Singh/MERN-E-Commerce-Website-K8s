# 🛒 MERN E-Commerce Store — Kubernetes Deployment

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)


Production-grade Kubernetes deployment of a full-stack MERN application using MongoDB StatefulSet, Ingress, and Autoscaling.

---

## 📌 Overview



This repository contains the complete Kubernetes deployment setup for a full-stack MERN-based e-commerce application. It demonstrates a production-style cloud-native deployment using Docker, Kubernetes, and Ingress for scalable and reliable service orchestration.

* **Application Code:** The MERN e-commerce application (React frontend, Node.js/Express backend, and MongoDB database integration) was developed by [HuXn-WebDev](https://github.com/HuXn-WebDev).
* **My Contribution:** I designed and implemented the complete DevOps lifecycle for this project. All Docker configurations, Kubernetes manifests (Namespaces, Deployments, Services, StatefulSet, HPA), Ingress routing setup, and Kubernetes Secrets management were authored and configured by me to demonstrate production-grade cloud-native deployment practices.

It includes:
- Frontend (React + Nginx)
- Backend (Node.js + Express)
- Database (MongoDB StatefulSet)
- Ingress routing
- Kubernetes Secrets
- Horizontal Pod Autoscaler

---

## 🧠 Architecture


User requests go through Ingress Controller.

Frontend Service handles UI requests.

Backend Service handles API requests.

MongoDB StatefulSet stores persistent data.

---

## 🛠️ Tech Stack

| Layer | Technology |
|------|------------|
| Frontend | React, Nginx |
| Backend | Node.js, Express |
| Database | MongoDB |
| Orchestration | Kubernetes |
| Containerization | Docker |
| Networking | Ingress NGINX |
| Security | Kubernetes Secrets |

---

## 🚀 Deployment Steps

### 1. Create Namespace

kubectl create namespace mern-ecommerce

---

### 2. Deploy All Resources

kubectl apply -f k8s/

This includes:
Frontend Deployment  
Backend Deployment  
MongoDB StatefulSet  
Secrets  
Ingress  

---

### 3. Verify Deployment

kubectl get all -n mern-ecommerce

---

### 4. Access Application

kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80

Open in browser:

http://localhost:8080

---

## 🔐 Secrets

MongoDB username is stored as: mongoadmin  

Password is stored in Kubernetes Secrets (base64 encoded)

JWT secret is also stored securely in Secrets

---

## 📈 Autoscaling

kubectl get hpa -n mern-ecommerce

Minimum Pods: 2  
Maximum Pods: 5  
CPU Target: 75 percent  

---

## 🌐 API Routes

Frontend route: /  
Backend route: /api/*  

---

## 🧪 API Endpoints

GET /api/products  
GET /api/users  
POST /api/users/login  

---

## 🐳 Docker Images

Frontend image: parthsingh2496/mern-frontend  
Backend image: parthsingh2496/mern-backend  

---

## ⚠️ Known Behavior

Database starts empty  
JWT authentication required  
Admin users must be created manually  

---

## 📊 Project Highlights

Kubernetes microservices architecture  
Stateful MongoDB deployment  
Ingress-based routing  
Secrets management  
Horizontal scaling with HPA  
Production-ready DevOps setup  

---

## 🚀 Future Improvements

Add HTTPS using cert-manager  
Add CI/CD pipeline using GitHub Actions  
Add Helm charts  
Add monitoring with Prometheus and Grafana  
Add custom domain routing  

---

## 🧠 Author Note

This project demonstrates real-world DevOps practices using Kubernetes, Docker, and a full-stack MERN application deployed in a cloud-native environment.
