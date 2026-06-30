# Linux and Networking Revision

## Linux

Linux is a free and open source operating system based on the Linux kernel. The Linux kernel was inspired by Unix and was first developed by Linus Torvalds.

Linux is stable and requires minimal maintenance, reducing expenses.

Linux is widely used everywhere in cloud computing because it is open source, powerful, stable, and has a powerful command line interface (CLI) that enables the high level of automation, security, and scalability required in modern DevOps or cloud pipelines.

## Linux Command Line

The Linux command line is a text-based interface, also known as a shell, terminal, or console, that allows users to interact with the OS by typing text instructions rather than using a graphical user interface (GUI).

It functions as a program that interprets user commands to perform tasks such as managing files, configuring network settings, monitoring processes, and installing software.

Linux commands are case sensitive.

## File Permissions

Linux is a file-system-based operating system, where every piece of data is stored in a file and each file exists within a hierarchical structure.

File permissions are the access control mechanisms that define who can read, write, or execute specific files and directories.

These permissions are not stored within the file's data itself but as metadata managed by the file system (such as ext4) and enforced by the operating system kernel.

Traditional Unix permissions (defined by POSIX.1) organize access into three categories of users:

- **Owner**: The user who created the file.
- **Group**: The set of users assigned to the file.
- **Other**: All remaining users on the system.

For each category, there are three basic permission types:

- **Read (r)**: Allows viewing file contents or listing directory contents.
- **Write (w)**: Allows modifying file contents or adding/deleting files in a directory.
- **Execute (x)**: Allows running a file as a program or traversing a directory.

These permissions are typically represented as a 10-character string (e.g., `-rwxr-----`) or an octal number (e.g., `755`), and are managed using commands like `chmod`.

## Processes, Services, and systemd

A process is a running instance of a program. Every process has a unique process ID (PID) and uses system resources such as CPU and memory. Processes are dynamic: they start, run, and terminate as needed. Linux allows us to view, monitor, and manage processes.

Common commands:

- `ps`: Display running processes.
- `top`/`htop`: Monitor processes in real time.
- `kill`: Terminate a process by PID.
- `killall`/`pkill`: Stop a process by name.
- `jobs`, `bg`, `fg`: Manage background and foreground jobs.

A service is a background process, also called a daemon, that starts automatically or on demand to provide system or application functionality. Services usually run without user interaction.

Examples:

- **SSH**: Enables remote login.
- **NGINX**: Serves web applications.
- **Docker**: Runs containers.
- **Cron**: Schedules recurring tasks.

Services can be started, stopped, restarted, or configured to launch automatically when the system boots.

systemd is the default init system and service manager on most modern Linux distributions. It is responsible for booting the system, managing services, handling dependencies, and controlling startup processes.

Common `systemctl` commands:

```bash
systemctl status nginx
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl enable nginx
systemctl disable nginx
systemctl list-units
journalctl -u <service>   # view logs specific to a service
```

## SSH

SSH stands for Secure Shell. It is used to enable remote login.

SSH is a cryptographic network protocol designed to provide secure communication over an unsecured network. Developed in 1995 by Tatu Ylönen as a secure replacement for telnet, rlogin, and rsh, it encrypts all data transmitted between two systems, including authentication credentials.

Its primary functions include:

- **Remote login**: Securely accessing a shell on a remote host.
- **Command execution**: Running single commands on remote systems.
- **File transfer**: Securely copying files via `scp` or `sftp`.
- **Port forwarding**: Creating encrypted tunnels for other network services.

**How public key authentication works**

This method uses asymmetric cryptography (a key pair):

1. **Key generation**: The user generates a key pair — a private key (kept secret on the client) and a public key (shared with the server).
2. **Challenge-response**: When connecting, the server encrypts a challenge message using the user's public key.
3. **Verification**: Only the client with the matching private key can decrypt the message and respond correctly.
4. **Access**: Upon successful verification, the server grants access without transmitting a password.

Users can further protect their private key with a passphrase. Public keys are typically stored in the `~/.ssh/authorized_keys` file on the server.

## Cron

Cron is a time-based job scheduler in Unix-like operating systems, designed to execute commands or scripts automatically at specified intervals. It runs as a background daemon (`crond`) that wakes up every minute to check for scheduled tasks.

Its primary uses include:

1. **System maintenance**: Automating log rotation, backups, and updates.
2. **Recurring tasks**: Running reports, database cleanups, or data synchronization.
3. **Monitoring**: Executing health checks and uptime monitoring scripts.

**Cron syntax and configuration**

Tasks are defined in a crontab (cron table) file, using five time fields followed by a command:

```
minute hour day month weekday command
```

**Field ranges**

- **Minute**: 0–59
- **Hour**: 0–23
- **Day of month**: 1–31
- **Month**: 1–12
- **Day of week**: 0–7 (0 and 7 are both Sunday; names like `MON`, `TUE` also work)

