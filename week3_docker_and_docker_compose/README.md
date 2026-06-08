# Vitualization

Virtualization is a technology that allows you to create virtual, simulated environments from a single, physical machine. Through this process, IT professionals can make use out of their previous investments and optimize a physical machine’s full capacity by distributing resources that are traditionally bound to hardware across many different environments.

## How does virtualization work?

Virtualization depends on 2 important concepts: virtual machines and hypervisors.

### Virtual machines

A virtual machine (VM) is a computing environment that functions as an isolated system with its own CPU, operating system (OS), memory, network interface, and storage, created from a pool of hardware resources. A VM can be defined by a single data file. As an isolated environment, it can be moved from 1 computer to another, opened in either, and be expected to work the same.

### Hypervisors

Sometimes called a virtual machine monitor (VMM), a hypervisor is software that separates a system’s physical resources and divides those resources so that virtual environments can use them as needed. A hypervisor takes physical resources (such as CPU, memory, and storage) from the hardware and allocates them to multiple VMs at once, enabling the creation of new VMs and the management of existing ones. Hypervisors can sit on top of an operating system (like on a laptop) or be installed directly onto hardware (like a server). The physical hardware, when used as a hypervisor, is called the host, while the many VMs that use its resources are guests.

When the virtual environment is running and a user or program issues an instruction that requires additional resources from the physical environment, the hypervisor relays the request to the physical system and stores the changes in a cache—which all happens at close to native speed.

There are 2 different types of hypervisors that allow virtualization to happen based on need.

**Type 1:** 

Also referred to as a native or bare-metal hypervisor, it runs directly on the host’s hardware to manage guest operating systems. It takes the place of a host operating system, and VM resources are scheduled directly to the hardware by the hypervisor. This type of hypervisor is most common in an enterprise datacenter or other server-based environments.

**Type 2:**

Also known as a hosted hypervisor, it runs on a conventional operating system as a software layer or application. It works by abstracting guest operating systems from the host operating system. VM resources are scheduled against a host operating system, which is then executed against the hardware. This type is better for individual users who want to run multiple operating systems on a personal computer.

### Virtualization vs. containerization

