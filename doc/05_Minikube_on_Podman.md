# Kubernetes (Minikube) on Podman

The fastest way to start is to run this command:


```bash
minikube start --driver podman
```

    😄  minikube v1.26.0 on Darwin 12.4 (arm64)
    ✨  Using the podman (experimental) driver based on existing profile
    👍  Starting control plane node minikube in cluster minikube
    🚜  Pulling base image ...
    E0725 11:41:01.134112   18512 cache.go:203] Error downloading kic artifacts:  not yet implemented, see issue #8426
    🔄  Restarting existing podman container for "minikube" ...
    🐳  Preparing Kubernetes v1.24.1 on Docker 20.10.17 ...E0725 11:41:07.641968   18512 start.go:126] Unable to get host IP: RoutableHostIPFromInside is currently only implemented for linux
    
    🔎  Verifying Kubernetes components...
        ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
    🌟  Enabled addons: storage-provisioner, default-storageclass
    🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
    



## Test: Migrate the pod from Podman to Kubernetes

Let's just export the running pod (if you don't have one, check Chapter 3 and go through it).

We will need a persisten volume claim. Note that the generator does not create other resources like `PersistentVolumeClaims`, so in case of needing one we will have to create it explicitly.



```bash
podman generate kube dynamic-webserver | kubectl apply -f -
```

    pod/dynamic-webserver created
    




```bash
# The Pod won't be ready until the PVC is created:

kubectl get pod dynamic-webserver
```

    NAME                READY   STATUS    RESTARTS   AGE
    dynamic-webserver   0/2     Pending   0          6m2s
    



## Create the Persistent Volume Claim

Let's create the PVC using an inline script like the following one.

Including the storage class as "standard" should allow minikube to provision a `PersistenVolume` automatically, so there is no need for explicitly provisioning a volume.


```bash
echo "
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: webserver-data
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: standard
  resources:
    requests:
      storage: 1Gi
" | kubectl apply -f -
```

    persistentvolumeclaim/webserver-data created004l
    




```bash
kubectl get pvc webserver-data
```

    NAME             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    webserver-data   Bound    pvc-018de289-0506-49fb-a95c-8eaa17040cd8   1Gi        RWX            standard       5m57s
    




```bash
kubectl describe pvc webserver-data
```

    Name:          webserver-data
    Namespace:     default
    StorageClass:  standard
    Status:        Bound
    Volume:        pvc-018de289-0506-49fb-a95c-8eaa17040cd8
    Labels:        <none>
    Annotations:   pv.kubernetes.io/bind-completed: yes
                   pv.kubernetes.io/bound-by-controller: yes
                   volume.beta.kubernetes.io/storage-provisioner: k8s.io/minikube-hostpath
                   volume.kubernetes.io/storage-provisioner: k8s.io/minikube-hostpath
    Finalizers:    [kubernetes.io/pvc-protection]
    Capacity:      1Gi
    Access Modes:  RWX
    VolumeMode:    Filesystem
    Used By:       dynamic-webserver
    Events:
      Type    Reason                 Age                  From                                                                    Message
      ----    ------                 ----                 ----                                                                    -------
      Normal  Provisioning           6m1s                 k8s.io/minikube-hostpath_minikube_79f7c9e9-5132-4133-acf8-f4ea456da720  External provisioner is provisioning volume for claim "default/webserver-data"
      Normal  ExternalProvisioning   6m1s (x2 over 6m1s)  persistentvolume-controller                                             waiting for a volume to be created, either by external provisioner "k8s.io/minikube-hostpath" or manually created by system administrator
      Normal  ProvisioningSucceeded  6m1s                 k8s.io/minikube-hostpath_minikube_79f7c9e9-5132-4133-acf8-f4ea456da720  Successfully provisioned volume pvc-018de289-0506-49fb-a95c-8eaa17040cd8
    




```bash
kubectl get pod dynamic-webserver
```

    NAME                READY   STATUS    RESTARTS   AGE
    dynamic-webserver   2/2     Running   0          29m
    



## Forwarding Requests to the Pod

As we haven't yet provided a Service to the Kubernetes' Pod, we cannot forward requests to the services.

To test the pods working together we will use the port forwarding functinality built-in in kubectl.
Note that the target port is "80" and not "8080" as in the previous examples.
For consistency we will map port 80 to 8080 on the local machine:


```bash
# Stop the Pod if you still have it running, it might be using port 8080
podman pod ps | grep dynamic-webserver || podman pod stop dynamic-webserver
```

    80c71a708a8e  dynamic-webserver  Exited      2 hours ago  41194441e148  4
    



# Run this on a shell, this process blocks the output and it is not suitable for the Jupyter Notebook
kubectl port-forward pods/dynamic-webserver 8080:80


