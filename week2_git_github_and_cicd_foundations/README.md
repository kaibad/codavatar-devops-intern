# Scouce code management
SCM is used ti track modifications to a source code reposotory.SCM tracks the running history of changes to a code base and helps resolve conflicts when merginf updates from multiple contributos. SCM us also synonymous with version control.

## What is Version Control?

Version control is a system that records changes to files over time so you can recall specific versions later.

**Without version control:**
- You manually save files like `app_v1.py`, `app_v2_final.py`, `app_v2_FINAL_final.py`
- Collaboration becomes chaotic where two people overwrite each other's work
- There is no way to trace who changed what and when
- Rolling back a mistake means manually comparing dozens of files

**With Git:**
- Every change is recorded with who made it, when, and why
- Multiple people work on isolated branches without interfering
- Rolling back a change is a single command
- The entire history of a project is stored and queryable

**Types of version control:**
- **Local VCS**: changes tracked on one machine only (risky)
- **Centralized VCS**: one central server, everyone connects to it (SVN, CVS)
- **Distributed VCS**: every contributor has a full copy of the history (Git)

Git is distributed. Even without an internet connection, you can commit, branch, and view history locally.

## SCM/version control in DevOps lifecycle

```bash
Dev ----> commit code -----> SCM(git)-----> CI pipeline ---------> CD pipeline -------> prod
```

### flow

- Dev pushes code to the repo.
- SCM triggers the CI pipeline
- code is built and tested.
- CD pipelines deploys applications




## References

1. SCM: https://www.atlassian.com/git/tutorials/source-code-management
2. git: 
   - https://www.atlassian.com/git/tutorials/what-is-git
   - https://youtu.be/RxHJdapz2p0?si=8fGprBQIPDsPVcnu
3. Branching startegy: https://www.bmc.com/blogs/devops-branching-strategies/
