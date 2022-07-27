# Podman Plays Kubernetes Pods

With a few limitations Podman can play Kubernetes Pods.

It is possible to export a manifest from a running pod and after cleaning the following, it can be played in podman:

1. Metadata / Annotations
1. Secret Mounts
1. Status

I exported a sample under `tests/exported-pod.yaml` for reference. This pod was applied from the generated pod manifest, so we need to stop the older pod if still running (I renamed the pod name too in the manifest so that the 2 can coexist).


```bash
# Stop the dynamic-webserver pod that we created in Chapter 4
podman pod stop dynamic-webserver
```

    80c71a708a8e3b7d702236aeff628e213c3fccee699fe17ce40510a6d99f815e
    




```bash
# Apply the exported manifest
podman play kube tests/exported-pod.yaml
```

    Pod:
    2d6e8a4357379520927ce14c13515584fbd82657e6bac79f378bfd42c7f1b2fe
    Containers:
    1b6d6a4c6d578899e5a434fd9f8f134078f15b86ad8e734f3964b384f768ad0a
    8d802f3f6611d9fab1b17fcc85bf3748415d211e7676bce9e1fb5db10078de66
    



```bash
# Inspect the pod
podman pod inspect exported-dynamic-webserver
```

    {
         "Id": "2d6e8a4357379520927ce14c13515584fbd82657e6bac79f378bfd42c7f1b2fe",
         "Name": "exported-dynamic-webserver",
         "Created": "2022-07-26T18:09:21.580479183+02:00",
         "State": "Running",
         "Hostname": "exported-dynamic-webserver",
         "Labels": {
              "app": "exported-dynamic-webserver"
         },
         "CreateCgroup": true,
         "CgroupParent": "machine.slice",
         "CgroupPath": "machine.slice/machine-libpod_pod_2d6e8a4357379520927ce14c13515584fbd82657e6bac79f378bfd42c7f1b2fe.slice",
         "CreateInfra": true,
         "InfraContainerID": "d5f0ec7fcb8eca6cbc37c6f4ccab861f99043b44200159d070841918fc7383c0",
         "InfraConfig": {
              "PortBindings": {
                   "80/tcp": [
         {
              "HostIp": "",
              "HostPort": "8080"
         }
    ]
              },
              "HostNetwork": false,
              "StaticIP": "",
              "StaticMAC": "",
              "NoManageResolvConf": false,
              "DNSServer": null,
              "DNSSearch": null,
              "DNSOption": null,
              "NoManageHosts": false,
              "HostAdd": null,
              "Networks": [
                   "podman"
              ],
              "NetworkOptions": null,
              "pid_ns": "private",
              "userns": "host"
         },
         "SharedNamespaces": [
              "net",
              "uts",
              "ipc"
         ],
         "NumContainers": 4,
         "Containers": [
              {
                   "Id": "1b6d6a4c6d578899e5a434fd9f8f134078f15b86ad8e734f3964b384f768ad0a",
                   "Name": "exported-dynamic-webserver-apache-httpd",
                   "State": "running"
              },
              {
                   "Id": "7f69914589be293a008e2640fabd33c037654c028b5dde6ee9e83a8471b4070a",
                   "Name": "exported-dynamic-webserver-apache-httpd-init",
                   "State": "exited"
              },
              {
                   "Id": "8d802f3f6611d9fab1b17fcc85bf3748415d211e7676bce9e1fb5db10078de66",
                   "Name": "exported-dynamic-webserver-apache-httpd-index-updater",
                   "State": "running"
              },
              {
                   "Id": "d5f0ec7fcb8eca6cbc37c6f4ccab861f99043b44200159d070841918fc7383c0",
                   "Name": "2d6e8a435737-infra",
                   "State": "running"
              }
         ]
    }



```bash
# Even the persistent volume claim was handled properly as a volume mount for all containers
curl localhost:8080
```

    Static Website Init
    Index Updated @Tue Jul 26 16:09:27 UTC 2022
    Index Updated @Tue Jul 26 16:09:37 UTC 2022



```bash

```
