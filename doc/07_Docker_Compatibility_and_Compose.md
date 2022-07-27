# Docker Compatibility: Docker and Docker Compose

While most podman users will just perform a simple `alias docker=podman` in their terminals, there are more compatibility layers between them.

For example:

- Podman can expose a socket for the docker CLI, making it possible to use it to run containers with a Podman engine
- Podman can run docker-compose files with `podman-compose`, which is optional

Lets check both!

Make sure you installed the optional helper (check Chapter 0, Install Podman) as well as the docker CLI.


```bash
which docker
```

    /opt/homebrew/bin/docker
    




```bash
docker --version
```

    Docker version 20.10.17, build 100c70180f
    




```bash
docker ps
```

    CONTAINER ID   IMAGE                                 COMMAND   CREATED             STATUS             PORTS                                             NAMES
    5013a0794fd7   gcr.io/k8s-minikube/kicbase:v0.0.32   ""        About an hour ago   Up About an hour   22/tcp, 2376/tcp, 5000/tcp, 8443/tcp, 32443/tcp   minikube
    




```bash
podman --version
```

    podman version 4.1.1
    




```bash
podman ps
```

    CONTAINER ID  IMAGE                                COMMAND     CREATED            STATUS                PORTS                                                                                                                       NAMES
    5013a0794fd7  gcr.io/k8s-minikube/kicbase:v0.0.32              About an hour ago  Up About an hour ago  0.0.0.0:38965->22/tcp, 0.0.0.0:42903->2376/tcp, 0.0.0.0:32787->5000/tcp, 0.0.0.0:33043->8443/tcp, 0.0.0.0:42707->32443/tcp  minikube
    



## Docker Compose

Podman can compose images the same way docker can.

After installing the optional package (`docker-compose` and `podman-compose`):


```bash
docker-compose -f compose/wordpress-compose.yaml up -d
```

    [+] Running 2/0
     ⠿ Container compose-wordpress-1  Runni...                                 0.0s
     ⠿ Container compose-db-1         Running                                  0.0s
    




```bash
docker-compose -f compose/wordpress-compose.yaml down
```

    




```bash
podman-compose -f compose/wordpress-compose.yaml up -d
```

    ['podman', '--version', '']
    using podman version: 4.1.1
    ** excluding:  set()
    podman volume inspect compose_db_data || podman volume create compose_db_data
    ['podman', 'volume', 'inspect', 'compose_db_data']
    ['podman', 'network', 'exists', 'compose_default']
    podman run --name=compose_db_1 -d --label io.podman.compose.config-hash=123 --label io.podman.compose.project=compose --label io.podman.compose.version=0.0.1 --label com.docker.compose.project=compose --label com.docker.compose.project.working_dir=/Users/guillem.riera/Git/code.intive.com/lnd/podman/compose --label com.docker.compose.project.config_files=compose/wordpress-compose.yaml --label com.docker.compose.container-number=1 --label com.docker.compose.service=db -e MYSQL_ROOT_PASSWORD=somewordpress -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress -v compose_db_data:/var/lib/mysql --net compose_default --network-alias db --expose 3306 --expose 33060 --restart always mariadb:10.6.4-focal --default-authentication-plugin=mysql_native_password
    84573610d178bed4b3d59971874ba560b75f9a0b713e3e8d13492ccc5b52212f
    exit code: 0
    ['podman', 'network', 'exists', 'compose_default']
    podman run --name=compose_wordpress_1 -d --label io.podman.compose.config-hash=123 --label io.podman.compose.project=compose --label io.podman.compose.version=0.0.1 --label com.docker.compose.project=compose --label com.docker.compose.project.working_dir=/Users/guillem.riera/Git/code.intive.com/lnd/podman/compose --label com.docker.compose.project.config_files=compose/wordpress-compose.yaml --label com.docker.compose.container-number=1 --label com.docker.compose.service=wordpress -e WORDPRESS_DB_HOST=db -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress -e WORDPRESS_DB_NAME=wordpress --net compose_default --network-alias wordpress -p 80:80 --restart always wordpress:latest
    06464cd26cabba2f250ecd18c39ad6a04418ed2146a9b1890591d169e6600e9c
    exit code: 0
    




```bash
podman-compose -f compose/wordpress-compose.yaml down
```

    ['podman', '--version', '']
    using podman version: 4.1.1
    ** excluding:  set()
    podman stop -t 10 compose_wordpress_1
    compose_wordpress_1
    exit code: 0
    podman stop -t 10 compose_db_1
    compose_db_1
    exit code: 0
    podman rm compose_wordpress_1
    06464cd26cabba2f250ecd18c39ad6a04418ed2146a9b1890591d169e6600e9c
    exit code: 0
    podman rm compose_db_1
    84573610d178bed4b3d59971874ba560b75f9a0b713e3e8d13492ccc5b52212f
    exit code: 0
    


