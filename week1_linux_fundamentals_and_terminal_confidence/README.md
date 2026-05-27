# Week 1: Linux fundamentals and terminal Confidence

**Goal:** The main goal of the week is be confortable with the linux and terminal interface because most servers, docker, containers, Kubernetes nodes, cloud VMs, and devops automation and environment run on linux. No need to  Memorie commands , i shoudl understand paths, files, permssions, processes , logs,  and shell scripts.

Iam using ubuntu as a dual boot in my machine so i work directly in a linux environment not a VM or wsl. 

## Tools and technologies 

- linux terminal - iam using ubuntu 
- vim - command line keyboard driven editor. I will use this mostly
- vsocde - better ui for shell scripts and documentation

![Version Checks](../images/screenshots/git-version.png)

## Linux Command line

**principle:** Terminal is the primary surface for servers. Since most DevOps task are performed using commands over ssh(Secure Shell) without using GUI.

### Paths: absolute path, relative path

A path is a location of a file or directory in linux filesystem.

**example:**

- /home/user/test.txt
- /var/log/nginx/access.log

#### Types of path in linux

1. Absolute path: An absolute path starts from the root of the file system "/". **example:** /var/log/syslog, /home/ubuntu/projects

Absolute paths are used in cron jobs,scripts on servers, system services which are importatn task performed by DevOps.

2. Relative path: A relative path starts from where im currently at. It does'nt start with "/".**example:** test.log,../logs etc. THe problem with the relative path is it can break if we run script from different folders. Suppose we have a scripts what read logs based on relative path ../test.log, the scripts will read the test.log form the parent of where we currenlty executing the scripts.

So, while writing the scripts we should prefer writing absolute path instead of relative paths.

### Home directory

Every thing in a linux is a file. The home directoty is bit confusing at first glance in linux.

"/": I used to think this is the home directory of the root, but this is the root of the linus file systme.

The home directory of the root user is /root and the home direcory of the other user is /home.

![Screenhot of root home directory](../images/screenshots/linux-home-directory.png)

**NOTE** In a linux shell prompt symbols like ~,/,$,# tell who are you, where are you and your privileges level.

```bash
    kailashbadu@ubuntu:/home$ cd
    kailashbadu@ubuntu:~$ sudo su -
    root@ubuntu:~# 

```
#### $

It means normal (non-root) user with limited permissions.It is safe for daily work.It simply means im logged in as a regular user.

#### #

This hashtag symbol means we are in a root/adminstrator shell, we have full system privilges and can modify anything.

#### ~(tilde)

It means home directory of the current user.

for user kailashbadu the ~ means /home/kailashbadu

for root the ~ means /root

`cd` with no arguments automatically takes us to the home directory.

### Current directory:

 Single dot . means the current directory. pwd is used to see the current directory.

```bash
    kailashbadu@ubuntu:~/Desktop/Learning/codavatar-devops-intern$ pwd
    /home/kailashbadu/Desktop/Learning/codavatar-devops-intern
```
 
## Common commands options

These are some of the commands i use daily:
 
 ls, mv, cp,vim, nano,head,tail less, top, more, cat, mkdir, cd, ls, rm, rmdir

###  ls 

The ls command is used to list directory contents in linux and unix systems.

#### Basic Syntax

```bash
    ls [options] [file/dir]
```
1. ls -l -> long listing means shows permissions, owner, size, date.
2. ls -a -> shows all files including hidden files starting with . .
3. ls -A -> it is like -a but it excludes . and .. .
4. ls -h -> human readable sizes
5. ls -i -> shows inode number as well

![Screenhot of ls](../images/screenshots/ls.png)

### mv

The mv (move) command in Linux is used to move or rename files and directories. It does not create a copy of the file; instead, it changes its location or name. By default, if a file with the same name exists at the destination, mv overwrites it.

![Screenhot of mv](../images/screenshots/mv.png)

### cp

The cp (copy) command in Linux is used to duplicate files or directories from one location to another within the file system. It supports copying single files, multiple files, and entire directories, with options to control overwriting and attribute preservation.

**syntax**

```bash
    cp Sorce_file Destination_file
```

![Screenhot of mv](../images/screenshots/cp.png)

### other commands

```bash
ls -la               # list all files including hidden, with permissions and sizes
cp file1 file2       # copy a file
mv file1 file2       # move or rename a file
rm -i file           # delete with confirmation prompt
mkdir -p a/b/c       # create nested directories in one command
cat file             # print file contents
less file            # scroll through a file page by page
more file            # similar to less but simpler
vim file             # open in vim editor
nano file            # open in nano editor
top                  # live process and resource monitor

```

## FIle System Structure

The Linux File Hierarchy Structure or the Filesystem Hierarchy Standard (FHS) defines the directory structure and directory contents in Unix-like operating systems. It is maintained by the Linux Foundation. 

In the FHS, all files and directories appear under the root directory /, even if they are stored on different physical or virtual devices.

![Image form web: linus file system](../images/Linux_File_Hierarchy.webp)





## Permissions
chmod, usemod, chown, useradd, groupadd, /etc/groups, /etc/passwd, /etc/shadow

## Processed and logs


journalctl,less, more,cat, grep , pgrep , top, df -h, du -h, free, 

## Networking

netstat, dig, nslookup, traceroute, curl, wget, ip addr, ip, ping, telnet



## Scheduling with cron jobs

## Systemd services systemctl and jornalctl

## file searching

find, grep, awk,sed, 

## Archives and compression

tar,gzip, zip

## Disk and storage understanding
lsblk,blkid, mount, umount df -h, du -sh

## logs dir structure

/var/log
/var/log/syslog
/var/log/auth.log
/var/log/nginx
/var/log/apache2


## Bash Scripting

shebang 

```bash
#!/bin/bash

set -euo pipefail

ls 

```

## Screnshots

![Screenhot of mkdir -p](../images/screenshots/create-directory.png)


## Commands i Used and their practical meaning

- mkdir -p devops-internship/week1/{scripts,logs,notes,backup}: this creates multipe directory in a hierarchical way.-p tells is no pareent directory create and then crete those directory so when i enter the command then if the parent directory is already present then it creates the child directoy if the parent directory is absent then it creates the parent directory first.

- pwd : this command is used to preint the presetn working directory.

- tree: it display directory structure in a tree format. The tree command in Linux displays the directory structure in a hierarchical, tree-like format, providing a clear visual representation of files and subdirectories.

- sudo apt update: it updates the package lists for upgrades for packages that need upgrading, as well as new packages that have just come to the repositories.   


## References

- https://www.geeksforgeeks.org/linux-unix/linux-file-hierarchy-structure/

 
