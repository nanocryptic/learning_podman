# Podman First Steps

Podman stands for Pod Manager (more on Pods later in Chapter 4).

Podman can be controlled over its API, using either REST over HTTP/S or Socket (those methods are called transports).

If you are comfortable using Docker then you'll find yourself at home using Podman's API, as it is compatible.

Even the CLI uses the exact same format and verbs as Docker.

## Running Containers

Let's pull and run a web server (nginx) container:


```bash
podman run -d --name nginx-test-on-podman -p 8080:80 docker.io/library/nginx:latest
```

    Trying to pull docker.io/library/nginx:latest...
    Getting image source signatures
    Copying blob sha256:ffd8ca24cbfe81fd4f8b342b0f8ef7918e26f01d33c7cf707b8bcd6181ef0b36
    Copying blob sha256:ffd8ca24cbfe81fd4f8b342b0f8ef7918e26f01d33c7cf707b8bcd6181ef0b36
    Copying blob sha256:60197a4c18d4b386d371cf39d01c48e98c357bba06da0b070a3c1f75006fd838
    Copying blob sha256:9165df2e005e2c19f864ca86c031cc83376298dc4dfa2507bcae84c5611ff055
    Copying blob sha256:b256ad6ff1efd2f82c0b1fd46e1138072929d8983116ab05f2ae6f02cdfda611
    Copying blob sha256:8d709bf60afdda8d93d24bc5bad0adf974f453db2daf8172cc102fcfead7974c
    Copying blob sha256:1d2347fdb4adb624a4d2f59cce39525f18ecc3a64c85db84c17f10f84ee03964
    Copying blob sha256:1d2347fdb4adb624a4d2f59cce39525f18ecc3a64c85db84c17f10f84ee03964
    Copying blob sha256:9165df2e005e2c19f864ca86c031cc83376298dc4dfa2507bcae84c5611ff055
    Copying blob sha256:b256ad6ff1efd2f82c0b1fd46e1138072929d8983116ab05f2ae6f02cdfda611
    Copying blob sha256:8d709bf60afdda8d93d24bc5bad0adf974f453db2daf8172cc102fcfead7974c
    Copying config sha256:fd2d3e51789eafe943eec792c81e5297ae23570f2a24ed239118f3226e74a1cc
    Writing manifest to image destination
    Storing signatures
    517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357


## Testing the Seamless Port-Forwarding

Podman forwards the ports from the Podman machine seamlessly to the host.
This means that the port 8080 from the previous example is open for connection on the `localhost` and forwards the request to the port 80 on the container.


