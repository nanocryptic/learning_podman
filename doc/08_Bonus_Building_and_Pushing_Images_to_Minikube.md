# Bonus Lecture: Building and Pushing images to Minikube's Registry

In some scenarios you might require to build images locally. 
If you need to make those images available locally for local Kubernetes development / testing / deployments, a registry is required.

The best solution is to use a fully secure and qualified registry, though for testing it is possibe to get an insecure registry out of minikube and use that as the registry for both local development on the developer's machine and in minikubes' kubernetes.

The method consists in:

1. Enable the registry as a minikube add-on
1. Forward the port locally from the Pod to the developer's machine, so that it is available as `localhost:5000` (the default docker accepted insecure registry)
1. Configure the registry as insecure for Podman
1. Reverse-forward the port from the mac to the podman machine with SSH


```bash
minikube addons enable registry
```

    ╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │                                                                                                      │
    │    Registry addon with podman driver uses port 32787 please use that instead of default port 5000    │
    │                                                                                                      │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯
    📘  For more information see: https://minikube.sigs.k8s.io/docs/drivers/podman
        ▪ Using image registry:2.7.1
        ▪ Using image gcr.io/google_containers/kube-registry-proxy:0.4
    🔎  Verifying registry addon...
    🌟  The 'registry' addon is enabled
    




```bash
export REGISTRY_POD=$(kubectl -n kube-system get pods | awk '/registry-proxy/{ print $1 }')
```

    




```bash
echo $REGISTRY_POD
```

    registry-proxy-ghj8w
    




```bash
kubectl -n kube-system port-forward --address localhost pods/${REGISTRY_POD} 5000:80 &
```

    [1] 17580
    



## Configure the local registries to add the insecure localhost:5000

```
cat ~/.config/containers/registries.conf

[[registry]]
location="localhost:5000"
insecure=true
```

## Configure Podman's registries to add the insecure localhost:5000

```
podman machine ssh

[root@localhost ~]# cat /etc/containers/registries.conf.d/100-insecure-localhost.conf 
[[registry]]
location="localhost:5000"
insecure=true
```



```bash
export PODMAN_MACHINE_NAME=$(podman machine list -q --format '{{.Name}}')
echo $PODMAN_MACHINE_NAME
```

    podman-machine-default



```bash
export PODMAN_SSH_KEY=$(podman system connection list | grep "${PODMAN_MACHINE_NAME}" | awk '{ print $3 }' | sort | uniq)
echo $PODMAN_SSH_KEY
```

    /Users/guillem.riera/.ssh/podman-machine-default



```bash
export PODMAN_URI=$(podman system connection list | grep root | grep "${PODMAN_MACHINE_NAME}" | awk '{ print $2 }' | sort | uniq)
echo $PODMAN_URI
```

    ssh://root@localhost:50828/run/podman/podman.sock



```bash
export PODMAN_PORT=$(echo $PODMAN_URI | sed -e 's|ssh://\(.*\)@\(.*\):\([0-9]*\)/\(.*\)|\3|g')
echo $PODMAN_PORT
```

    50828



```bash
export PODMAN_USER=$(echo $PODMAN_URI | sed -e 's|ssh://\(.*\)@\(.*\):\([0-9]*\)/\(.*\)|\1|g')

echo "$PODMAN_USER"
```

    root



```bash
export PODMAN_HOSTNAME=$(echo $PODMAN_URI | sed -e 's|ssh://\(.*\)@\(.*\):\([0-9]*\)/\(.*\)|\2|g')
echo $PODMAN_HOSTNAME
```

    localhost



```bash
export REGISTRY_PORT=5000
ssh -i $PODMAN_SSH_KEY -p $PODMAN_PORT ${PODMAN_USER}@${PODMAN_HOSTNAME} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -f -N -T -R ${REGISTRY_PORT}:localhost:${REGISTRY_PORT}
```

    Warning: Permanently added '[localhost]:50828' (ED25519) to the list of known hosts.
    



## Building and Tagging images properly

Now it is necessary to tag the image to target this registry properly.



```bash
podman build -t localhost:5000/httpd:podman build-and-deploy
```

    STEP 1/2: FROM httpd:2.4
    STEP 2/2: COPY src/index.html /usr/local/apache2/htdocs/index.html
    --> Using cache 0f73b88b47dcbdeb6fc35e3b7e193cb54d4cd582519304be864eeca992aa3e22
    COMMIT localhost:5000/httpd:podman
    --> 0f73b88b47d
    Successfully tagged localhost:5000/httpd:podman
    0f73b88b47dcbdeb6fc35e3b7e193cb54d4cd582519304be864eeca992aa3e22
    




```bash
podman push localhost:5000/httpd:podman
```

    




```bash
# Check in podman that the registry is properly forwarded by querying the API Catalog

podman machine ssh 'curl -v localhost:5000/v2/_catalog'
```

    Warning: Permanently added '[localhost]:50828' (ED25519) to the list of known hosts.
    bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
    /usr/bin/sh: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
    /usr/bin/sh: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
    /usr/bin/sh: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
    *   Trying 127.0.0.1:5000...
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
      0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* Connected to localhost (127.0.0.1) port 5000 (#0)
    > GET /v2/_catalog HTTP/1.1
    > Host: localhost:5000
    > User-Agent: curl/7.82.0
    > Accept: */*
    > 
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < Server: nginx/1.11.8
    < Date: Tue, 26 Jul 2022 13:52:21 GMT
    < Content-Type: application/json; charset=utf-8
    < Content-Length: 27
    < Connection: keep-alive
    < Docker-Distribution-Api-Version: registry/2.0
    < X-Content-Type-Options: nosniff
    < 
    { [27 bytes data]
    100    27  100    27    0     0   2074      0 --:--:-- --:--:-- --:--:--  2250
    * Connection #0 to host localhost left intact
    {"repositories":["httpd"]}
    




```bash
kubectl run httpd-podman --image localhost:5000/httpd:podman --port 80
```

    pod/httpd-podman created
    




```bash
kubectl port-forward pods/httpd-podman 8081:80 &
```

    [1] 19527
    




```bash
curl -s localhost:8081
```

    Forwarding from 127.0.0.1:8081 -> 80
    Forwarding from [::1]:8081 -> 80
    Handling connection for 8081
    Built with Podman
    



## Cleanup


```bash
KUBE_FORWARD=$(ps -ef | grep kubectl | grep 8081 | awk '{ print $2 }')
if [[ ! -z $KUBE_FORWARD ]]; then kill -KILL $KUBE_FORWARD; fi
```

    




```bash
KUBE_FORWARD=$(ps -ef | grep kubectl | grep $REGISTRY_PORT | awk '{ print $2 }')
if [[ ! -z $KUBE_FORWARD ]]; then kill -KILL $KUBE_FORWARD; fi
```

    




```bash
SSH_REVERSE_FORWARD=$(ps -ef | grep ssh | grep $REGISTRY_PORT | awk '{ print $2 }')
if [[ ! -z $SSH_REVERSE_FORWARD ]]; then kill -KILL $SSH_REVERSE_FORWARD; fi
```

    


