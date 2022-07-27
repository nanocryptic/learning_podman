# Pods

Podman has the hability to run containers in Pods, like in Kubernetes.

Pod is a concept in which a group of one or more containers working together for a common purpose and sharing the same namespaces and cgroups (resource constraints).
This way it is also possible to group containers's network space and volume mounts, making it easier for the containers to interact and work as if they were a single unit.


## Running Pods

To run containers in pods requires to plan a little bit, as the pod needs to be created up-front, specifying the volumes and ports that will be required.
Afterwards the containers will be attached to this pod.

We will run the following example to demonstrate how it works, start a simple http server in one pod, while in another we will refresh the index.html using a volume: 2 concerns (2 containers and 1 pod):

1. Create a pod
1. Create the web server container and attach it to the pod
1. Create the sidecar container that will update the index.html



### Create the Pod

After creating the path for the volume mount we will:

1. Specify the port binding (8080:80)
1. Specify a volume mount to `/usr/local/apache2/htdocs` with the `z` parameter. `z` specifies that the volume mount should happen in each container (shared).


```bash
podman volume create webserver-data
```

    webserver-data



```bash
podman pod create -p 8080:80 --name dynamic-webserver --volume  webserver-data:/usr/local/apache2/htdocs:z
```

    efdacb6f77b229d9120510ea9c845d1f41f15c961e23c5af6fe28632795710b1



```bash
podman pod ps
```

    POD ID        NAME               STATUS      CREATED             INFRA ID      # OF CONTAINERS
    efdacb6f77b2  dynamic-webserver  Created     About a minute ago  8fe498633a11  1


### Inspecting the pod (right after creation)

Although we just created a pod without explicitly attaching containers to it, there is already a running container in this pod: the `pause` container from the Kubernetes project.
It is in charge of maintaining the namespaces and networks from the whole pod.

Let's check this out:


```bash
podman ps --pod --all
```

    CONTAINER ID  IMAGE                                    COMMAND     CREATED             STATUS          PORTS                                                                                                                       NAMES               POD ID        PODNAME
    5013a0794fd7  gcr.io/k8s-minikube/kicbase:v0.0.32                  4 hours ago         Up 4 hours ago  0.0.0.0:38965->22/tcp, 0.0.0.0:42903->2376/tcp, 0.0.0.0:32787->5000/tcp, 0.0.0.0:33043->8443/tcp, 0.0.0.0:42707->32443/tcp  minikube                          
    8fe498633a11  localhost/podman-pause:4.1.1-1655914710              About a minute ago  Created         0.0.0.0:8080->80/tcp                                                                                                        efdacb6f77b2-infra  efdacb6f77b2  dynamic-webserver



```bash
podman inspect $(podman ps --all | awk '/pause/{ print $NF }' | grep infra) --format '{{.Mounts}}'
```

    [{volume webserver-data /var/lib/containers/storage/volumes/webserver-data/_data /usr/local/apache2/htdocs local z [nosuid nodev rbind] true rprivate}]



```bash
podman inspect $(podman ps --all | awk '/pause/{ print $NF }' | grep infra) --format '{{.HostConfig.PortBindings}}'
```

    map[80/tcp:[{ 8080}]]


### Attach the containers

1. First we create the httpd container, which simply serves the index.html file from the htdocs folder
1. Then we start a sidecar container that will update the index adding timestamps. This is a silly test whose purpose is to demonstrate the volume share.

Note that we are not supplying ports nor volumes to the single containers, they inherit those from the pod.


```bash
podman run -d --name apache-httpd --pod dynamic-webserver httpd:2.4
```

    53f5d8f03a8d880f23f5da4319c565099802470d5a58bc904440942a2b8b26ea



```bash
curl -s localhost:8080
```

    <html><body><h1>It works!</h1></body></html>



```bash
podman run -d --name apache-httpd-index-updater --pod dynamic-webserver alpine sh -c 'while true; do echo "Index Updated @$(date)" >> /usr/local/apache2/htdocs/index.html; sleep 10; done'
```

    Resolved "alpine" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
    Trying to pull docker.io/library/alpine:latest...
    Getting image source signatures
    Copying blob sha256:f97344484467e4c4ebb85aae724170073799295a3442c50ab532e249bd27b412
    Copying config sha256:3d81c46cd8756ddb6db9ec36fa06a6fb71c287fb265232ba516739dc67a5f07d
    Writing manifest to image destination
    Storing signatures
    fee00cf638d88226a3f1a2ab841a885654cf335c0da9a309e7b261bfa6d44eeb



```bash
curl -s localhost:8080
```

    <html><body><h1>It works!</h1></body></html>
    Index Updated @Tue Jul 26 16:02:16 UTC 2022
    Index Updated @Tue Jul 26 16:02:26 UTC 2022
    Index Updated @Tue Jul 26 16:02:36 UTC 2022
    Index Updated @Tue Jul 26 16:02:46 UTC 2022