**Special characters**

- `*` represents all possible values.
- `,` specifies a list of values.
- `-` defines a range.
- `/` specifies step values (e.g., `*/5` means every five minutes).

**Managing cron jobs**

Users interact with cron via the `crontab` command. Each user has their own crontab file.

- `crontab -e`: Edit the current user's crontab (creates one if it doesn't exist).
- `crontab -l`: List the current user's scheduled jobs.
- `crontab -r`: Remove the current user's crontab entirely (use with caution).
- `crontab -ri`: Remove crontab with a confirmation prompt (safer).
- `sudo crontab -u username -e`: Edit another user's crontab (requires root privileges).

## Bash Scripting

Bash (Bourne Again SHell) scripting is the process of writing a sequence of commands in a text file to automate tasks in Unix-like operating systems. Instead of executing commands manually one by one, a script allows them to run as a single program.

Its primary benefits include:

- **Automation**: Executing repetitive tasks like backups, log rotation, and system updates.
- **Efficiency**: Running complex workflows with a single command.
- **Consistency**: Ensuring tasks are performed identically every time, reducing human error.
- **System administration**: Managing users, permissions, and services efficiently.

**Basic syntax and structure**

A Bash script is a plain text file, typically with a `.sh` extension. The first line must be the shebang (`#!/bin/bash`), which tells the system to use the Bash interpreter to execute the file.

**Creating and running a script**

1. Create: `vim script.sh`
2. Add shebang: `#!/bin/bash` as the first line.
3. Make executable: `chmod +x script.sh`
4. Run: `./script.sh`

**Variables**: Variables store data and are declared without spaces around the `=` sign. They are accessed using the `$` symbol.

```bash
#!/bin/bash
NAME="Alice"
AGE=30
echo "Hello, $NAME. You are $AGE years old."
```

**Best practices for reliable scripts**

To write robust and maintainable scripts, adhere to these modern standards:

- **Strict mode**: Start scripts with `set -euo pipefail`.
  - `-e`: Exit immediately if a command fails.
  - `-u`: Treat unset variables as an error.
  - `-o pipefail`: Return the exit code of the first failed command in a pipeline.
- **Quoting variables**: Always quote variables (e.g., `"$VAR"`) to prevent issues with spaces or special characters in filenames and strings.
- **Idempotency**: Write scripts that can be run multiple times without breaking the system. Use `mkdir -p` instead of `mkdir`, and check if a file exists before creating it.
- **Use ShellCheck**: ShellCheck is a static analysis tool that identifies common mistakes, syntax errors, and portability issues in Bash scripts. It is highly recommended to run scripts through ShellCheck before deployment.
- **Keep it simple**: If a script becomes too complex (e.g., over 50–100 lines), consider using a more powerful language like Python for better readability and maintainability.

## Networking Fundamentals

Networking is the practice of connecting computers and devices so they can communicate and share resources. A solid grasp of networking fundamentals is essential before moving into container and Kubernetes networking, since most of the same concepts (IP addressing, DNS, ports, routing) reappear inside a cluster, just virtualized.

### IP Addressing

An IP address is a unique numerical identifier assigned to a device on a network, allowing it to send and receive data.

