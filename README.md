# OAM Boot
A OAM bootstrap.

# Prerequisites
- Kubernetes v1.16+
- Helm 3

# Install

1. Create namespace for OAM resources
```sh
kubectl create ns oam-system
```

2. Add helm repo
```sh
helm repo add crossplane-master https://charts.crossplane.io/master/
```

3. Install Crossplane
> Eventually oam-kubernetes-runtime will be self-contained, and crossplane is no longer needed. However, if crossplane is not installed in the current version, third-party controllers will not work properly.
```sh
helm install crossplane --namespace oam-system crossplane-master/crossplane --version 0.12.0
```

1. Install OAM Runtime Controller
```sh
helm install oam --namespace oam-system crossplane-master/oam-kubernetes-runtime --devel
```

5. Install OAM Catalog
```sh
git clone https://github.com/majian159/oam-boot.git --depth=1
helm install oam-boot-catalog --namespace oam-system oam-boot/charts/oam-boot-catalog
```

# Get started

- We have some examples in our repo, clone and get started with it.
```sh
git clone https://github.com/majian159/oam-boot.git --depth=1
cd oam-boot
```

- Apply a sample application configuration
```sh
kubectl apply -f examples/containerized-workload
```

- Verify that the application is running You can check the status and events from the applicationConfiguration object
```console
kubectl describe applicationconfigurations.core.oam.dev example-appconfig
Status:
  Conditions:
    Last Transition Time:  2020-07-24T11:33:14Z
    Reason:                Successfully reconciled resource
    Status:                True
    Type:                  Synced
  Dependency:
  Workloads:
    Component Name:           example-component
    Component Revision Name:  example-component-bsdcdu2al04pc6l6a23g
    Traits:
      Trait Ref:
        API Version:  core.oam.dev/v1alpha2
        Kind:         ManualScalerTrait
        Name:         example-appconfig-trait
      Trait Ref:
        API Version:  core.oam.dev/v1alpha2
        Kind:         ServiceExpose
        Name:         example-appconfig-trait
    Workload Ref:
      API Version:  core.oam.dev/v1alpha2
      Kind:         ContainerizedWorkload
      Name:         example-appconfig-workload
Events:
  Type     Reason                  Age                 From                                       Message
  ----     ------                  ----                ----                                       -------
  Warning  CannotRenderComponents  19s (x2 over 19s)   oam/applicationconfiguration.core.oam.dev  cannot get component "example-component": Component.core.oam.dev "example-component" not found
  Warning  CannotRenderComponents  19s                 oam/applicationconfiguration.core.oam.dev  cannot get component "example-component": Component.core.oam.dev "example-component" not found
  Warning  CannotRenderComponents  19s                 oam/applicationconfiguration.core.oam.dev  cannot find trait definition "core.oam.dev/v1alpha2" "ServiceExpose" "example-appconfig-trait": TraitDefinition.core.oam.dev "serviceexposes.core.oam.dev" not found
  Warning  CannotApplyComponents   17s (x2 over 19s)   oam/applicationconfiguration.core.oam.dev  cannot apply trait "core.oam.dev/v1alpha2" "ServiceExpose" "example-appconfig-trait": cannot create object: ServiceExpose.core.oam.dev "example-appconfig-trait" is invalid: spec.workloadRef: Required value
  Normal   Deployment created      16s (x3 over 19s)   ContainerizedWorkload                      Workload `example-appconfig-workload` successfully server side patched a deployment `example-appconfig-workload`
  Normal   Service created         16s (x3 over 19s)   ContainerizedWorkload                      Workload `example-appconfig-workload` successfully server side patched a service `example-appconfig-workload`
  Normal   Manual scalar applied   15s (x2 over 17s)   ManualScalarTrait                          Trait `example-appconfig-trait` successfully scaled a resource to 3 instances
  Normal   RenderedComponents      11s (x11 over 19s)  oam/applicationconfiguration.core.oam.dev  Successfully rendered components
  Normal   RenderedComponents      11s (x12 over 18s)  oam/applicationconfiguration.core.oam.dev  Successfully rendered components
  Normal   AppliedComponents       11s (x12 over 17s)  oam/applicationconfiguration.core.oam.dev  Successfully applied components
  Normal   AppliedComponents       11s (x9 over 17s)   oam/applicationconfiguration.core.oam.dev  Successfully applied components
```

You should also see a deployment looking like below
```console
kubectl get deployments
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
example-appconfig-workload   3/3     3            3           2m18s

```

And a service looking like below
```console
kubectl get services
NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
example-appconfig-trait      NodePort    13.13.230.255   <none>        80:31087/TCP   2m28s
example-appconfig-workload   NodePort    13.13.211.165   <none>        80:30094/TCP   2m30s
```


# Cleanup

```sh
helm uninstall oam-boot-catalog oam crossplane -n oam-system
kubectl get crd | grep oam.dev | awk '{print $1}' | xargs kubectl delete crd
kubectl get crd | grep crossplane.io | awk '{print $1}' | xargs kubectl delete crd
kubectl delete ns oam-system
```