# Helm

## Why Helm?

Helm is the package manager for Kubernetes. Raw Kubernetes manifests become hard to manage once an application grows past a handful of resources (Deployment, Service, ConfigMap, Secret, Ingress, HPA, etc.). Helm solves this by:

- Bundling all related manifests into a single unit called a **chart**.
- Allowing the same chart to be deployed differently across environments (dev/staging/prod) by swapping out **values** instead of editing YAML directly.
- Tracking every deployment as a **release**, with built-in versioning, rollback, and diffing.
- Providing a templating engine (Go templates) so manifests can be parameterized instead of duplicated.

In short: Kubernetes YAML is the compiled output, Helm charts are the source code.

---

## Charts

A chart is a directory with a standard structure:

```
mychart/
  Chart.yaml          # metadata: name, version, appVersion
  values.yaml         # default configuration values
  charts/             # sub-charts (dependencies) live here
  templates/          # Kubernetes manifest templates
    deployment.yaml
    service.yaml
    _helpers.tpl       # reusable template snippets
    NOTES.txt          # post-install usage notes shown to the user
```

Common chart commands:

```bash
# Scaffold a new chart with sensible defaults
helm create mychart

# Validate chart syntax and structure
helm lint mychart

# Render templates locally without installing (great for debugging)
helm template mychart

# Package a chart into a versioned .tgz for distribution
helm package mychart

# Search public chart repositories (e.g. Artifact Hub / added repos)
helm search repo prometheus
helm search hub grafana
```

---

## Templates

Templates live under `templates/` and use Go template syntax combined with Sprig functions. Values are injected via `{{ .Values.xxx }}`, chart metadata via `{{ .Chart.xxx }}`, and release info via `{{ .Release.xxx }}`.

Example snippet:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-{{ .Chart.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  template:
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
```

Debugging templates:

```bash
# Render templates and print the final YAML (does not talk to the cluster)
helm template myrelease mychart

# Render with a specific values file for verification
helm template myrelease mychart -f values-prod.yaml

# Show full computed values (defaults + overrides merged)
helm show values mychart
```

---

## Values

Values files define configuration inputs. `values.yaml` in the chart root defines defaults; these can be overridden at install/upgrade time.

```yaml
# values.yaml
replicaCount: 2
image:
  repository: myapp
  tag: latest
service:
  type: ClusterIP
  port: 80
```

Overriding values:

```bash
# Override with a custom values file (can be layered, later files win)
helm install myrelease mychart -f values-prod.yaml

# Override a single value inline
helm install myrelease mychart --set replicaCount=3

# Override nested values inline
helm install myrelease mychart --set image.tag=1.2.0

# Combine a file with inline overrides (inline --set wins over -f)
helm install myrelease mychart -f values-prod.yaml --set replicaCount=5
```

---

## Releases

A release is a specific deployed instance of a chart, tracked by Helm in the cluster (as Secrets by default in Helm 3).

```bash
# Install a chart as a new release
helm install myrelease mychart

# List all releases in the current namespace
helm list

# List releases across all namespaces
helm list -A

# Check release status
helm status myrelease

# Upgrade an existing release with new values or chart version
helm upgrade myrelease mychart -f values-prod.yaml

# Upgrade, or install if the release does not already exist
helm upgrade --install myrelease mychart

# View revision history for a release
helm history myrelease

# Roll back to a previous revision
helm rollback myrelease 1

# Uninstall a release (removes all associated resources)
helm uninstall myrelease
```

---

## Dependencies

Charts can depend on other charts (sub-charts), declared in `Chart.yaml`:

```yaml
# Chart.yaml
dependencies:
  - name: postgresql
    version: "12.x.x"
    repository: "https://charts.bitnami.com/bitnami"
```

Managing dependencies:

```bash
# Add a chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Refresh local repo cache
helm repo update

# Download dependencies into the charts/ directory
helm dependency update mychart

# List declared dependencies and their status
helm dependency list mychart
```

---

## Tasks

1. Install kube-prometheus-stack (Prometheus + Grafana) via Helm, then package one of my own applications (e.g. ShopHive backend/frontend) as a custom chart.

```bash
# Add and update the prometheus-community repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create a dedicated namespace for monitoring
kubectl create namespace monitoring

# Install the kube-prometheus-stack (Prometheus + Grafana + Alertmanager)
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring

# Confirm the release and check pod status
helm status monitoring -n monitoring
kubectl get pods -n monitoring

# Retrieve the auto-generated Grafana admin password
kubectl get secret monitoring-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode

# Port-forward to access Grafana locally
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
```

For packaging ShopHive as a custom chart:

```bash
# Scaffold the chart
helm create shophive-chart

# Remove the sample templates and replace with actual Deployment/Service/Ingress
# manifests adapted from existing k8s YAML, parameterized via values.yaml

# Validate before installing
helm lint shophive-chart
helm template shophive shophive-chart

# Install into a dev namespace
helm install shophive shophive-chart -n shophive --create-namespace
```

---

# References

- https://youtu.be/7A5cH8iqgHU?si=rihiedzlOVdHLUqG
- https://youtu.be/fy8SHvNZGeE?si=do2mINSgLSKUP2n2
- https://helm.sh/docs
