# Kubernetes Objects

This document covers the core Kubernetes objects grouped by category: workloads, networking, configuration, storage, security, scheduling, health checks, scaling, extensions, observability, GitOps/IaC concepts, cluster operations (HA, disaster recovery, service discovery, upgrades), the broader Kubernetes ecosystem, and cloud-managed Kubernetes (EKS) concepts.

---

## Workloads

### Pod

A Pod is the smallest deployable unit in Kubernetes. It represents one or more tightly coupled containers that share the same network namespace (same IP, same `localhost`) and can share storage volumes. Pods are ephemeral — when a pod dies, it is not resurrected; a higher-level controller (ReplicaSet, Deployment, etc.) is responsible for creating a replacement.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
    - name: nginx
      image: nginx:1.27
      ports:
        - containerPort: 80
```

```bash
kubectl run nginx-pod --image=nginx:1.27
kubectl get pods
kubectl describe pod nginx-pod
kubectl logs nginx-pod
kubectl exec -it nginx-pod -- /bin/sh
kubectl delete pod nginx-pod
```

### ReplicaSet

A ReplicaSet ensures a specified number of identical pod replicas are running at all times. It uses a label selector to identify which pods it manages, and will create or delete pods to match the desired `replicas` count. In practice, ReplicaSets are rarely created directly — Deployments manage them automatically.

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.27
```

### Deployment

A Deployment is a higher-level controller that manages ReplicaSets, providing declarative updates, rolling updates, and rollback capability for stateless applications. It is the most commonly used workload object for stateless services.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.27
          ports:
            - containerPort: 80
```

```bash
kubectl apply -f deployment.yaml
kubectl rollout status deployment/nginx-deployment
kubectl set image deployment/nginx-deployment nginx=nginx:1.28
kubectl rollout undo deployment/nginx-deployment
kubectl scale deployment/nginx-deployment --replicas=5
```

### StatefulSet

A StatefulSet manages stateful applications, providing stable, unique network identities and stable persistent storage for each pod. Unlike Deployments, pods in a StatefulSet are created in order (pod-0, pod-1, pod-2...), retain a stable hostname, and are bound to the same PersistentVolumeClaim across restarts. Used for databases, message queues, and other apps that need stable identity (e.g., PostgreSQL, Kafka, Elasticsearch).

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:16
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
```

### DaemonSet

A DaemonSet ensures that a copy of a pod runs on every node (or a selected subset of nodes) in the cluster. It is typically used for node-level agents such as log collectors (Fluentd), monitoring agents (Node Exporter), or network plugins (Calico, Cilium).

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
    spec:
      containers:
        - name: node-exporter
          image: prom/node-exporter
```

### Job

A Job creates one or more pods to run a task to completion, then stops. It is used for one-off or batch tasks such as database migrations or data processing, as opposed to long-running services.

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migration
spec:
  template:
    spec:
      containers:
        - name: migrate
          image: myapp:latest
          command: ["python", "manage.py", "migrate"]
      restartPolicy: Never
  backoffLimit: 4
```

### CronJob

A CronJob creates Jobs on a repeating schedule, using standard cron syntax. It is used for scheduled, recurring tasks such as backups, report generation, or cleanup scripts.

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: nightly-backup
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: backup
              image: backup-tool:latest
          restartPolicy: OnFailure
```

---

## Networking

### Service

A Service provides a stable network identity (IP and DNS name) for a set of pods selected by labels, so other workloads do not need to track individual pod IPs as pods are created and destroyed.

Types:

- **ClusterIP** (default): Internal-only access within the cluster.
- **NodePort**: Exposes the service on a static port on every node's IP.
- **LoadBalancer**: Provisions an external cloud load balancer.
- **ExternalName**: Maps the service to an external DNS name.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
  type: ClusterIP
```

### Ingress

An Ingress defines HTTP/HTTPS routing rules to expose Services outside the cluster, supporting host-based and path-based routing along with TLS termination, all through a single external entry point.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  rules:
    - host: app.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-svc
                port:
                  number: 80
