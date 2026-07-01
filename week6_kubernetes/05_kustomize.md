# Kustomize

## What Is Kustomize?

Kustomize is a template-free way to customize Kubernetes manifests. Instead of parameterizing YAML with placeholders (as Helm does), Kustomize works by layering **patches** and **overlays** on top of a set of plain, valid Kubernetes YAML files. It is built into `kubectl` (`kubectl apply -k`) and requires no separate install for basic use.

The core building block is a `kustomization.yaml` file that declares which resources to include and what transformations to apply.

---

## Why It Is Used

- **No templating language.** Base manifests stay as ordinary, readable Kubernetes YAML — nothing to render or debug through a template engine.
- **Overlay model.** A `base/` directory holds the common manifests; environment-specific `overlays/` (dev, staging, prod) apply patches on top (image tags, replica counts, resource limits, env vars) without duplicating the whole manifest set.
- **Native kubectl support.** No extra tooling required to apply a kustomization.
- **Good for GitOps.** Tools like ArgoCD and Flux natively understand Kustomize overlays, making it a common choice for GitOps-driven multi-environment deployments.

Typical directory structure:

```
k8s/
  base/
    deployment.yaml
    service.yaml
    kustomization.yaml
  overlays/
    dev/
      kustomization.yaml
      replica-patch.yaml
    staging/
      kustomization.yaml
      replica-patch.yaml
    prod/
      kustomization.yaml
      replica-patch.yaml
```

Example `base/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
```

Example `overlays/prod/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
patches:
  - path: replica-patch.yaml
images:
  - name: myapp
    newTag: v1.4.0
namespace: prod
```

Common commands:

```bash
# Render the final manifests without applying (great for review/debugging)
kubectl kustomize overlays/prod

# Apply an overlay directly to the cluster
kubectl apply -k overlays/prod

# Using the standalone kustomize CLI (more features than the built-in kubectl version)
kustomize build overlays/prod

# Diff what would change against the live cluster
kubectl diff -k overlays/prod

# Set an image tag imperatively (writes into kustomization.yaml)
cd overlays/prod
kustomize edit set image myapp=myapp:v1.4.1

# Add a common label across all resources
kustomize edit add label environment:production

# Add a common annotation
kustomize edit add annotation team:platform
```

Common transformations available in `kustomization.yaml`:

- `namePrefix` / `nameSuffix` — prefix/suffix all resource names
- `namespace` — force a namespace on all resources
- `commonLabels` / `commonAnnotations` — apply labels/annotations everywhere
- `images` — override image name/tag
- `replicas` — override replica count for a named Deployment
- `configMapGenerator` / `secretMapGenerator` — generate ConfigMaps/Secrets from files or literals
- `patches` (strategic merge or JSON 6902) — apply targeted field-level changes

---

## Helm vs Kustomize

| Aspect | Helm | Kustomize |
|---|---|---|
| Approach | Templating engine (Go templates) | Patch/overlay on plain YAML |
| Base manifests | Templated, not directly valid YAML | Plain, valid Kubernetes YAML |
| Packaging | Charts, versioned, shareable via repos | No packaging concept; just directories |
| Reusability across projects | High — charts are distributable, parameterized artifacts | Lower — overlays are typically project-specific |
| Learning curve | Steeper (templating syntax, values schema) | Simpler (declarative YAML patches) |
| Dependency management | Built-in (`Chart.yaml` dependencies) | Not built-in |
| Release tracking / rollback | Built-in (`helm history`, `helm rollback`) | Not built-in — relies on `kubectl` or GitOps tooling |
| Ecosystem | Large public chart ecosystem (Artifact Hub) | No equivalent public ecosystem; overlays are project-local |
| Best fit | Installing third-party software (Prometheus, cert-manager, ingress controllers) with configurable, reusable charts | Managing environment-specific variants of your own application manifests |

In practice, many teams use both together: Helm to install third-party charts, and Kustomize to manage environment overlays for their own application manifests — including patching values on top of a rendered Helm chart via `helm template | kustomize build -`.

---

# References

- https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
- https://youtu.be/spCdNeNCuFU?si=A912UfIIQGYjtVmK
- https://youtu.be/Ks0PMh70GTY?si=_1yl67HW1QtWhxvQ
