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
## Branches

a git branch is a lightweight, movable pointer to a specific commit, representing and independent line of develpoment that allows changes to be made withour affecting the main project code.

By default git creates a main branch when a repository is initialized, and this pointer moves forward automatically with each new commit.

creatinng a branch simply involves writing a pointer to a file rather than copying project files. THis enabales developers to isolatework on new features, bug fixes, or experiments keeping the main branch stable and production ready until those changes are validated and merged back in.

**Why branches?**

The `main` branch is the stable, production-ready version of the code. You never work directly on `main` in a team. Instead, you create a branch, do your work, and merge it back after review.


### branch operations in git

1. **Listing branches** git branch. current branch is marked by an asterisk.
2. **Create a branch** use git branch <name> to create a branch without swithcing to it, ot git switch -v <name>, to create and swicth simultaneously. we can slo use git checkout -b <branchname> to create an switch branch simulataneously.
3. **Delete a branch:** USe git origin branch -d <branchname> to safely delete a merged branch, or git branch -D <branchname> to force delete it regardless of merge status.
4. **Merge changes:** Once work is compled , switch to the main branch and use git merge <branch_name> to integrate the changes


#### Branch Commands

```bash
# List all local branches
git branch

# List all branches including remote
git branch -a

# Create a new branch
git branch branch-name

# Switch to an existing branch
git checkout branch-name

# Create AND switch in one command (preferred)
git checkout -b branch-name

# Modern alternative (Git 2.23+)
git switch -c branch-name

# Delete a branch (safe — only if merged)
git branch -d branch-name

# Force delete (even if not merged)
git branch -D branch-name

# Rename current branch
git branch -m new-name
```
#### Merging

```bash
# Switch to the branch you want to merge INTO
git checkout main

# Merge another branch into current branch
git merge week2-git-cicd

# Merge with a merge commit always (no fast-forward)
git merge --no-ff week2-git-cicd
```

**Fast-forward vs no-fast-forward:**

- **Fast-forward**: If `main` has not changed since the branch was created, Git simply moves the `main` pointer forward. No extra commit is created.
- **No-fast-forward**: Always creates a merge commit, preserving the branch history. Recommended for feature branches.

---


![Screenshot of git branch](../images/screenshots/git-branch.png)

### combinig branch

git merge and git fetch are the two primary methods for integrating changes form one banch into another.

they differ fundamentally in how they handle commits, history.

Git merge preserves the original development history by creating a "new merge commit" that links to the divergent branches, resulting in non-linewar, graph like structure, this apprrocah is a non-destructiove and safe for public, shared branches because it maintains a complete audit of when and how features were integrated.

Git rebase creates a perfectly linear history by rewriting commits, it takes the changes from a source branch and replays them on top of the target branch's latest commit,creating a new commmit hasshes in the process. The result is cleaner and easier to read log but is destructive to the original history.Consequently, the golder rule of the rebasing dictates that you should never rebase a branch that has been published or shared with others, as it causes divergent hostories and confusion for collaborators. Simply rebase means rewriting the history.

git commits are immutable but branch are mutable, so rebase created a new commit wrth new SHA-1.


Usually we will be merging our master branch to feature branch to test and other stuf.

While merging we may have merge conflict. If two devs or the two different branches are working in the same part of the same file then the conflict occur, we need to solve it  manually.

or we can do git merge --abort.


In git merge we have one conflict per merge but in git rebase we have conflicts as many as the number of commits we are rebasing.

**Git most important rule** Never alter commit that you've shared.

---

### Core Git Commands

#### Initializing a Repository

```bash
# Create a new Git repository in current folder
git init

# This creates a hidden .git folder that stores all Git data
ls -la
# You will see .git listed
```

#### Checking Status

```bash
# See what files are modified, staged, or untracked
git status

# Short version
git status -s
```
#### Adding Files to Staging

```bash
# Stage one specific file
git add filename.txt

# Stage a folder
git add foldername/

# Stage everything in current directory
git add .

# Stage parts of a file interactively (advanced)
git add -p filename.txt
``` 
 **Important:** `git add .` adds ALL changed and new files. Be careful  we might accidentally stage files you did not intend to.

#### Committing

```bash
# Commit staged changes with a message
git commit -m "feat: add system info script"

# Commit and stage tracked files in one step (does not add new untracked files)
git commit -am "fix: correct path in backup script"

# Open editor to write a longer commit message
git commit
```

**Good commit message format**

```
type: short description (max 72 characters)

Optional longer explanation of what and why (not how).
```
- `feat`: New feature or functionality 
- `fix`: Bug fix 
- `chore`: Maintenance, tooling, no code change
- `docs`: Documentation update
- `ci`: CI/CD pipeline changes |
- `refactor`: Code restructure without behavior change |
- `test`: Adding or updating tests |

**Examples:**
```
feat: add week1 linux scripts
fix: correct permission on system_info.sh
docs: update README with commands
ci: add github actions basic check workflow
chore: add week2 folder structure
```
---

### Working with Remotes

A **remote** is a copy of your repository stored on another server (like GitHub).

```bash
# View remote connections
git remote -v

# Add a remote named 'origin' pointing to GitHub
git remote add origin git@github.com:USERNAME/repo-name.git

# Change remote URL
git remote set-url origin git@github.com:USERNAME/new-repo.git

# Remove a remote
git remote remove origin
```

![Screenshot of git remote](../images/screenshots/git-remote.png)

#### Pushing and Pulling

```bash
# Push local branch to remote for the first time
git push -u origin branch-name

# After -u is set, just use:
git push

# Push all branches
git push --all

# Pull latest changes from remote (fetch + merge)
git pull

# Fetch changes without merging
git fetch origin

# Pull and rebase instead of merge
git pull --rebase
```

**What `-u` does:** Sets the upstream tracking. After `git push -u origin main`, Git knows that `origin/main` is the remote counterpart of your local `main`. Future `git push` and `git pull` will automatically use this connection.

#### Cloning

```bash
# Clone a repository (downloads full history)
git clone git@github.com:USERNAME/repo-name.git

# Clone into a specific folder name
git clone git@github.com:USERNAME/repo-name.git my-folder

# Clone only the latest commit (shallow clone — faster for large repos)
git clone --depth=1 git@github.com:USERNAME/repo-name.git
```

---


## References

1. SCM: https://www.atlassian.com/git/tutorials/source-code-management
2. git: 
   - https://www.atlassian.com/git/tutorials/what-is-git
   - https://youtu.be/RxHJdapz2p0?si=8fGprBQIPDsPVcnui
3. Git object: https://shafiul.github.io/gitbook/1_the_git_object_model.html
4. Branching startegy: https://www.bmc.com/blogs/devops-branching-strategies/