```

### LoadBalancer

The `LoadBalancer` Service type provisions an external load balancer (typically from a cloud provider like AWS ELB/NLB, GCP, or Azure) that routes external traffic into the cluster. It is the standard way to expose a service directly to the internet without a separate Ingress layer, though it provisions one balancer per service, which can become costly at scale.

### IngressController

An Ingress object on its own does nothing — it is just a set of routing rules. An IngressController (e.g., NGINX Ingress Controller, Traefik, HAProxy) is the actual component running in the cluster that watches Ingress resources and configures a proxy to implement those rules.

```bash
kubectl get pods -n ingress-nginx
kubectl get ingress
```

### IngressClass

An IngressClass specifies which Ingress controller should handle a given Ingress resource, allowing multiple controllers to coexist in the same cluster. An Ingress references its class via `spec.ingressClassName`.

```yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: nginx
spec:
  controller: k8s.io/ingress-nginx
```

### DNS

Kubernetes runs an internal DNS service (commonly CoreDNS) that automatically assigns DNS names to Services and pods, following the pattern `<service>.<namespace>.svc.cluster.local`. This allows workloads to discover each other by name instead of hardcoded IPs.

### CNI

The Container Network Interface (CNI) is the plugin specification Kubernetes uses to implement pod networking. Kubernetes does not provide networking itself — a CNI plugin (e.g., Calico, Flannel, Cilium, Weave Net) is required to assign pod IPs and enable pod-to-pod communication across nodes.

---

## Configuration

### Namespace

A Namespace provides a way to divide cluster resources into logically isolated groups, useful for multi-team or multi-environment clusters (e.g., `dev`, `staging`, `prod`). Resource names must be unique within a namespace but can be reused across namespaces.

```bash
kubectl create namespace staging
kubectl get pods -n staging
kubectl config set-context --current --namespace=staging
```

### Labels

Labels are key-value pairs attached to objects, used to organize and identify subsets of resources (e.g., `app: nginx`, `env: production`). Labels are the foundation for how Services, ReplicaSets, and Deployments select which pods they manage.

```bash
kubectl label pod nginx-pod env=production
kubectl get pods --show-labels
```

### Selectors

Selectors are queries against labels used to identify a set of objects. Kubernetes supports equality-based selectors (`env=production`) and set-based selectors (`env in (production, staging)`). Controllers like Deployments and Services use `matchLabels`/`selector` fields to determine which pods they target.

```bash
kubectl get pods -l app=nginx
kubectl get pods -l 'env in (staging,production)'
```

### Annotations

Annotations are key-value pairs, similar to labels, but intended for non-identifying metadata such as build information, descriptions, or configuration hints for tools (e.g., Ingress controller annotations). Unlike labels, annotations are not used for selection.

```bash
kubectl annotate pod nginx-pod description="frontend pod for v2 release"
```

### Secrets

A Secret stores sensitive data such as passwords, tokens, or keys, base64-encoded at rest (not encrypted by default unless encryption at rest is configured on the cluster). Secrets can be mounted as files or injected as environment variables.

```bash
kubectl create secret generic db-secret --from-literal=password=supersecret
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  password: c3VwZXJzZWNyZXQ=
```

### ConfigMap

A ConfigMap stores non-sensitive configuration data as key-value pairs, decoupling configuration from container images. ConfigMaps can be mounted as files or injected as environment variables, just like Secrets.

```bash
kubectl create configmap app-config --from-literal=LOG_LEVEL=debug
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  LOG_LEVEL: debug
```

---

## Storage

### Volume

A Volume is storage attached to a pod that outlives individual container restarts within that pod (though not the pod's lifecycle by default, unless backed by a PersistentVolume). Common volume types include `emptyDir` (temporary), `hostPath` (node's filesystem), and `configMap`/`secret` (mounted configuration).

```yaml
volumes:
  - name: cache-volume
    emptyDir: {}
```

### Persistent Volume (PV)

A PersistentVolume is a cluster-level storage resource provisioned either manually by an administrator or dynamically via a StorageClass. PVs exist independently of any pod's lifecycle, allowing data to persist even if the pod using it is deleted.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/data
```

### Persistent Volume Claim (PVC)

A PersistentVolumeClaim is a request for storage made by a user or pod. Kubernetes matches a PVC to a suitable PV (or dynamically provisions one via a StorageClass) and binds them together. Pods reference PVCs, not PVs directly.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