![Virtualization vs containerization](https://www.aquasec.com/wp-content/uploads/2023/11/WIKI-Malware-Detection-AA0723-4-_Recovered_-1024x634.png)

```
+---------------------------+     +-----------------------------+
|  VIRTUAL MACHINES         |     |  CONTAINERS (Docker)        |
+---------------------------+     +-----------------------------+
|  App A  |  App B  |  App C|     |  App A  |  App B  |  App C  |
+---------------------------+     +-----------------------------+
| Guest OS| Guest OS| GuestOS     |  Container Runtime (Docker) |
+---------------------------+     +-----------------------------+
|       Hypervisor          |     |        Host OS              |
+---------------------------+     +-----------------------------+
|     Physical Hardware     |     |     Physical Hardware       |
+---------------------------+     +-----------------------------+
```
```

| Feature            | Virtual Machines                       | Docker Containers                       |
| ------------------ | -------------------------------------- | --------------------------------------- |
| **OS**             | Each VM has its own full OS            | Share the host OS kernel                |
| **Size**           | GBs (includes full OS)                 | MBs (just app + dependencies)           |
| **Startup time**   | Minutes                                | Seconds or milliseconds                 |
| **Performance**    | Near-native but with overhead          | Near-native, minimal overhead           |
| **Isolation**      | Strong (hardware-level)                | Process-level (namespace isolation)     |
| **Portability**    | Less portable (OS-dependent)           | Highly portable                         |
| **Resource usage** | Heavy (RAM, CPU, disk)                 | Lightweight                             |
| **Boot time**      | 1–5 minutes                            | < 1 second                              |
| **Use case**       | Running different OSes, full isolation | Microservices, CI/CD, cloud-native apps |
| **Technology**     | Hypervisor (VMware, Hyper-V)           | Container runtime (Docker, containerd)  |
```


# Containerization

In the world of computing, containerization is a term that has gained huge attention and popularity in recent years. A container is a lightweight alternative to full machine virtualization, which involves encapsulating an application in an isolated operating environment, with all the files and libraries it needs to operate. Every containerized application can share the host system’s user space, while still maintaining its individual system processes, environment variables, and libraries.

Containerization offers a range of benefits, including rapid deployment, portability, and scalability. It allows developers to create predictable environments that are isolated from other applications, reducing the risk of system instability or conflicts between applications. It also enables them to package their software with all of its dependencies, which can then be run on any system running a container engine, regardless of its specific configuration.

Furthermore, containerization supports the microservices architecture, where applications are broken down into small, independent services. This approach allows for faster and more reliable deployment, and more effective management of complex applications.

Docker is the dominant containerization tool, holding 86.17% of the market share, primarily used for building and managing containers.

## Docker

**1. What is Docker?**

Docker is an open-source **platform for developing, shipping, and running applications** inside lightweight, portable units called **containers**. It was first released in 2013 by Solomon Hykes at dotCloud.

Docker allows developers to package an application along with all its dependencies (libraries, configs, runtime) into a single container image, ensuring the app runs **consistently across any environment**: development, staging, or production.

> **"Build once, run anywhere"**: the core philosophy of Docker.

### Key Benefits

- Eliminates the "it works on my machine" problem
- Fast startup time (milliseconds vs minutes for VMs)
- Lightweight: containers share the host OS kernel
- Easily scalable and portable
- Ideal for microservices architecture and CI/CD pipelines

---

### Docker Architecture

![DOcker architecture](https://media.geeksforgeeks.org/wp-content/uploads/20251218122638607429/docker_host.webp)

Docker uses a client–server architecture. The Docker client talks to the Docker Daemon, which builds, runs, and manages containers. They communicate through a REST API via UNIX sockets or a network interface.

**Docker Client:** It is the primary interface for users. When you execute commands such as docker run or docker build, the client translates them into REST API requests and sends them to the Docker Daemon.

**Docker Host:** This is the machine where the magic happens. It runs the Docker Daemon (dockerd) and provides the environment to execute and run containers.

**Docker Registry:** This is a remote repository for storing and distributing your Docker images.


### Docker Objects

Whenever we are using a docker, we are creating and use images, containers, volumes, networks, and other objects.

**1. Images** An image is a read-only, inert template that contains the instructions for creating a Docker container. Think of it as a blueprint or a class in object-oriented programming. It's built from a Dockerfile, a simple text file defining the steps to assemble the image. Images are built in layers, where each instruction in the Dockerfile corresponds to a layer. This layered architecture makes builds and distribution incredibly efficient.

![Docker iimage object](https://media.geeksforgeeks.org/wp-content/uploads/20260206152613048594/docker_images.webp)

**2. Containers**
A container is a runnable, live instance of an image. If an image is the blueprint, a container is the house built from that blueprint. You can create, start, stop, move, or delete containers using the Docker API or CLI. Each container is isolated from other containers and the host machine, having its own filesystem, networking, and process space. You can run multiple containers from the same image.

![Docker containers object](https://media.geeksforgeeks.org/wp-content/uploads/20260206152613251399/docker_containers.webp)


**3. Storage:** Since a container's writable layer is ephemeral (data is lost when the container is deleted), Docker provides robust solutions for data persistence. Storage driver controls and manages the images and containers on our docker host. 

***Types of Docker Storage*** Docker provides multiple storage options to persist, share, and manage data across containers and hosts.

- Volumes: The preferred mechanism. Volumes are managed by Docker and stored in a dedicated area on the host filesystem (e.g., /var/lib/docker/volumes/ on Linux). They are designed to survive the container lifecycle.

- Bind Mounts: Allow you to map a file or directory from the host machine directly into a container. This is very useful for development, where you might want to share source code with a container.

![Docker storage](https://media.geeksforgeeks.org/wp-content/uploads/20260206152612206897/docker_storage.webp)



### Docker Networking 

Docker networking provides complete isolation for docker containers. It means a user can link a docker container to many networks. It requires very less OS instances to run the workload.

#### Types of Docker Network 

**1. Bridge:** It is the default network driver. We can use this when different containers communicate with the same docker host.
**2.Host:** When you don't need any isolation between the container and host then it is used.
**3. Overlay:** For communication with each other, it will enable the swarm services.
**4. None:** It disables all networking.
**5. macvlan:** Assigns a unique MAC address to a container, making it appear as a physical device on your network.


### Run the command: docker run -d -p 80:80 nginx

![Step by step execution of a docker command](https://media.geeksforgeeks.org/wp-content/uploads/20250828152954213102/client.webp)

**1. Client:** The Docker Client sends a REST API request to the Docker Daemon to create and run a container from the nginx image.

**2. Daemon:** The Daemon receives the request. It first checks if the nginx image exists locally on the Host.

**3. Registry (Pull):** If the image is not found locally, the Daemon contacts the configured Registry (Docker Hub by default) and pulls the nginx image.

**4. Runtime (containerd):** The Daemon passes the image and run-configuration over to containerd.

**5.Runtime (runc):** containerd uses runc to create a new container. runc interfaces with the Linux kernel to create isolated namespaces and limit resources with cgroups.

**6. Execution:** The container is started. Docker maps port 80 of the host to port 80 of the nginx container, as requested by the -p 80:80 flag. The Nginx process runs as PID 1 inside the container's isolated PID namespace.

### Docker compose

Docker Compose is a lightweight orchestration tool for defining and running multi-container Docker applications. In a typical setup, services like a web server, backend API, database, and cache run in separate containers. It allows you to configure and manage them together as a single application using one docker-compose.yml file.

![Docker compose](https://media.geeksforgeeks.org/wp-content/uploads/20250906170259714869/docker_compose_environment.webp)

Docker is excellent at creating and running individual containers, managing the lifecycle and communication between them manually presents significant challenges:

**Complex Configuration:** Running each container requires long and complex docker run commands with flags for networking, ports, volumes, and environment variables. This becomes difficult to manage and reproduce consistently.

**Manual Networking:** To make containers talk to each other, you would have to manually create Docker networks, find the internal IP address of each container, and hardcode these fragile, temporary IPs into your application's code.

**Lack of Reproducibility:** A manual setup is prone to human error and makes it incredibly difficult to ensure that the application runs the same way on a developer's machine, a testing server, and in production. This is the classic "it works on my machine" problem.

Docker Compose directly addresses these issues by providing a declarative, automated, and reproducible way to manage your entire application stack. You declare the desired state of your application in the YAML file, and Docker Compose handles the rest.

### Networking in Compose

Compose handles networking for you by default, but gives you fine-grained control when you need it.

By default, Compose sets up a single network for your app. Each container for a service joins the default network and is both reachable by other containers on that network, and discoverable by its service name. This network uses the bridge driver. To understand when you'd use a different driver, see Network drivers: bridge vs host.

For most development setups, the default network is sufficient. When you run docker compose up, Compose creates a network named <project-name>_default and attaches all services to it. Each service registers its name with an internal DNS server, so containers can reach each other using the service name directly. No IP addresses or manual configuration is needed.

Docker assigns container IP addresses dynamically from the network's subnet each time a container starts so they are not persisted across restarts or recreations. This means you should always reference services by name, not IP address. When containers are recreated, for example after a configuration change, they receive a new IP address. The service name stays stable.


## Essential Docker commands

```bash
# =========================
# DOCKER ESSENTIAL COMMANDS
# =========================

# Check Docker version (installed client & server info)
docker version
# -> Shows Docker engine + CLI version details

# System-wide info about Docker
docker info
# -> Displays system status, containers, images, storage, etc.

# -------------------------
# IMAGE COMMANDS
# -------------------------

# Download an image from Docker Hub
docker pull nginx
# -> Downloads nginx image to local machine

# List all downloaded images
docker images
# -> Shows all available images locally

# Remove an image
docker rmi nginx
# -> Deletes nginx image from local storage

# Build image from Dockerfile
docker build -t myapp .
# -> Creates an image named "myapp" from current directory

# Tag an image
docker tag myapp myrepo/myapp:v1
# -> Assigns a version/repo tag to image

# -------------------------
# CONTAINER COMMANDS
# -------------------------

# Run a container
docker run nginx
# -> Starts a container from nginx image

# Run container in background (detached mode)
docker run -d nginx
# -> Runs container in background

# Run with port mapping
docker run -d -p 8080:80 nginx
# -> Maps host port 8080 -> container port 80

# List running containers
docker ps
# -> Shows active containers

# List all containers (including stopped)
docker ps -a
# -> Shows all containers

# Stop a running container
docker stop container_id
# -> Gracefully stops container

# Start a stopped container
docker start container_id
# -> Restarts existing container

# Restart a container
docker restart container_id
# -> Stops + starts container again

# Remove a container
docker rm container_id
# -> Deletes stopped container

# Force remove running container
docker rm -f container_id
# -> Forces deletion even if running

# View logs of container
docker logs container_id
# -> Shows container output logs

# Execute command inside container
docker exec -it container_id /bin/bash
docker exec -it container_id sh # for alpine images
# -> Opens interactive shell inside container

# rename a container
docker rename oldname newname


docker run -d -p 80:80 --name kailashapp -e MYSQL_ROOT_PASSWORD=root myapp:1.2

# -------------------------
# NETWORK COMMANDS
# -------------------------

# List networks
docker network ls
# -> Shows all Docker networks

# Create a network
docker network create my_network
# -> Creates a custom bridge network

# Inspect network details
docker network inspect my_network
# -> Shows configuration of network

# Connect container to network
docker network connect my_network container_id
# -> Attaches container to network

# Disconnect container from network
docker network disconnect my_network container_id
# -> Removes container from network

# -------------------------
# VOLUME COMMANDS
# -------------------------

# List volumes
docker volume ls
# -> Shows all Docker volumes

# Create volume
docker volume create my_volume
# -> Creates persistent storage volume

# Inspect volume
docker volume inspect my_volume
# -> Shows volume details

# Remove volume
docker volume rm my_volume
# -> Deletes volume

docker run -v <host_path>:<container_path> <image>

docker run -v /home/user/data:/app/data:ro nginx # read only mount

docker run --mount type=<bind|volume>,source=<src>,target=<dst> <image>
docker run --mount type=bind,source=/home/user/data,target=/app/data,readonly nginx

# -------------------------
# SYSTEM CLEANUP COMMANDS
# -------------------------

# Remove unused containers, networks, images
docker system prune
# -> Cleans unused Docker resources

# Remove everything unused (including images)
docker system prune -a
# -> Aggressive cleanup

# Show disk usage
docker system df
# -> Displays Docker storage usage

# -------------------------
# DOCKER COMPOSE (MULTI-CONTAINER)
# -------------------------

# Start services
docker compose up
# -> Starts all services in docker-compose.yml

# Run in background
docker compose up -d
# -> Detached mode

# Stop services
docker compose down
# -> Stops and removes containers

# Build services
docker compose build
# -> Builds images defined in compose file

# View logs
docker compose logs
# -> Shows logs of all services

docker compose up --force-recreate

```


# REFERENCES

- https://www.redhat.com/en/topics/virtualization/what-is-virtualization
- https://docs.docker.com/compose/
- https://docs.docker.com/engine/reference/commandline/compose/
- https://github.com/dockersamples/example-voting-app
- https://www.aquasec.com/cloud-native-academy/docker-container/containerization-vs-virtualization/
- https://www.geeksforgeeks.org/devops/architecture-of-docker/
- https://www.mygreatlearning.com/blog/top-essential-docker-commands/
- https://www.geeksforgeeks.org/devops/docker-compose/
- https://docs.docker.com/compose/how-tos/networking/
