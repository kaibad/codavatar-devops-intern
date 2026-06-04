# Github Actions

GitHub Actions is a Continuous Integration/Continuous Deployment (CI/CD) platform built directly into GitHub that allows developers to automate software workflows such as building, testing, packaging, releasing, and deploying code.  It enables event-driven automation, where specific activities in a repository—like pushing code, opening a pull request, or creating an issue—trigger predefined workflows defined in YAML files located in the .github/workflows/ directory. 

Key components include workflows (automated processes), jobs (groups of steps that run on the same runner), steps (individual tasks or commands), actions (reusable units of code), and runners (virtual machines that execute the jobs).  GitHub provides free, pre-configured Linux, Windows, and macOS runners for public repositories, while also supporting self-hosted runners for custom hardware or security requirements.  Beyond DevOps, it can automaite tasks like label management, issue triaging, and package publishing. 

## Using environment variables in Github actions

**Why we use it:** we avoid comtting .env files in public repos for safety and instead pass values through gh actions.

**Add variable in Github** github repo -> setting -> secrets and variables -> actions -> variable

add the var name and the var value.


## using the variable in the gh ci pipeline

in .github/workflows/ci.yml

```yml
jobs:
  build:
    runs-on: ubuntu-latest

    env:
     NEXT_PUBLIC_CURRENCY: ${{NEXT_PUBLIC_CURRENCY}}
```

## Triggering events

Almost any github event can trigger a workflow.

- Trigger manually
- push to a branch
- create/update pull requests
- cron schedule
- Many more

```yaml
name: Triggering events
on:
  push:
    branches:
      - "example-branch/*"
 
    pull-request:
      types:
       - opened
       - synchronize
       - reopened
      paths:
       - "filters/*.md"
       - "!filters/*.txt"
     schedule:
      - cron: "0 0 * * *"

```

## passing variables

variables can be passed using

- step and job inputs/outputs
- Envirenment variables

Infra job output --> input:
1. write to $GITHUB_OUTPUT
2. REFERENCE with ${{}}

## Secrets and variables

Github has a build in mechanism to store and variable

1. github orgraniation
2. repository
3. Environment staging ans production