- **IPv4**: A 32-bit address written as four octets (e.g., `192.168.1.10`). Provides roughly 4.3 billion unique addresses.
- **IPv6**: A 128-bit address written in hexadecimal (e.g., `2001:db8::1`), created to solve IPv4 address exhaustion.
- **Private vs Public IP**: Private IPs (e.g., `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) are used within internal networks and are not routable on the internet. Public IPs are globally unique and routable.
- **Subnetting**: Dividing a network into smaller sub-networks using a subnet mask (e.g., `/24` or `255.255.255.0`) to organize hosts and control traffic.
- **CIDR notation**: A compact way of expressing an IP address and its subnet mask, e.g., `192.168.1.0/24`.

### Ports and Protocols

A port is a logical endpoint that allows a device to run multiple network services simultaneously, identified by a number from 0–65535.

Common ports:

- `22`: SSH
- `80`: HTTP
- `443`: HTTPS
- `53`: DNS
- `5432`: PostgreSQL
- `6379`: Redis
- `3306`: MySQL

**TCP vs UDP**

- **TCP (Transmission Control Protocol)**: Connection-oriented, reliable, ensures ordered delivery (used by HTTP, SSH, databases).
- **UDP (User Datagram Protocol)**: Connectionless, faster, no delivery guarantee (used by DNS queries, video streaming, VoIP).

### DNS (Domain Name System)

DNS translates human-readable domain names (e.g., `example.com`) into IP addresses that computers use to identify each other.

Key record types:

- **A record**: Maps a domain to an IPv4 address.
- **AAAA record**: Maps a domain to an IPv6 address.
- **CNAME record**: Maps a domain to another domain name (alias).
- **MX record**: Specifies mail servers for a domain.

Common commands:

```bash
nslookup example.com
dig example.com
host example.com
```

### Routing and the OSI Model

Routing is the process of forwarding data packets between networks based on their destination IP address, typically performed by routers using routing tables.

The OSI model describes networking in seven layers, useful for understanding where issues occur:

1. Physical – cables, signals
2. Data Link – MAC addresses, switches
3. Network – IP addresses, routing
4. Transport – TCP/UDP, ports
5. Session – connection management
6. Presentation – encryption, encoding
7. Application – HTTP, DNS, SSH

### Firewalls and Network Security

A firewall controls incoming and outgoing traffic based on predefined security rules.

- **iptables**: A traditional Linux firewall utility that filters packets at the kernel level.
- **ufw (Uncomplicated Firewall)**: A simpler frontend for managing iptables rules.
- **Security groups**: Cloud-native equivalent of firewalls (e.g., AWS Security Groups) that control inbound/outbound traffic at the instance level.

Common commands:

```bash
sudo ufw allow 22/tcp
sudo ufw status
sudo iptables -L
```

### Load Balancing and Reverse Proxies

- **Load balancer**: Distributes incoming traffic across multiple servers to improve availability and performance (e.g., round-robin, least connections).
- **Reverse proxy**: Sits in front of one or more servers and forwards client requests to them, often used for SSL termination, caching, and routing (e.g., NGINX, HAProxy).

## Kubernetes Networking Revision

Kubernetes networking builds on these fundamentals but introduces its own abstractions to manage communication between pods, services, and the outside world across a dynamic, ephemeral environment.

### The Kubernetes Networking Model

Kubernetes enforces a flat networking model with the following core rules:

- Every pod gets its own unique IP address (no NAT between pods).
- Pods on any node can communicate with all pods on all nodes without NAT.
- Containers within the same pod share the same network namespace and can reach each other via `localhost`.
- Agents on a node (like the kubelet) can communicate with all pods on that node.

This model is implemented by a **Container Network Interface (CNI)** plugin (e.g., Calico, Flannel, Cilium, Weave Net), which Kubernetes itself does not provide natively.

### Pods and Pod Networking

Each pod is assigned an IP address from the cluster's pod CIDR range. Since pod IPs are ephemeral (pods can be recreated with new IPs), Kubernetes uses Services to provide a stable network identity.

### Services

A Service is an abstraction that defines a logical set of pods and a stable way to access them, typically selected via labels.

Service types:

- **ClusterIP** (default): Exposes the service on an internal IP, reachable only within the cluster.
- **NodePort**: Exposes the service on a static port on each node's IP, making it reachable from outside the cluster.
- **LoadBalancer**: Provisions an external load balancer (typically via a cloud provider) to expose the service externally.
- **ExternalName**: Maps a service to an external DNS name rather than to pods.

```bash
kubectl get svc
kubectl expose deployment myapp --type=ClusterIP --port=80
```

### kube-proxy

`kube-proxy` runs on every node and is responsible for implementing the Service abstraction by maintaining network rules (via iptables or IPVS) that forward traffic destined for a Service IP to the correct backend pod.

### DNS in Kubernetes

Kubernetes runs an internal DNS service (typically **CoreDNS**) that automatically creates DNS records for Services and pods, allowing them to be addressed by name instead of IP.

Standard service DNS format:

```
<service-name>.<namespace>.svc.cluster.local
```

Example: a service named `backend` in the `default` namespace can be reached at `backend.default.svc.cluster.local`, or simply `backend` from within the same namespace.

### Ingress

An Ingress is an API object that manages external HTTP/HTTPS access to services within a cluster, typically providing:

- Host-based and path-based routing.
- TLS termination.
- A single entry point for multiple services, reducing the need for multiple LoadBalancers.

An **Ingress Controller** (e.g., NGINX Ingress Controller, Traefik) must be running in the cluster to actually fulfill Ingress rules, since the Ingress object itself is just a set of routing instructions.

### Network Policies

A NetworkPolicy is a Kubernetes resource that controls traffic flow at the IP address or port level between pods, acting as a firewall within the cluster.

- By default, all pods can communicate with all other pods (no isolation).
- NetworkPolicies allow defining rules to restrict traffic, such as allowing only specific pods or namespaces to communicate with a given pod.
- Enforcement depends on the CNI plugin supporting NetworkPolicy (e.g., Calico, Cilium); some plugins like basic Flannel do not enforce them by default.

### Common Troubleshooting Commands

```bash
kubectl get pods -o wide              # view pod IPs and node placement
kubectl get svc -o wide               # view service IPs and ports
kubectl describe svc <service-name>   # inspect service details and endpoints
kubectl get endpoints <service-name>  # check which pods back a service
kubectl exec -it <pod> -- nslookup <service-name>   # test DNS resolution from inside a pod
kubectl exec -it <pod> -- curl <service-name>:<port> # test connectivity to a service
```