## Cleanup Pods

Removing pods deletes also their running containers, which is a fast way to cleanup resources.

The command is pretty much the same as with containers, but prefixed with the word `pod`:


```bash
podman pod rm -f dynamic-webserver
```

    707e019d58a4f6117bda87fcc6408887d7c8b707af458d19e6e091120f65c23b


## Advanced Pod Creation: The init pattern

The _init_ pattern is an advanced concept from Kuberbetes in which a container starts previous to other ones and performs some action (usuarlly set up or configure a dependent resource), so that other containers run properly afterwards.
This way each container has exactly one concern.


### Extending the previous example with an init container

Let's extend the pod example that we have seen with an _init_ container.

All in all we will have:

1. A pod with a _pause_ container which will be defined as _new_ when creating the first container, the _init_ container.
1. The _init_ container itself
1. The _main_ httpd container
1. The _sidecar_ (updater) container

#### Creating the pod with the init container

Note: It seems that using the init pattern we need to supply the volume explicitly on all subsequent commands.


```bash
podman create --name apache-httpd-init --init-ctr=always --pod new:dynamic-webserver -p 8080:80 --volume  webserver-data:/usr/local/apache2/htdocs:z busybox sh -c 'echo "Static Website Init" > /usr/local/apache2/htdocs/index.html'
```

    3511682884f4e406f328c294361ffb4772ec7461f12928e59e67e5b1e6ea4c52


#### Creating the httpd server

Note: again we supply the volume in this command explicitly.


```bash
podman run -d --name apache-httpd --pod dynamic-webserver --volume  webserver-data:/usr/local/apache2/htdocs:z  httpd:2.4
```

    a1834a6f5332a610d8cfa7077c7d9ea557565ea0c9d1d83ec23556a5a4773333


#### Triggering the init container by starting the pod

We have provided the flag --init-ctr=always, so this way the pod will initialise each time that we start it.

To test this, let's stop and start the pod:


```bash
podman pod stop dynamic-webserver
```

    707e019d58a4f6117bda87fcc6408887d7c8b707af458d19e6e091120f65c23b



```bash
podman pod start dynamic-webserver
```

    707e019d58a4f6117bda87fcc6408887d7c8b707af458d19e6e091120f65c23b



```bash
curl localhost:8080
```

    Static Website Init


#### Creating the sidecar container (updater)

Note: again we supply the volume in this command explicitly.


```bash
podman run -d --name apache-httpd-index-updater --pod dynamic-webserver --volume  webserver-data:/usr/local/apache2/htdocs:z  alpine sh -c 'while true; do echo "Index Updated @$(date)" >> /usr/local/apache2/htdocs/index.html; sleep 10; done'
```

    3c01cc0e1105fdaf166c311b25249d5246ef371bc363bfa240f90497aec3e706



```bash
curl localhost:8080
```

    Static Website Init
    Index Updated @Tue Jul 26 16:04:04 UTC 2022
    Index Updated @Tue Jul 26 16:04:14 UTC 2022
    Index Updated @Tue Jul 26 16:06:24 UTC 2022



```bash
podman pod stop dynamic-webserver
```

    9dce7221436bedba1acc91eb7183f5daf8f2ac06251ef9be7f425c420cb0baf3



```bash
curl localhost:8080
```

    curl: (7) Failed to connect to localhost port 8080 after 7 ms: Connection refused




## Generate a Kubernetes Pod Manifest from a Podman's Pod

Podman can generate Kubernetes manifests out of running Pods (and play manifests too!).



