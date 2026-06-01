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

## Branching Startegy

A branching strategy is something a software development team uses when interacting with a version control system for writing and managing code.

### Why you need a DevOps branching strategy

A properly implemented branching strategy is the key to creating an efficient DevOps process. DevOps is focused on creating a fast, streamlined, and efficient workflow without compromising the quality of the end product.

A DevOps branching strategy helps define how the delivery team functions and how each feature, improvement, or bug fix is handled. It also reduces the complexity of the delivery pipeline by allowing developers to focus on developments and deployments on the relevant branches—without affecting the entire product.

### Determining the best branching strategy for your needs

It depends.

A good branching strategy for DevOps should have the following characteristics:

- Provides a clear path for the development process from initial changes to production.
- Allows users to create workflows that lead to structured releases.
- Enables parallel development.
- Optimizes developer workflow without adding any overhead.
- Enables faster release cycles.
- Efficiently integrates with all DevOps practices and tools, such as different version control systems.
- Offers the ability to enable GitOps if it is a requirement.

### Git flow

- main -> production
- develop -> integration
- feature -> new features
- release -> release prep
- hotfix -> urgent fixes

## Truck based development
- sigle main branch
- short lived feature branch
- frequent commit
- faster ci/cd


## source code management best practices

1. commit often
2. ensure you are working from latest verison
3. make detailed notes
4. Review changes before commiting
5. use branches
6. Agree on workflow: SCM workflows establish patterns ans processes for merging branches. If a team dosent agree on a shared workflow it can lead to inefficient communicatino overhead when it coes time to merger branches.

---

## Git

Git is a stream of snaoshots.

Git is a mini file systems so it has a hidden directory called .git, inside it all of our object located.

Objects are really inportant in git.

### How Git Works Internally

![Image of git internal includin blob, tree and commit](../images/git-internal.png)

Understanding Git internals helps us debug problems instead of guessing.

**blob:** A "blob" is used to store file data - it is generally a file. Blob will save the contents of the file without the filename, if we have serverla files for the same content, they are saved as one blob, the blob is then compressed.

Each object is git will have a unique indentifier called SHA-1 hash

**Tree:** A "tree" is basically like a directory - it references a bunch of other trees and/or blobs (i.e. files and sub-directories)

**Commit:** A "commit" points to a single tree, marking it as what the project looked like at a certain point in time. It contains meta-information about that point in time, such as a timestamp, the author of the changes since the last commit, a pointer to the previous commit(s), etc.

**Tag:** A "tag" is a way to mark a specific commit as special in some way. It is normally used to tag certain commits as specific releases or something along those lines.


**Three areas of Git:**

```
Working Directory   -->   Staging Area (Index)   -->   Repository (.git)
(our files)            (what you plan to save)       (permanent history)
```

Working Directory: they conatins files we actively editing, we can just edit files normally to move file here

Staging Area: they contains the  changes selected for next commit and we cn add file in the staging area by `git add filename`

Repository: it contains the  committed history and we can add the files in this stage by  `git commit -m "message"` 


**What a commit really is:**

A commit is a snapshot of all staged files at that moment. Git stores this as a hash (a unique ID like `a3f8d2c`). Every commit points to its parent commit, forming a chain called the **commit history**.

**What HEAD means:**

`HEAD` is a pointer to the current commit you are on. When you switch branches, `HEAD` moves. It tells Git "this is where you are right now."

---




## References

1. SCM: https://www.atlassian.com/git/tutorials/source-code-management
2. git: 
   - https://www.atlassian.com/git/tutorials/what-is-git
   - https://youtu.be/RxHJdapz2p0?si=8fGprBQIPDsPVcnui
3. Git object: https://shafiul.github.io/gitbook/1_the_git_object_model.html
4. Branching startegy: https://www.bmc.com/blogs/devops-branching-strategies/
