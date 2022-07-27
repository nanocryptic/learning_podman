# Container Volume Mounts

A Volume Mount is a way to give a Container a mounted filesystem, specified by a path.

With mounts you achieve:

- Provide data avoiding embedding actual data in the same container
- Reduce overhead and improve storage read/write performance
- Share content

There are 2 kinds of volumes in respect to the host:

- Volume mounts from the host (for example, from macOS to the Podman Machine)
- Named volumes (only available to the container engine)


## Accessing a file using a volume mount

Accessing a file from the host (macOS) within the container requires a volume mount.

Let's create a sample file and see how this works:


```bash
# Create a sample folder and file
mkdir -p tests/volume/
echo "volume test, this is accessed by the busybox container" > tests/volume/test
```


```bash
# Now let's mount the filesystem and access it on the container
podman run -it --rm -v $PWD/tests:/tests  busybox cat /tests/volume/test
```

    Resolved "busybox" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
    Trying to pull docker.io/library/busybox:latest...
    Getting image source signatures
    Copying blob sha256:87379020f3b6731a4b64976e614d305f5c121d153c049d14ba600ff24bbac012
    Copying blob sha256:87379020f3b6731a4b64976e614d305f5c121d153c049d14ba600ff24bbac012
    Copying config sha256:3c19bafed22355e11a608c4b613d87d06b9cdd37d378e6e0176cbc8e7144d5c6
    Writing manifest to image destination
    Storing signatures
    volume test, this is accessed by the busybox container


## Named Volume Mounts

A _named volume mount_ is a mount of a volume by name:
- A volume needs to exist and have a name (needs to be created previous to the volume mount)
- The volume's name is then passed to the left side of the `:` on the volume binding argument
- The container runtime understands each `non-path` argument on the left side of the binding `:` as a named volume.


### Testing persistence through volume binding

We will create a sample volume and run some commands within different containers to fill a file with data.

The containers will be removed after each execution (`--rm` flag), but the data will be persisted.


```bash
podman volume create sample-volume
```

    sample-volume



```bash
podman run --rm --name busybox-with-volume -v sample-volume:/data busybox sh -c 'date >> /data/persistent_data.txt && cat /data/persistent_data.txt'
```

    Tue Jul 26 15:58:23 UTC 2022



```bash
podman run --rm --name busybox-with-volume -v sample-volume:/data busybox sh -c 'date >> /data/persistent_data.txt && cat /data/persistent_data.txt'
```

    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022



```bash
for c in $(seq 1 10); do
    podman run --rm -v sample-volume:/data busybox sh -c 'date >> /data/persistent_data.txt && cat /data/persistent_data.txt'
done
```

    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:40 UTC 2022
    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:40 UTC 2022
    Tue Jul 26 15:58:41 UTC 2022
    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:40 UTC 2022
    Tue Jul 26 15:58:41 UTC 2022
    Tue Jul 26 15:58:42 UTC 2022
    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:40 UTC 2022
    Tue Jul 26 15:58:41 UTC 2022
    Tue Jul 26 15:58:42 UTC 2022
    Tue Jul 26 15:58:43 UTC 2022
    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:40 UTC 2022
    Tue Jul 26 15:58:41 UTC 2022
    Tue Jul 26 15:58:42 UTC 2022
    Tue Jul 26 15:58:43 UTC 2022
    Tue Jul 26 15:58:43 UTC 2022
    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:40 UTC 2022
    Tue Jul 26 15:58:41 UTC 2022
    Tue Jul 26 15:58:42 UTC 2022
    Tue Jul 26 15:58:43 UTC 2022
    Tue Jul 26 15:58:43 UTC 2022
    Tue Jul 26 15:58:44 UTC 2022
    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:40 UTC 2022
    Tue Jul 26 15:58:41 UTC 2022
    Tue Jul 26 15:58:42 UTC 2022
    Tue Jul 26 15:58:43 UTC 2022
    Tue Jul 26 15:58:43 UTC 2022
    Tue Jul 26 15:58:44 UTC 2022
    Tue Jul 26 15:58:45 UTC 2022
    Tue Jul 26 15:58:23 UTC 2022
    Tue Jul 26 15:58:28 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:39 UTC 2022
    Tue Jul 26 15:58:40 UTC 2022
    Tue Jul 26 15:58:41 UTC 2022
    Tue Jul 26 15:58:42 UTC 2022
    Tue Jul 26 15:58:43 UTC 2022
    Tue Jul 26 15:58:43 UTC 2022
    Tue Jul 26 15:58:44 UTC 2022
    Tue Jul 26 15:58:45 UTC 2022
    Tue Jul 26 15:58:46 UTC 2022


### Clean up the sample volume

Note: Deleting a volume erases the data within.


```bash
podman volume rm sample-volume
```

    sample-volume

