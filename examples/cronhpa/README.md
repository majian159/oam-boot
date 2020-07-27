# Get started

1. Install CronHPA Controller

```sh
git clone https://github.com/AliyunContainerService/kubernetes-cronhpa-controller.git --depth=1

kubectl apply -f kubernetes-cronhpa-controller/config/crds/
kubectl apply -f kubernetes-cronhpa-controller/config/rbac/
kubectl apply -f kubernetes-cronhpa-controller/config/deploy/
```

2. Apply a sample application configuration
```sh
kubectl apply -f examples/cronhpa/
```

3. Verify that the application is running You can check the status and events from the applicationConfiguration object
- You should also see a cronhpa looking like below
```console
kubectl get cronhpa
NAME                    AGE
example-cronhpa-trait   58s
```


- And a deployment looking like below
```console
kubectl get deployment example-cronhpa-appconfig-workload -w
NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
example-cronhpa-appconfig-workload   1/1     1            1           3m38s
example-cronhpa-appconfig-workload   1/3     1            1           3m58s
example-cronhpa-appconfig-workload   1/3     1            1           3m58s
example-cronhpa-appconfig-workload   1/3     1            1           3m58s
example-cronhpa-appconfig-workload   1/3     3            1           3m58s
example-cronhpa-appconfig-workload   2/3     3            2           4m
example-cronhpa-appconfig-workload   3/3     3            3           4m1s
example-cronhpa-appconfig-workload   3/1     3            3           4m28s
example-cronhpa-appconfig-workload   3/1     3            3           4m28s
example-cronhpa-appconfig-workload   3/1     3            3           4m28s
example-cronhpa-appconfig-workload   1/1     1            1           4m28s
```