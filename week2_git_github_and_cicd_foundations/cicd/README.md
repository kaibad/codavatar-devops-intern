# Devops
DevOps is a cultural and technical improvement that combines develpoment (Dev) AND OPERATIONS (Ops) teams to work, collaboratively thoughout the entire software development and delivery lifrcycle. it breaks down the traditional silos between the teams that write cide and the teas that deploy and maintain it.

DeVops is not just a set of tools, it is a mindset, cultureand set of practices aimed at

- Shortening the software develpoment lifecycle
- Delivering high quality software cintinuosuly.
- Increasing collaboration ans commicatio.

## key principles devops

the key principles of  DevOPs are often summarized by the CALM frameworks.

c: culture: shared ownerhip, collaboration, trust between Dev and Ops

A: automation: aitomate the repetitive tasks, build, tests, deployments and infra provisiong

L: lean: Eliminate waste, reduce work-in-progress, deliver in small batches.

M: Measurement: Measure everything deployemnt frequency, lead time, MTTR, change failure rate.

S: Sharing: Share knowledge, tools, practices, and responsibikity across teams.

Addtional principles:

- shift left principle: means move the testing ans the security to the left i.e more nearer to yhe development phase or to the developer.

- fail fast: detect problems early when they are cheap to fix.

Continuos improvement: ALways iterate item and improve processes.

# what is DORA metrics?

Four key DevOps metrics: Deployment frequency, Lead time for changes, Mean time to recovery (MTTR), change failure etc.

## Why DevOps is important ?

In this modern digital econmy, doftware is the business.Companies like netflix, amazon, and google deploy thousands of times per day.


# CI/CD

CI/CD is an automated process.practices that allow software teams to deliver, the code changes more frequently, reliably ans safely.

**ci:** Continuos Integration merge ans often auto buidl and test every change.

**cd:**: Continuos Delivery always have a release ready artifact, deploy manually with the human inetvention.

**CD** Continuos Deployment every passing build is deployed to production automatically.

```bash
developer ---> code ---> build ---> test ---> release---> deploy----> monitor
```

## CI

practice of merging all developer working copoes to a shared mainline several times a day.

### core principles of CI

- maintains a single sorce repo
- automate the build
- make the build self testing
- every commit must trigger a build


## What CI checks?

on push or pr:

- Syntax & linting
- unit tests
- integration testing
- code coverage
- static code analysis
- Dependency vulnerability check
- Build artifact creation

## Major terms of the CI

### Pipeline

pipelie is an automated worflow that guide software from source code through building, testing and releasing stages.

### Pipeline triggers

Triggers determine when a pipeline runs push, pr, mr, tag, scheduled by cron jobs, manual trigger or webhook triggers.


## Runner or agent

A runner or a agent is the machine that executes pipeline jobs.

they are of different types:

- cloud/shared -> github actions -> zero maintenance but less control ans cost at scale

- self hosted --> our own macchine, we have the full control, access to internal resources and we maintain it.

## Artifacts ans registries

An artifact is the output of a build stage  called the deployable unit.

Commont artifacts types are:

- container image --> Docker image --> Docker hub,ECR,GCR,ACR
- package --> .jar,.war --> Nexus, artifactory
- binary --> .exe, .bin, compiled binary --> s3, github release
- Archive --> .zip,.tar.gz --> s3, GC3, Azure blob
- Helm chart --> kubernetes deployement package ---> helm repo OCI registry









# References
- https://www.eficode.com/blog/have-you-closed-the-devops-infinity-loop-after-deploy
- https://about.gitlab.com/topics/ci-cd/pipeline-as-code/
- 