### StorageClass

A StorageClass defines a "class" of storage (e.g., SSD vs HDD, or a specific cloud storage backend) and enables dynamic provisioning — PVs are created automatically on demand when a PVC requests that class, rather than requiring an administrator to pre-provision them.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
```

### CSI

The Container Storage Interface (CSI) is a standard that allows storage vendors to write plugins that work across container orchestrators, including Kubernetes, without modifying Kubernetes core code. Most modern cloud storage integrations (AWS EBS CSI driver, GCP PD CSI driver) are implemented as CSI drivers.

---

## Security

### ServiceAccount

A ServiceAccount provides an identity for processes running inside pods to authenticate to the Kubernetes API server, distinct from a human User account. Every pod runs under a ServiceAccount (the `default` one if none is specified).

```bash
kubectl create serviceaccount app-sa
```

```yaml
spec:
  serviceAccountName: app-sa
```

### Role

A Role defines a set of permissions (verbs like `get`, `list`, `create`, `delete` on specific resources) within a single namespace. Roles are namespace-scoped.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
```

### RoleBinding

A RoleBinding grants the permissions defined in a Role to a user, group, or ServiceAccount within a specific namespace.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
  - kind: ServiceAccount
    name: app-sa
    namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

### ClusterRole

A ClusterRole is like a Role, but cluster-scoped — it can grant permissions across all namespaces, or on cluster-scoped resources such as Nodes or PersistentVolumes.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: node-reader
rules:
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get", "list"]
```

### ClusterRoleBinding

A ClusterRoleBinding grants the permissions defined in a ClusterRole to a user, group, or ServiceAccount across the entire cluster, not just one namespace.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: read-nodes-global
subjects:
  - kind: ServiceAccount
    name: app-sa
    namespace: default
roleRef:
  kind: ClusterRole
  name: node-reader
  apiGroup: rbac.authorization.k8s.io
```

### RBAC

Role-Based Access Control (RBAC) is the overall authorization mechanism in Kubernetes built from the four objects above (Role, RoleBinding, ClusterRole, ClusterRoleBinding). It follows the principle of least privilege: grant only the permissions a user or workload actually needs.

```bash
kubectl auth can-i delete pods --as=system:serviceaccount:default:app-sa
```

### Admission Controller

An Admission Controller is a piece of code that intercepts requests to the Kubernetes API server after authentication/authorization but before the object is persisted to etcd. It can validate or mutate requests (e.g., enforcing resource limits, injecting sidecars). Examples include `ValidatingAdmissionWebhook`, `MutatingAdmissionWebhook`, and built-in controllers like `NamespaceLifecycle`.

### Pod Security

Pod Security Standards (replacing the deprecated PodSecurityPolicy) define security profiles — `privileged`, `baseline`, and `restricted` — that restrict what pods are allowed to do, such as running as root, using host networking, or mounting host paths. These are enforced at the namespace level via the Pod Security Admission controller.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: secure-ns
  labels:
    pod-security.kubernetes.io/enforce: restricted
```

### Secrets

(See [Configuration → Secrets](#secrets) above.) From a security standpoint, Secrets should be combined with encryption at rest, RBAC restrictions limiting who can read them, and ideally an external secret manager (e.g., AWS Secrets Manager via External Secrets Operator) rather than storing sensitive values directly in the cluster.

### ConfigMap

(See [Configuration → ConfigMap](#configmap) above.) ConfigMaps should never be used for sensitive data — use Secrets instead, since ConfigMaps are stored as plain text with no encoding or encryption.

### Authentication and Authorization

- **Authentication** answers "who are you?" — verified via client certificates, bearer tokens, OIDC, or ServiceAccount tokens.
- **Authorization** answers "what are you allowed to do?" — enforced via RBAC (or less commonly, ABAC, Webhook authorization, or Node authorization).

Every API request goes through this pipeline: Authentication → Authorization → Admission Control → persisted to etcd.

### TLS, Certificate

Kubernetes uses TLS extensively to secure communication between components: the API server, kubelets, etcd, and clients all communicate over TLS. Certificates are typically issued by a cluster's internal Certificate Authority (CA) and managed via the `certificates.k8s.io` API, or automated using tools like **cert-manager** for issuing and renewing TLS certificates (including via Let's Encrypt) for Ingress resources.

---

## Scheduling

### Requests

Resource requests specify the minimum amount of CPU and memory a container needs. The scheduler uses requests to decide which node has enough capacity to place a pod.

```yaml
resources:
  requests:
    cpu: "250m"
    memory: "256Mi"