```bash
curl -v http://localhost:8080
```

    *   Trying 127.0.0.1:8080...
    * Connected to localhost (127.0.0.1) port 8080 (#0)
    > GET / HTTP/1.1
    > Host: localhost:8080
    > User-Agent: curl/7.79.1
    > Accept: */*
    > 
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < Server: nginx/1.23.1
    < Date: Tue, 26 Jul 2022 15:57:04 GMT
    < Content-Type: text/html
    < Content-Length: 615
    < Last-Modified: Tue, 19 Jul 2022 14:05:27 GMT
    < Connection: keep-alive
    < ETag: "62d6ba27-267"
    < Accept-Ranges: bytes
    < 
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
    html { color-scheme: light dark; }
    body { width: 35em; margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif; }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>
    
    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>
    
    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>
    * Connection #0 to host localhost left intact


## Listing Containers


```bash
podman ps
```

    CONTAINER ID  IMAGE                                COMMAND               CREATED         STATUS             PORTS                                                                                                                       NAMES
    5013a0794fd7  gcr.io/k8s-minikube/kicbase:v0.0.32                        4 hours ago     Up 4 hours ago     0.0.0.0:38965->22/tcp, 0.0.0.0:42903->2376/tcp, 0.0.0.0:32787->5000/tcp, 0.0.0.0:33043->8443/tcp, 0.0.0.0:42707->32443/tcp  minikube
    517daf73af7c  docker.io/library/nginx:latest       nginx -g daemon o...  27 seconds ago  Up 28 seconds ago  0.0.0.0:8080->80/tcp                                                                                                        nginx-test-on-podman


## Inspecting Containers


```bash
podman inspect nginx-test-on-podman
```

    [
         {
              "Id": "517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357",
              "Created": "2022-07-26T17:56:43.6595016+02:00",
              "Path": "/docker-entrypoint.sh",
              "Args": [
                   "nginx",
                   "-g",
                   "daemon off;"
              ],
              "State": {
                   "OciVersion": "1.0.2-dev",
                   "Status": "running",
                   "Running": true,
                   "Paused": false,
                   "Restarting": false,
                   "OOMKilled": false,
                   "Dead": false,
                   "Pid": 126215,
                   "ConmonPid": 126212,
                   "ExitCode": 0,
                   "Error": "",
                   "StartedAt": "2022-07-26T17:56:43.830436029+02:00",
                   "FinishedAt": "0001-01-01T00:00:00Z",
                   "Health": {
                        "Status": "",
                        "FailingStreak": 0,
                        "Log": null
                   },
                   "CgroupPath": "/machine.slice/libpod-517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357.scope",
                   "CheckpointedAt": "0001-01-01T00:00:00Z",
                   "RestoredAt": "0001-01-01T00:00:00Z"
              },
              "Image": "fd2d3e51789eafe943eec792c81e5297ae23570f2a24ed239118f3226e74a1cc",
              "ImageName": "docker.io/library/nginx:latest",
              "Rootfs": "",
              "Pod": "",
              "ResolvConfPath": "/run/containers/storage/overlay-containers/517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357/userdata/resolv.conf",
              "HostnamePath": "/run/containers/storage/overlay-containers/517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357/userdata/hostname",
              "HostsPath": "/run/containers/storage/overlay-containers/517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357/userdata/hosts",
              "StaticDir": "/var/lib/containers/storage/overlay-containers/517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357/userdata",
              "OCIConfigPath": "/var/lib/containers/storage/overlay-containers/517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357/userdata/config.json",
              "OCIRuntime": "crun",
              "ConmonPidFile": "/run/containers/storage/overlay-containers/517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357/userdata/conmon.pid",
              "PidFile": "/run/containers/storage/overlay-containers/517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357/userdata/pidfile",
              "Name": "nginx-test-on-podman",
              "RestartCount": 0,
              "Driver": "overlay",
              "MountLabel": "system_u:object_r:container_file_t:s0:c444,c834",
              "ProcessLabel": "system_u:system_r:container_t:s0:c444,c834",
              "AppArmorProfile": "",
              "EffectiveCaps": [
                   "CAP_CHOWN",
                   "CAP_DAC_OVERRIDE",
                   "CAP_FOWNER",
                   "CAP_FSETID",
                   "CAP_KILL",
                   "CAP_NET_BIND_SERVICE",
                   "CAP_SETFCAP",
                   "CAP_SETGID",
                   "CAP_SETPCAP",
                   "CAP_SETUID",
                   "CAP_SYS_CHROOT"
              ],
              "BoundingCaps": [
                   "CAP_CHOWN",
                   "CAP_DAC_OVERRIDE",
                   "CAP_FOWNER",
                   "CAP_FSETID",
                   "CAP_KILL",
                   "CAP_NET_BIND_SERVICE",
                   "CAP_SETFCAP",
                   "CAP_SETGID",
                   "CAP_SETPCAP",
                   "CAP_SETUID",
                   "CAP_SYS_CHROOT"
              ],
              "ExecIDs": [],
              "GraphDriver": {
                   "Name": "overlay",
                   "Data": {
                        "LowerDir": "/var/lib/containers/storage/overlay/da11adbb10994e4523d06c889de50b546641f55926093e17803eff71541ad7c6/diff:/var/lib/containers/storage/overlay/2c6a4437281110823f1fc32c3e7703fe1a3828384c7077591528d295f0946a37/diff:/var/lib/containers/storage/overlay/c9c7e64c4f75d183ad89c92e29dcef15a967c1d85b4580f8e7497d8f8d6ad6d9/diff:/var/lib/containers/storage/overlay/285ab98ddc3db60eee4d3b034054d0c0e19bb67e6bb335cbca27d5995783a3ab/diff:/var/lib/containers/storage/overlay/56af23a08b845754c79ec5b82c051ad5bc90defaee8e21a56fd399c891d954a6/diff:/var/lib/containers/storage/overlay/af32df749f3fb0040acdb0015af7b7da8f6d600572b22e9137250d3dfbe111f2/diff",
                        "MergedDir": "/var/lib/containers/storage/overlay/1e8661c896c2eda272ce4b378aa8f000659eb8aa83c6f1588ae9ec16e5060f3a/merged",
                        "UpperDir": "/var/lib/containers/storage/overlay/1e8661c896c2eda272ce4b378aa8f000659eb8aa83c6f1588ae9ec16e5060f3a/diff",
                        "WorkDir": "/var/lib/containers/storage/overlay/1e8661c896c2eda272ce4b378aa8f000659eb8aa83c6f1588ae9ec16e5060f3a/work"
                   }
              },
              "Mounts": [],
              "Dependencies": [],
              "NetworkSettings": {
                   "EndpointID": "",
                   "Gateway": "10.88.0.1",
                   "IPAddress": "10.88.0.4",
                   "IPPrefixLen": 16,
                   "IPv6Gateway": "",
                   "GlobalIPv6Address": "",
                   "GlobalIPv6PrefixLen": 0,
                   "MacAddress": "5a:44:8c:7c:6e:b7",
                   "Bridge": "",
                   "SandboxID": "",
                   "HairpinMode": false,
                   "LinkLocalIPv6Address": "",
                   "LinkLocalIPv6PrefixLen": 0,
                   "Ports": {
                        "80/tcp": [
                             {
                                  "HostIp": "",
                                  "HostPort": "8080"
                             }
                        ]
                   },
                   "SandboxKey": "/run/netns/netns-728e56e3-4e44-4f3c-ca0a-68ccb7f274d5",
                   "Networks": {
                        "podman": {
                             "EndpointID": "",
                             "Gateway": "10.88.0.1",
                             "IPAddress": "10.88.0.4",
                             "IPPrefixLen": 16,
                             "IPv6Gateway": "",
                             "GlobalIPv6Address": "",
                             "GlobalIPv6PrefixLen": 0,
                             "MacAddress": "5a:44:8c:7c:6e:b7",
                             "NetworkID": "podman",
                             "DriverOpts": null,
                             "IPAMConfig": null,
                             "Links": null,
                             "Aliases": [
                                  "517daf73af7c"
                             ]
                        }
                   }
              },
              "Namespace": "",
              "IsInfra": false,
              "Config": {
                   "Hostname": "517daf73af7c",
                   "Domainname": "",
                   "User": "",
                   "AttachStdin": false,
                   "AttachStdout": false,
                   "AttachStderr": false,
                   "Tty": false,
                   "OpenStdin": false,
                   "StdinOnce": false,
                   "Env": [
                        "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                        "TERM=xterm",
                        "container=podman",
                        "NGINX_VERSION=1.23.1",
                        "NJS_VERSION=0.7.6",
                        "PKG_RELEASE=1~bullseye",
                        "HOME=/root",
                        "HOSTNAME=517daf73af7c"
                   ],
                   "Cmd": [
                        "nginx",
                        "-g",
                        "daemon off;"
                   ],
                   "Image": "docker.io/library/nginx:latest",
                   "Volumes": null,
                   "WorkingDir": "/",
                   "Entrypoint": "/docker-entrypoint.sh",
                   "OnBuild": null,
                   "Labels": {
                        "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
                   },
                   "Annotations": {
                        "io.container.manager": "libpod",
                        "io.kubernetes.cri-o.Created": "2022-07-26T17:56:43.6595016+02:00",
                        "io.kubernetes.cri-o.TTY": "false",
                        "io.podman.annotations.autoremove": "FALSE",
                        "io.podman.annotations.init": "FALSE",
                        "io.podman.annotations.privileged": "FALSE",
                        "io.podman.annotations.publish-all": "FALSE",
                        "org.opencontainers.image.stopSignal": "3"
                   },
                   "StopSignal": 3,
                   "CreateCommand": [
                        "podman",
                        "run",
                        "-d",
                        "--name",
                        "nginx-test-on-podman",
                        "-p",
                        "8080:80",
                        "docker.io/library/nginx:latest"
                   ],
                   "Umask": "0022",
                   "Timeout": 0,
                   "StopTimeout": 10,
                   "Passwd": true
              },
              "HostConfig": {
                   "Binds": [],
                   "CgroupManager": "systemd",
                   "CgroupMode": "private",
                   "ContainerIDFile": "",
                   "LogConfig": {
                        "Type": "journald",
                        "Config": null,
                        "Path": "",
                        "Tag": "",
                        "Size": "0B"
                   },
                   "NetworkMode": "bridge",
                   "PortBindings": {
                        "80/tcp": [
                             {
                                  "HostIp": "",
                                  "HostPort": "8080"
                             }
                        ]
                   },
                   "RestartPolicy": {
                        "Name": "",
                        "MaximumRetryCount": 0
                   },
                   "AutoRemove": false,
                   "VolumeDriver": "",
                   "VolumesFrom": null,
                   "CapAdd": [],
                   "CapDrop": [
                        "CAP_AUDIT_WRITE",
                        "CAP_MKNOD",
                        "CAP_NET_RAW"
                   ],
                   "Dns": [],
                   "DnsOptions": [],
                   "DnsSearch": [],
                   "ExtraHosts": [],
                   "GroupAdd": [],
                   "IpcMode": "shareable",
                   "Cgroup": "",
                   "Cgroups": "default",
                   "Links": null,
                   "OomScoreAdj": 0,
                   "PidMode": "private",
                   "Privileged": false,
                   "PublishAllPorts": false,
                   "ReadonlyRootfs": false,
                   "SecurityOpt": [],
                   "Tmpfs": {},
                   "UTSMode": "private",
                   "UsernsMode": "",
                   "ShmSize": 65536000,
                   "Runtime": "oci",
                   "ConsoleSize": [
                        0,
                        0
                   ],
                   "Isolation": "",
                   "CpuShares": 0,
                   "Memory": 0,
                   "NanoCpus": 0,
                   "CgroupParent": "",
                   "BlkioWeight": 0,
                   "BlkioWeightDevice": null,
                   "BlkioDeviceReadBps": null,
                   "BlkioDeviceWriteBps": null,
                   "BlkioDeviceReadIOps": null,
                   "BlkioDeviceWriteIOps": null,
                   "CpuPeriod": 0,
                   "CpuQuota": 0,
                   "CpuRealtimePeriod": 0,
                   "CpuRealtimeRuntime": 0,
                   "CpusetCpus": "",
                   "CpusetMems": "",
                   "Devices": [],
                   "DiskQuota": 0,
                   "KernelMemory": 0,
                   "MemoryReservation": 0,
                   "MemorySwap": 0,
                   "MemorySwappiness": 0,
                   "OomKillDisable": false,
                   "PidsLimit": 2048,
                   "Ulimits": [
                        {
                             "Name": "RLIMIT_NOFILE",
                             "Soft": 1048576,
                             "Hard": 1048576
                        },
                        {
                             "Name": "RLIMIT_NPROC",
                             "Soft": 4194304,
                             "Hard": 4194304
                        }
                   ],
                   "CpuCount": 0,
                   "CpuPercent": 0,
                   "IOMaximumIOps": 0,
                   "IOMaximumBandwidth": 0,
                   "CgroupConf": null
              }
         }
    ]


## Stopping a running container


```bash
podman stop nginx-test-on-podman
```

    nginx-test-on-podman


## Deleting a stopped container


```bash
podman rm nginx-test-on-podman
```

    517daf73af7c9d7384f0efdf38e3ba0543b95e6d91dadec64bd540736b807357



```bash

```