```bash
curl localhost:8080
```

    Static Website Init
    Index Updated @Mon Jul 25 11:18:11 UTC 2022
    Index Updated @Mon Jul 25 11:18:21 UTC 2022
    Index Updated @Mon Jul 25 11:18:31 UTC 2022
    Index Updated @Mon Jul 25 11:18:41 UTC 2022
    Index Updated @Mon Jul 25 11:18:51 UTC 2022
    Index Updated @Mon Jul 25 11:19:01 UTC 2022
    Index Updated @Mon Jul 25 11:19:11 UTC 2022
    Index Updated @Mon Jul 25 11:19:21 UTC 2022
    Index Updated @Mon Jul 25 11:19:31 UTC 2022
    Index Updated @Mon Jul 25 11:19:41 UTC 2022
    Index Updated @Mon Jul 25 11:19:51 UTC 2022
    Index Updated @Mon Jul 25 11:20:01 UTC 2022
    Index Updated @Mon Jul 25 11:20:11 UTC 2022
    Index Updated @Mon Jul 25 11:20:21 UTC 2022
    Index Updated @Mon Jul 25 11:20:31 UTC 2022
    Index Updated @Mon Jul 25 11:20:41 UTC 2022
    Index Updated @Mon Jul 25 11:20:51 UTC 2022
    Index Updated @Mon Jul 25 11:21:01 UTC 2022
    Index Updated @Mon Jul 25 11:21:11 UTC 2022
    Index Updated @Mon Jul 25 11:21:21 UTC 2022
    Index Updated @Mon Jul 25 11:21:31 UTC 2022
    Index Updated @Mon Jul 25 11:21:41 UTC 2022
    Index Updated @Mon Jul 25 11:21:51 UTC 2022
    Index Updated @Mon Jul 25 11:22:01 UTC 2022
    Index Updated @Mon Jul 25 11:22:11 UTC 2022
    Index Updated @Mon Jul 25 11:22:21 UTC 2022
    Index Updated @Mon Jul 25 11:22:31 UTC 2022
    Index Updated @Mon Jul 25 11:22:41 UTC 2022
    Index Updated @Mon Jul 25 11:22:51 UTC 2022
    Index Updated @Mon Jul 25 11:23:01 UTC 2022
    Index Updated @Mon Jul 25 11:23:11 UTC 2022
    Index Updated @Mon Jul 25 11:23:21 UTC 2022
    Index Updated @Mon Jul 25 11:23:31 UTC 2022
    Index Updated @Mon Jul 25 11:23:41 UTC 2022
    Index Updated @Mon Jul 25 11:23:51 UTC 2022
    Index Updated @Mon Jul 25 11:24:01 UTC 2022
    Index Updated @Mon Jul 25 11:24:11 UTC 2022
    Index Updated @Mon Jul 25 11:24:21 UTC 2022
    Index Updated @Mon Jul 25 11:24:31 UTC 2022
    Index Updated @Mon Jul 25 11:24:41 UTC 2022
    Index Updated @Mon Jul 25 11:24:51 UTC 2022
    Index Updated @Mon Jul 25 11:25:01 UTC 2022
    Index Updated @Mon Jul 25 11:25:11 UTC 2022
    Index Updated @Mon Jul 25 11:25:21 UTC 2022
    Index Updated @Mon Jul 25 11:25:31 UTC 2022
    Index Updated @Mon Jul 25 11:25:41 UTC 2022
    Index Updated @Mon Jul 25 11:25:51 UTC 2022
    Index Updated @Mon Jul 25 11:26:01 UTC 2022
    Index Updated @Mon Jul 25 11:26:11 UTC 2022
    Index Updated @Mon Jul 25 11:26:21 UTC 2022
    Index Updated @Mon Jul 25 11:26:31 UTC 2022
    Index Updated @Mon Jul 25 11:26:41 UTC 2022
    Index Updated @Mon Jul 25 11:26:51 UTC 2022
    Index Updated @Mon Jul 25 11:27:01 UTC 2022
    Index Updated @Mon Jul 25 11:27:11 UTC 2022
    Index Updated @Mon Jul 25 11:27:21 UTC 2022
    Index Updated @Mon Jul 25 11:27:31 UTC 2022
    Index Updated @Mon Jul 25 11:27:41 UTC 2022
    Index Updated @Mon Jul 25 11:27:51 UTC 2022
    Index Updated @Mon Jul 25 11:28:01 UTC 2022
    Index Updated @Mon Jul 25 11:28:11 UTC 2022
    Index Updated @Mon Jul 25 11:28:21 UTC 2022
    Index Updated @Mon Jul 25 11:28:31 UTC 2022
    Index Updated @Mon Jul 25 11:28:41 UTC 2022
    Index Updated @Mon Jul 25 11:28:51 UTC 2022
    Index Updated @Mon Jul 25 11:29:01 UTC 2022
    Index Updated @Mon Jul 25 11:29:11 UTC 2022
    