```

### Limits

Resource limits specify the maximum amount of CPU and memory a container is allowed to use. Exceeding a memory limit results in the container being OOMKilled; exceeding a CPU limit results in throttling rather than termination.

```yaml
resources:
  limits:
    cpu: "500m"
    memory: "512Mi"
```

### Resource Quotas

A ResourceQuota limits the aggregate resource consumption (CPU, memory, object counts) within a namespace, preventing a single team or application from consuming all cluster resources.

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-quota
  namespace: dev
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    pods: "20"
```

### Taints

A Taint is applied to a node to repel pods from being scheduled onto it unless those pods have a matching toleration. Taints use the format `key=value:effect`, where effect can be `NoSchedule`, `PreferNoSchedule`, or `NoExecute`.

```bash
kubectl taint nodes node1 dedicated=gpu:NoSchedule
```

### Tolerations

A Toleration is applied to a pod, allowing (but not requiring) it to be scheduled onto a node with a matching taint. Taints and tolerations work together to control which pods can run on which nodes.

```yaml
tolerations:
  - key: "dedicated"
    operator: "Equal"
    value: "gpu"
    effect: "NoSchedule"
```

### Node Affinity

Node affinity allows a pod to specify rules about which nodes it can be scheduled onto, based on node labels. It is more expressive than `nodeSelector`, supporting `requiredDuringSchedulingIgnoredDuringExecution` (hard rule) and `preferredDuringSchedulingIgnoredDuringExecution` (soft preference).

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: disktype
              operator: In
              values: ["ssd"]
```

### Pod Affinity

Pod affinity allows a pod to be scheduled near other pods matching certain labels, typically used to co-locate pods that communicate frequently and benefit from being on the same node or zone.

```yaml
affinity:
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values: ["cache"]
        topologyKey: "kubernetes.io/hostname"
```

### Anti-Affinity

Pod anti-affinity is the inverse — it prevents pods from being scheduled near other pods matching certain labels, commonly used to spread replicas of the same application across different nodes or zones for high availability.

```yaml
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values: ["web"]
        topologyKey: "kubernetes.io/hostname"
```

---

## Health Checks

### Liveness Probe

A liveness probe checks whether a container is still running correctly. If it fails, Kubernetes kills and restarts the container according to the pod's restart policy. Used to recover from deadlocks or unresponsive states that a process can't recover from on its own.

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 10
```

### Readiness Probe

A readiness probe checks whether a container is ready to accept traffic. If it fails, the pod is removed from the Service's endpoints (so it stops receiving traffic) without being restarted. Used during startup warm-up or temporary unavailability (e.g., waiting on a downstream dependency).

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

### Startup Probe

A startup probe checks whether an application has finished starting up. While it is running, liveness and readiness probes are disabled, preventing slow-starting containers from being killed prematurely by a liveness probe that hasn't given them enough time to boot.

```yaml
startupProbe:
  httpGet:
    path: /healthz
    port: 8080
  failureThreshold: 30
  periodSeconds: 10
```

---

## Scaling

### ReplicaSet

