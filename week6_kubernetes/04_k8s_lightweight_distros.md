# Lightweight Kubernetes Distributions

Standard Kubernetes (kubeadm-based, full control plane) is heavy for local development, CI, or edge/IoT deployments. Several lightweight distributions trade off features, portability, or maturity to fit these use cases. Below is a comparison along with setup and basic usage commands for each.

---

## Minikube

The original local Kubernetes tool. Single-node only, runs the cluster inside a VM or container driver (Docker, VirtualBox, etc.). Best for local development and learning; not intended for production or multi-node testing.

```bash
# Install (macOS example; see docs for Linux/Windows)
brew install minikube

# Start a cluster using the Docker driver
minikube start --driver=docker

# Check cluster status
minikube status

# Access the Kubernetes dashboard
minikube dashboard

# Enable an addon (e.g. ingress controller)
minikube addons enable ingress

# Point local Docker CLI at Minikube's Docker daemon (build images directly into the cluster)
eval $(minikube docker-env)

# Stop and delete the cluster
minikube stop
minikube delete
```

---

## kind (Kubernetes IN Docker)

Runs Kubernetes nodes as Docker containers rather than VMs. Supports multi-node clusters (control-plane + workers) on a single machine, making it well suited for testing cluster topology, upgrades, and CI pipelines. Local development and testing only, not for production.

```bash
# Install
go install sigs.k8s.io/kind@latest

# Create a default single-node cluster
kind create cluster

# Create a multi-node cluster from a config file
cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
EOF
kind create cluster --config kind-config.yaml

# List clusters
kind get clusters

# Load a locally built image into the cluster (no registry push needed)
kind load docker-image myapp:latest

# Delete the cluster
kind delete cluster
```

---

## MicroK8s

Canonical's lightweight Kubernetes distribution, distributed as a snap package. Linux-only (snap dependency). Positioned as production-ready with minimal footprint, supports clustering (HA) and a wide addon ecosystem (DNS, storage, ingress, Istio, etc.).

```bash
# Install via snap
sudo snap install microk8s --classic

# Add current user to the microk8s group (avoids needing sudo for every command)
sudo usermod -aG microk8s $USER
newgrp microk8s

# Check status until it reports "running"
microk8s status --wait-ready

# Enable common addons
microk8s enable dns storage ingress

# Use the bundled kubectl
microk8s kubectl get nodes

# Alias for convenience
alias kubectl='microk8s kubectl'

# Stop / start the cluster
microk8s stop
microk8s start
```

---

## k3s / k3d

**k3s** is a certified, lightweight Kubernetes distribution packaged as a single binary (under 100MB), with reduced dependencies (no cloud provider integrations, uses SQLite by default instead of etcd for single-node setups). Designed for edge, IoT, and resource-constrained environments, but also usable in production.

**k3d** wraps k3s to run it inside Docker containers, similar to how kind wraps upstream Kubernetes — useful for quickly spinning up local k3s clusters.

```bash
# --- k3s (installs directly on a Linux host/VM) ---
curl -sfL https://get.k3s.io | sh -

# Check node status
sudo k3s kubectl get nodes

# Retrieve kubeconfig for use with a local kubectl
sudo cat /etc/rancher/k3s/k3s.yaml

# --- k3d (k3s inside Docker, for local dev/testing) ---
# Install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Create a cluster with one server and two agents
k3d cluster create mycluster --servers 1 --agents 2

# List clusters
k3d cluster list

# Delete a cluster
k3d cluster delete mycluster
```

---

## k0s

Distributed as a single, self-contained binary with zero host OS dependencies (no snap, no external etcd required for basic setups). Designed for portability across edge and IoT environments. Younger project, smaller ecosystem and community compared to k3s/MicroK8s, so maturity and long-term support should be weighed before production use.

```bash
# Download and install the k0s binary
curl -sSLf https://get.k0s.sh | sudo sh

# Install as a single-node cluster (controller + worker combined)
sudo k0s install controller --single
sudo k0s start

# Check status
sudo k0s status

# Generate a kubeconfig for kubectl access
sudo k0s kubeconfig admin > kubeconfig.yaml
export KUBECONFIG=kubeconfig.yaml
kubectl get nodes

# Stop the cluster
sudo k0s stop
```

---

## Comparison Summary

| Distribution | Node topology | Platform | Production ready | Best fit |
|---|---|---|---|---|
| Minikube | Single node | Cross-platform (VM/container driver) | No | Local development, learning |
| kind | Multi-node (containers) | Cross-platform (needs Docker) | No | CI, local multi-node testing |
| MicroK8s | Single or multi-node (HA) | Linux only (snap) | Yes | Production, edge, general use |
| k3s / k3d | Single or multi-node | Linux (k3s), Docker (k3d) | Yes (k3s) | Edge, IoT, lightweight production |
| k0s | Single or multi-node | Cross-platform, no host deps | Not yet mature | Edge, IoT, air-gapped environments |

---

# References

- https://youtu.be/wUpsSXQr73M?si=I8kYYWKvgggy90_H
- https://www.baeldung.com/ops/kubernetes-lightweight-distributions
- https://canonical.com/microk8s/compare
- https://minikube.sigs.k8s.io/docs/
