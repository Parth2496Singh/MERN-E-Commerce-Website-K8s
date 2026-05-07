#!/bin/bash
set -e

echo "Updating system..."
apt update -y
apt install -y curl git

echo "Running deployment script from GitHub..."

bash <(curl -s https://raw.githubusercontent.com/Parth2496Singh/MERN-E-Commerce-Website-K8s/main/Automatic-deploy.sh)