```bash
podman generate kube dynamic-webserver
```

    # Save the output of this file and use kubectl create -f to import
    # it into Kubernetes.
    #
    # Created with podman-4.1.1
    apiVersion: v1
    kind: Pod
    metadata:
      annotations:
        io.kubernetes.cri-o.ContainerType/apache-httpd: container
        io.kubernetes.cri-o.ContainerType/apache-httpd-index-updater: container
        io.kubernetes.cri-o.ContainerType/apache-httpd-init: container
        io.kubernetes.cri-o.SandboxID/apache-httpd: dynamic-webserver
        io.kubernetes.cri-o.SandboxID/apache-httpd-index-updater: dynamic-webserver
        io.kubernetes.cri-o.SandboxID/apache-httpd-init: dynamic-webserver
        io.kubernetes.cri-o.TTY/apache-httpd: "false"
        io.kubernetes.cri-o.TTY/apache-httpd-index-updater: "false"
        io.kubernetes.cri-o.TTY/apache-httpd-init: "false"
        io.podman.annotations.autoremove/apache-httpd: "FALSE"
        io.podman.annotations.autoremove/apache-httpd-index-updater: "FALSE"
        io.podman.annotations.autoremove/apache-httpd-init: "FALSE"
        io.podman.annotations.init/apache-httpd: "FALSE"
        io.podman.annotations.init/apache-httpd-index-updater: "FALSE"
        io.podman.annotations.init/apache-httpd-init: "FALSE"
        io.podman.annotations.privileged/apache-httpd: "FALSE"
        io.podman.annotations.privileged/apache-httpd-index-updater: "FALSE"
        io.podman.annotations.privileged/apache-httpd-init: "FALSE"
        io.podman.annotations.publish-all/apache-httpd: "FALSE"
        io.podman.annotations.publish-all/apache-httpd-index-updater: "FALSE"
        io.podman.annotations.publish-all/apache-httpd-init: "FALSE"
      creationTimestamp: "2022-07-25T09:16:28Z"
      labels:
        app: dynamic-webserver
      name: dynamic-webserver
    spec:
      containers:
      - image: docker.io/library/httpd:2.4
        name: apache-httpd
        ports:
        - containerPort: 80
          hostPort: 8080
        resources: {}
        securityContext:
          capabilities:
            drop:
            - CAP_MKNOD
            - CAP_NET_RAW
            - CAP_AUDIT_WRITE
        volumeMounts:
        - mountPath: /usr/local/apache2/htdocs
          name: webserver-data-pvc
      - command:
        - sh
        - -c
        - while true; do echo "Index Updated @$(date)" >> /usr/local/apache2/htdocs/index.html;
          sleep 10; done
        image: docker.io/library/alpine:latest
        name: apache-httpd-index-updater
        resources: {}
        securityContext:
          capabilities:
            drop:
            - CAP_MKNOD
            - CAP_NET_RAW
            - CAP_AUDIT_WRITE
        volumeMounts:
        - mountPath: /usr/local/apache2/htdocs
          name: webserver-data-pvc
      initContainers:
      - command:
        - sh
        - -c
        - echo "Static Website Init" > /usr/local/apache2/htdocs/index.html
        image: docker.io/library/busybox:latest
        name: apache-httpd-init
        resources: {}
        securityContext:
          capabilities:
            drop:
            - CAP_MKNOD
            - CAP_NET_RAW
            - CAP_AUDIT_WRITE
        volumeMounts:
        - mountPath: /usr/local/apache2/htdocs
          name: webserver-data-pvc
      restartPolicy: Never
      volumes:
      - name: webserver-data-pvc
        persistentVolumeClaim:
          claimName: webserver-data
    status: {}
    
    




```bash
# Clean export to remove unnecessary metadata

podman generate kube dynamic-webserver | yq 'del(.metadata.annotations , .metadata.creationTimestamp , .status)' --yaml-output
```

    apiVersion: v14l
    kind: Pod
    metadata:
      labels:
        app: dynamic-webserver
      name: dynamic-webserver
    spec:
      containers:
        - image: docker.io/library/httpd:2.4
          name: apache-httpd
          ports:
            - containerPort: 80
              hostPort: 8080
          resources: {}
          securityContext:
            capabilities:
              drop:
                - CAP_MKNOD
                - CAP_NET_RAW
                - CAP_AUDIT_WRITE
          volumeMounts:
            - mountPath: /usr/local/apache2/htdocs
              name: webserver-data-pvc
        - command:
            - sh
            - -c
            - while true; do echo "Index Updated @$(date)" >> /usr/local/apache2/htdocs/index.html;
              sleep 10; done
          image: docker.io/library/alpine:latest
          name: apache-httpd-index-updater
          resources: {}
          securityContext:
            capabilities:
              drop:
                - CAP_MKNOD
                - CAP_NET_RAW
                - CAP_AUDIT_WRITE
          volumeMounts:
            - mountPath: /usr/local/apache2/htdocs
              name: webserver-data-pvc
      initContainers:
        - command:
            - sh
            - -c
            - echo "Static Website Init" > /usr/local/apache2/htdocs/index.html
          image: docker.io/library/busybox:latest
          name: apache-httpd-init
          resources: {}
          securityContext:
            capabilities:
              drop:
                - CAP_MKNOD
                - CAP_NET_RAW
                - CAP_AUDIT_WRITE
          volumeMounts:
            - mountPath: /usr/local/apache2/htdocs
              name: webserver-data-pvc
      restartPolicy: Never
      volumes:
        - name: webserver-data-pvc
          persistentVolumeClaim:
            claimName: webserver-data
    




```bash
# Export to a manifest

podman generate kube dynamic-webserver | yq 'del(.metadata.annotations , .metadata.creationTimestamp , .status)' --yaml-output > tests/dynamic-webserver-pod.yaml
```

    


