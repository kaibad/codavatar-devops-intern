# DevOps Intern REPORT -  Kailash Badu
**DevOps Engineering Internship | Codavatar Tech Pvt. Ltd.**
---

# First Month of Internship
**Duration: May 25, 2026 – June 22, 2026**

## What I Learned

This first month covered four major areas, each building directly on the last.

- Week 1: Linux Fundamentals and Terminal Confidence
- Week 2: Git, GitHub, and CI/CD Foundation
- Week 3: Docker and Docker Compose
- Week 4: Databases - PostgreSQL and MongoDB

---

## Week 1: Linux fundamentals and terminal confidence

The main focus of first week  is to be comfortable with Linux because most servers, Docker containers, Kubernetes nodes, cloud VMs, and DevOps automation environments run on Linux. Interns should not only memorize commands; they should understand paths, files, permissions, processes, logs, and shell scripts 

I spent the first week getting fully comfortable in the Linux terminal, working directly on Ubuntu (dual boot, no abstraction layer). I learned the filesystem hierarchy, what lives in `/etc`, `/var/log`, `/proc`, and why it matters. I wrote a system information script using `set -euo pipefail` which actually caught an undefined variable I had missed — small thing but a real lesson in defensive scripting. Permissions, process management, cron jobs, hard links vs symlinks all of it became part of how I think now, not just things I had read about.

Medium: [Three Weeks Into a DevOps Internship: Linux, Git, CI/CD, and Docker](https://medium.com/@kailashbaduatwork/three-weeks-into-a-devops-internship-linux-git-ci-cd-and-docker-23d256f8560e)

GitHub: [Week 1 Dir](./week1_linux_fundamentals_and_terminal_confidence)

---

## Week 2: Git, GitHub, and CI/CD Foundation

The main focus of this week is to know how DevOps teams manage source code and automate checks. Git stores history, GitHub enables collaboration, and CI/CD runs automated workflows when code is pushed or pull requests are opened.

This week pushed me past surface-level Git. I now understand how Git actually stores data with  blobs, trees, commits, tags  and why `git rebase` is dangerous on shared branches. I wrote real GitHub Actions workflow: event-driven, with branch and tag filters, running syntax checks on my shell scripts from week one. Seeing a green pipeline pass for the first time was a good moment. I also got a clear understanding of deployment strategies  rolling, blue-green, canary  and why rollback planning is not optional.

Medium: [Three Weeks Into a DevOps Internship: Linux, Git, CI/CD, and Docker](https://medium.com/@kailashbaduatwork/three-weeks-into-a-devops-internship-linux-git-ci-cd-and-docker-23d256f8560e)

GitHub: [Week 2 dir](./week2_git_github_and_cicd_foundations)

---

## Week 3: Docker and Docker Compose

This main focus of this week to gain hands on fluency in containerization. Docker packages an application with its runtime and dependencies so it runs consistently across machines. Docker Compose runs multiple services together, such as app, database, and cache.

This was the most hands-on week. I containerized a Next js app using a multi-stage Docker build  Node for the build stage, nginx-alpine for serving  and the final image had no source code, no `node_modules`, just static files and a web server. I ran a multi-service stack with Docker Compose including PostgreSQL and pgAdmin, which is also where I first hit a port conflict and had to debug it with `ss -ltnp`. `docker exec -it container bash` became my most-used command this week.

As an additional learning objective this week, I explored the fundamentals of the Go programming language. Go is widely used in cloud-native technologies and DevOps tools, including Docker, Kubernetes  and many modern infrastructure platforms. I practiced basic concepts such as variables, data types, functions, loops, conditionals, structs, and error handling while understanding Go's simplicity, performance, and concurrency features. Learning Go gave me insight into the language that powers many cloud and automation tools and helped me better understand how DevOps engineers build automation, infrastructure tooling, and scalable backend services.

Medium: [Three Weeks Into a DevOps Internship: Linux, Git, CI/CD, and Docker](https://medium.com/@kailashbaduatwork/three-weeks-into-a-devops-internship-linux-git-ci-cd-and-docker-23d256f8560e)

GitHub: [Week3 dir](https://github.com/kaibad)

---

## Week 4: Databases - PostgreSQL and MongoDB

Week 4 primarily focuses on  how applications store data. PostgreSQL is relational and structured. MongoDB is document-based and flexible. DevOps interns should know how to run databases locally, manage credentials, persist data, check logs, connect applications, and troubleshoot database containers.

We shifted to the data layer this weeks. I ran PostgreSQL in Docker Compose with proper health checks (`pg_isready`), environment variables from `.env`, and a named volume to persist data across container restarts  without a volume, everything is gone on `docker rm`. I practiced SQL across all four sublanguages (DDL, DML, DCL, TCL) using a DevOps-themed schema: servers, services, deployments, alerts, and logs with a JSONB column. I also set up MongoDB with `mongosh` health checks and `condition: service_healthy` in `depends_on`, which is a stronger guarantee than just waiting for the container to exist. CRUD in both databases, transactions, JOINs, window functions, aggregations all of it.

In addition to hands-on database practice, I learned the fundamentals of Redis and database architectures. Redis is an in-memory key-value data store primarily used for caching, session management, rate limiting, message queues, and improving application performance by reducing database load. I also explored the differences between SQL and NoSQL databases. SQL databases such as PostgreSQL store data in structured tables with predefined schemas and support complex queries, JOINs, and ACID transactions. NoSQL databases such as MongoDB store data in flexible document formats, scale horizontally more easily, and are well-suited for unstructured or rapidly changing data. Understanding when to use relational versus non-relational databases helped me better appreciate the trade-offs involved in designing scalable and reliable systems.

Medium: [Week 4 of My DevOps Internship: Databases, Docker Volumes, and Why None of It Is "Just a Dev Thing"](https://medium.com/@kailashbaduatwork/week-4-of-my-devops-internship-databases-docker-volumes-and-why-none-of-it-is-just-a-dev-thing-fe94272c666f)

GitHub: [Week 4 database](./week4_databases)

---

## What I Liked

The week-by-week structure works. Each week had a clear goal, a deliverable, and something that would break and need fixing. That combination i.e  structure plus real errors is what makes things stick. I liked that nothing was just theory every concept had a corresponding task.

The progression was also logical. Linux is the foundation for everything else. Git is how code moves. CI/CD is how it gets validated. Docker is how it gets packaged. Databases are where the data lives. By week four, I was not learning isolated topics i was running a database inside a container managed by Compose with a health check wired into a dependent service. That felt like real DevOps work, not a tutorial.

The writing I have been doing alongside the internship are two Medium articles so far and weekly documentation of each learning ans related task which  has also been useful.

---

## Office Environment

The working environment at Codavatar is good. The infrastructure is solid, the space is quiet enough to focus, and the people here are genuinely helpful. Colleagues have been willing to answer questions and share knowledge even when it falls outside their direct area. That makes a real difference when you are stuck on something.

The culture feels flat enough that asking for help does not feel like an interruption. I really appreciate that.

---

## Overall

One month in, I have gone from having theoretical knowledge of DevOps to having actually built and broken things like  pipelines, containers, databases, scripts. The gap between reading about something and running it on your own machine and watching it fail is where the real learning happens, and this internship has provided a lot of that.

There is still a lot of important topics ahead like Kubernetes, monitoring, IaC,Secret management the internship project itself. But the foundation from this month is solid and I am ready for it.

---

# Second Month of Internship