(See [Workloads → ReplicaSet](#replicaset) above.) ReplicaSets are the underlying mechanism that maintains a fixed number of replicas; both manual scaling and autoscaling ultimately adjust the `replicas` field that a ReplicaSet enforces.

### HPA (Horizontal Pod Autoscaler)

The HorizontalPodAutoscaler automatically scales the number of pod replicas in a Deployment/ReplicaSet/StatefulSet based on observed metrics such as CPU utilization, memory usage, or custom metrics (via the Metrics API).

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: nginx-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nginx-deployment
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

```bash
kubectl autoscale deployment nginx-deployment --cpu-percent=70 --min=2 --max=10
kubectl get hpa
```

### Cluster Autoscaler

The Cluster Autoscaler operates at the infrastructure level, automatically adding or removing nodes from the cluster based on pending pods that can't be scheduled due to insufficient resources, or nodes that are underutilized. It complements the HPA: HPA scales pods, Cluster Autoscaler scales the nodes those pods run on.

### Rolling Updates

A rolling update gradually replaces old pod replicas with new ones (controlled via `maxSurge` and `maxUnavailable`), ensuring zero downtime during deployments. This is the default update strategy for Deployments.

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

### Rollback

If a rolling update introduces a bug, Kubernetes retains a revision history of Deployments, allowing an instant rollback to a previous, known-good version.

```bash
kubectl rollout history deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment --to-revision=2
```

---

## Extensions

### CustomResourceDefinition (CRD)

A CustomResourceDefinition extends the Kubernetes API by defining a new resource type (a Custom Resource) that behaves like any built-in object — it can be created, queried, and managed via `kubectl` and the API server. CRDs are the foundation for the Kubernetes Operator pattern and tools like ArgoCD, cert-manager, and Istio, which all define their own CRDs.

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: backups.example.com
spec:
  group: example.com
  versions:
    - name: v1
      served: true
      storage: true
  scope: Namespaced
  names:
    plural: backups
    singular: backup
    kind: Backup
```

### Custom Resource (CR)

A Custom Resource is an instance of a CRD — an actual object created using the schema that the CRD defined. Custom Resources are typically managed by a corresponding **Operator** (a custom controller) that watches them and reconciles the cluster's actual state to match the desired state declared in the CR.

```yaml
apiVersion: example.com/v1
kind: Backup
metadata:
  name: nightly-backup
spec:
  schedule: "0 3 * * *"
  target: s3://my-bucket/backups
```

---

## Observability

> Covered in depth in a future revision session. Brief overview only.

- **Logs**: Per-container output (stdout/stderr), collected via `kubectl logs` or aggregated cluster-wide using tools like Fluentd/Loki.
- **Metrics**: Numeric time-series data (CPU, memory, request rate) collected via the Metrics Server or Prometheus.
- **Events**: Cluster-level records of state changes (e.g., pod scheduled, image pulled, probe failed), viewable via `kubectl get events`.
- **Tracing**: Tracking a single request's path across multiple services, typically via OpenTelemetry/Jaeger, used for debugging latency in distributed systems.
- **Monitoring**: The overall practice of collecting logs, metrics, and traces to observe cluster and application health, commonly via the Prometheus + Grafana stack.

---

## Scheduling (Resource Management Deep Dive)

### Resource Request

(See [Scheduling → Requests](#requests) above.) Requests are also used by the scheduler's bin-packing algorithm and by the Vertical Pod Autoscaler when recommending right-sized values.

### Resource Limit

(See [Scheduling → Limits](#limits) above.) Setting limits without requests, or limits far higher than requests, can lead to unpredictable scheduling and node overcommitment — best practice is to keep requests and limits close together for predictable performance.

### CPU

CPU in Kubernetes is measured in **cores** or **millicores** (`1000m = 1 core`). CPU is a compressible resource — when a container hits its CPU limit, it is throttled (slowed down), not killed, unlike memory.

### Monitoring

Monitoring resource usage against requests/limits (via `kubectl top pods`, Prometheus, or cloud provider dashboards) is essential for right-sizing workloads — both to avoid OOMKills from under-provisioned memory and to avoid wasting cluster capacity from over-provisioned requests.

```bash
kubectl top pods
kubectl top nodes
```

### Topology Spread Constraints

Topology spread constraints control how pods are distributed across topology domains (nodes, zones, regions), ensuring high availability by spreading replicas rather than clustering them all in one zone or node.

```yaml
topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        app: web
```

---

## DevOps and GitOps

### GitOps and Its Principles

GitOps is an operational model where Git is the single source of truth for declarative infrastructure and application configuration. Core principles:

1. **Declarative**: The entire system state is described declaratively (YAML manifests, Helm charts).
2. **Versioned and immutable**: The desired state is stored in Git, giving a full audit trail and easy rollback via `git revert`.
3. **Pulled automatically**: Software agents (like ArgoCD) automatically pull the desired state from Git rather than having CI push changes directly to the cluster.
4. **Continuously reconciled**: Agents continuously compare actual cluster state to the desired state in Git and correct any drift.

### ArgoCD

ArgoCD is a GitOps continuous delivery tool for Kubernetes. It watches a Git repository containing manifests (or Helm/Kustomize configs) and automatically syncs the cluster to match, alerting on or auto-correcting any drift between the live state and the Git-declared state.

```bash
argocd app create myapp \
  --repo https://github.com/org/myapp-config.git \
  --path k8s/overlays/production \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace production

argocd app sync myapp
argocd app get myapp
```

### Immutable Infrastructure

Immutable infrastructure is a model where servers or containers are never modified after deployment — instead of patching a running instance, a new image is built and the old one is replaced entirely. This eliminates configuration drift and makes deployments predictable and reproducible, and pairs naturally with containers and GitOps.

### Declarative Configuration

Declarative configuration means describing the desired end state of a system (e.g., "3 replicas of this image should be running") rather than the imperative steps to get there (e.g., "run this container, then run another, then another"). Kubernetes manifests are inherently declarative — the control plane's job is to continuously reconcile actual state toward the declared state.

---

## IAC (Infrastructure as Code)

Infrastructure as Code is the practice of managing and provisioning infrastructure (servers, networks, Kubernetes clusters, load balancers) through machine-readable configuration files rather than manual processes or interactive configuration tools.

Key benefits:

- **Reproducibility**: The same configuration produces the same infrastructure every time.
- **Version control**: Infrastructure changes are tracked, reviewed, and revertible just like application code.
- **Consistency**: Eliminates configuration drift between environments (dev, staging, prod).

Common tools:

- **Terraform**: Cloud-agnostic, declarative IaC tool for provisioning infrastructure (VPCs, EC2/EKS, IAM, databases).
- **Ansible**: Configuration management and provisioning tool using imperative-leaning YAML playbooks, often used for server configuration rather than cloud resource provisioning.
- **CloudFormation**: AWS-native IaC tool.
- **Pulumi**: IaC using general-purpose programming languages instead of a DSL.

```bash
terraform init
terraform plan
terraform apply
```

> Note: IaC provisions the infrastructure (e.g., the EKS cluster itself), while GitOps tools like ArgoCD manage what runs inside that infrastructure (the Kubernetes workloads). The two are complementary layers in a modern DevOps pipeline.

---

## Cluster Operations

### High Availability (HA)

High Availability in Kubernetes means designing the cluster so no single component failure causes an outage. This applies at multiple layers:

- **Control plane HA**: Running multiple API server, scheduler, and controller-manager instances (typically 3 or 5) across different nodes/zones, with etcd run as a clustered, odd-numbered quorum (e.g., 3 or 5 members) so it can tolerate node loss without losing quorum.
- **Worker node HA**: Spreading worker nodes across multiple availability zones so an entire zone outage doesn't take down the whole cluster.
- **Application HA**: Running multiple replicas of each workload (via Deployments/ReplicaSets), combined with pod anti-affinity or topology spread constraints so replicas land on different nodes/zones rather than all on one.
- **Load balancer HA**: Placing a load balancer (cloud LB or HAProxy/keepalived for self-managed clusters) in front of multiple API server instances so clients aren't dependent on a single API server.

Managed services like EKS, GKE, and AKS handle control plane HA automatically; for self-managed (kubeadm) clusters, this must be configured manually (e.g., `kubeadm init` with `--control-plane-endpoint` pointing at a load balancer).

### Disaster Recovery (DR)

Disaster Recovery is the plan and tooling for restoring a cluster and its workloads after a catastrophic failure (region outage, accidental deletion, data corruption, ransomware). Key components:

- **etcd backups**: etcd holds the entire cluster state. Regular snapshots (`etcdctl snapshot save`) are critical — without them, a control plane failure can mean a full rebuild from scratch.
- **Application/PV backups**: Tools like **Velero** (see Ecosystem section below) back up Kubernetes object manifests and PersistentVolume data to external storage (e.g., S3), enabling restoration into the same or a different cluster.
- **Multi-region/multi-cluster strategy**: For critical workloads, running a standby cluster in a different region, with regular data replication, allows failover if the primary region is lost entirely.
- **RTO/RPO**: Disaster recovery plans are typically measured by **Recovery Time Objective** (how long restoration takes) and **Recovery Point Objective** (how much data loss, measured in time, is acceptable) — these numbers drive how frequently backups are taken and how DR is architected.

```bash
ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-snapshot.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
```

### Service Discovery in Kubernetes

Service discovery is how workloads find and communicate with each other without hardcoding IPs. Kubernetes provides this primarily through two mechanisms:

- **DNS-based discovery**: CoreDNS automatically creates a DNS record for every Service (`<service>.<namespace>.svc.cluster.local`), so a pod can reach another service simply by name.
- **Environment variable injection**: For every Service that exists at pod creation time, Kubernetes injects `<SERVICE_NAME>_SERVICE_HOST` and `<SERVICE_NAME>_SERVICE_PORT` environment variables into pods in the same namespace (this is a legacy mechanism; DNS is preferred since it works for services created after the pod starts).
- **Endpoints/EndpointSlice**: Behind every Service, Kubernetes maintains an `EndpointSlice` object listing the actual pod IPs currently backing that service, continuously updated as pods come and go.

```bash
kubectl get endpointslices
kubectl exec -it mypod -- nslookup backend.default.svc.cluster.local
```

### Cluster Upgrades

Upgrading a Kubernetes cluster means moving the control plane and worker nodes to a newer version, which must be done carefully due to Kubernetes' version skew policy (kubelets can be up to two minor versions behind the API server, but not ahead).

General upgrade order:

1. **Back up etcd** before starting anything.
2. **Upgrade the control plane** first (API server, controller-manager, scheduler, etcd) — one minor version at a time (e.g., 1.27 → 1.28 → 1.29, never skipping a minor version).
3. **Upgrade kubeadm/kubelet on control plane nodes**, then worker nodes, one node at a time.
4. **Drain each node** before upgrading it, to safely evict and reschedule its pods elsewhere, then uncordon it once the upgrade is complete.

```bash
kubectl drain node1 --ignore-daemonsets --delete-emptydir-data
# upgrade kubeadm, kubelet, kubectl on node1
kubeadm upgrade node
kubectl uncordon node1
```

For managed Kubernetes (EKS/GKE/AKS), the control plane upgrade is typically a single click/API call handled by the provider, but worker node group upgrades (replacing nodes with new AMIs) still need to be rolled out carefully, usually via managed node group rolling updates.

---

## GitOps: Automated Synchronization

Beyond the basic GitOps principles already covered, ArgoCD (and similar tools like Flux) support **automated sync**, where the cluster is kept continuously aligned with Git without manual intervention:

- **Auto-sync**: When enabled, ArgoCD automatically applies any new commit to the tracked Git path as soon as it detects the change, rather than waiting for a manual `argocd app sync`.
- **Self-heal**: If someone manually changes a live resource in the cluster (configuration drift), ArgoCD detects the difference from Git and automatically reverts it back to match the Git-declared state.
- **Prune**: When a resource is removed from the Git repository, ArgoCD can automatically delete the corresponding resource from the cluster, keeping the live state and Git state in exact sync.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
spec:
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

This combination — auto-sync, self-heal, and prune — is what makes GitOps "automated": once configured, the only way to change the cluster is to change Git, and any other change is automatically corrected.

---

## Kubernetes Ecosystem

### Kustomize

Kustomize is a native Kubernetes configuration management tool (built into `kubectl`) that allows customizing raw YAML manifests for different environments without templating. It uses a base set of manifests plus environment-specific **overlays** (patches) for dev/staging/production.

```bash
kubectl apply -k overlays/production/
kustomize build overlays/production/
```

```yaml
# overlays/production/kustomization.yaml
resources:
  - ../../base
patches:
  - path: replica-patch.yaml
```

### Istio (Service Mesh)

Istio is a service mesh that adds a transparent layer of traffic management, security, and observability between services, without requiring application code changes. It works by injecting an **Envoy sidecar proxy** into every pod, which intercepts all inbound/outbound traffic.

Key capabilities:

- **Traffic management**: Fine-grained routing, canary releases, traffic mirroring, circuit breaking, retries.
- **Security**: Automatic mutual TLS (mTLS) between all services, fine-grained authorization policies.
- **Observability**: Automatic metrics, distributed tracing, and access logs for every service-to-service call, with no code changes required.

```bash
istioctl install --set profile=demo
kubectl label namespace default istio-injection=enabled
```

### Linkerd (Service Mesh)

Linkerd is a lighter-weight alternative to Istio, also using the sidecar proxy model, but focused on simplicity, low resource overhead, and ease of operation. It provides automatic mTLS, golden-metrics (success rate, latency, request volume) out of the box, and traffic splitting for canary deployments, with a much smaller learning curve than Istio.

```bash
linkerd install | kubectl apply -f -
linkerd check
kubectl annotate namespace default linkerd.io/inject=enabled
```

### Velero

Velero is a backup and disaster recovery tool for Kubernetes clusters. It backs up cluster resources (manifests) and PersistentVolume data to external object storage (e.g., S3), and can restore them into the same cluster or a completely different one — making it the primary tool referenced under the Disaster Recovery section above.

```bash
velero backup create my-backup --include-namespaces production
velero backup get
velero restore create --from-backup my-backup
```

### Sealed Secrets

Sealed Secrets (by Bitnami) solves the problem of safely storing Secrets in Git for GitOps workflows. A `kubeseal` CLI encrypts a Secret into a `SealedSecret` custom resource using a public key; only the controller running in the cluster (holding the matching private key) can decrypt it back into a regular Secret. This makes it safe to commit `SealedSecret` manifests to a Git repository, unlike raw Secrets.

```bash
kubeseal --format=yaml < secret.yaml > sealed-secret.yaml
kubectl apply -f sealed-secret.yaml
```

---

## Cloud Kubernetes: EKS

### EKS (Elastic Kubernetes Service)

EKS is AWS's managed Kubernetes service. AWS manages the control plane (API server, etcd, scheduler) for high availability across multiple Availability Zones, while the user manages worker nodes (via managed node groups, self-managed EC2, or Fargate for serverless pods).

```bash
eksctl create cluster --name my-cluster --region us-east-1 --nodegroup-name workers --node-type t3.medium --nodes 3
aws eks update-kubeconfig --name my-cluster --region us-east-1
kubectl get nodes
```

### IRSA (IAM Roles for Service Accounts)

IRSA allows Kubernetes pods running on EKS to assume specific AWS IAM roles, scoped per-ServiceAccount, instead of giving every pod on a node the same broad node-level IAM permissions. It works via an OIDC identity provider associated with the EKS cluster: a ServiceAccount is annotated with an IAM role ARN, and AWS's `sts:AssumeRoleWithWebIdentity` exchanges the pod's projected service account token for temporary AWS credentials.

This is the standard, secure way to grant fine-grained AWS permissions (e.g., "this pod can only read from this specific S3 bucket") rather than relying on overly broad node IAM roles.

```bash
eksctl create iamserviceaccount \
  --cluster my-cluster \
  --namespace default \
  --name s3-reader \
  --attach-policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess \
  --approve
```

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: s3-reader
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/s3-reader-role
```

```yaml
spec:
  serviceAccountName: s3-reader
```

### Elastic Load Balancer (ELB)

AWS offers three types of load balancers commonly used with EKS, provisioned automatically via Kubernetes Service/Ingress objects when the **AWS Load Balancer Controller** is installed in the cluster:

- **Classic Load Balancer (CLB)**: Legacy, largely deprecated in favor of ALB/NLB.
- **Application Load Balancer (ALB)**: Layer 7 (HTTP/HTTPS), supports host/path-based routing — typically provisioned via an Ingress resource annotated for ALB.
- **Network Load Balancer (NLB)**: Layer 4 (TCP/UDP), ultra-low latency, handles millions of requests per second — typically provisioned via a `LoadBalancer` type Service.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
spec:
  type: LoadBalancer
  selector:
    app: myapp
  ports:
    - port: 80
      targetPort: 8080
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
spec:
  rules:
    - host: app.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-service
                port:
                  number: 80
```
