# Week 2: Git, GitHub, and CI/CD Foundation
### DevOps Internship — Complete Notes

---

## Table of Contents

1. [Week Overview](#week-overview)
2. [What is Version Control?](#what-is-version-control)
3. [Git — Deep Dive](#git--deep-dive)
   - [How Git Works Internally](#how-git-works-internally)
   - [Git Installation and Configuration](#git-installation-and-configuration)
   - [Core Git Commands](#core-git-commands)
   - [Branching and Merging](#branching-and-merging)
   - [Working with Remotes](#working-with-remotes)
   - [Merge Conflicts](#merge-conflicts)
   - [Git Log and History](#git-log-and-history)
   - [Undoing Changes](#undoing-changes)
4. [GitHub — Deep Dive](#github--deep-dive)
   - [Setting Up SSH Key Authentication](#setting-up-ssh-key-authentication)
   - [GitHub CLI (gh)](#github-cli-gh)
   - [GitHub Repository Setup](#github-repository-setup)
   - [Pull Request Workflow](#pull-request-workflow)
   - [GitHub Best Practices](#github-best-practices)
   - [git clone — Deep Dive](#git-clone--deep-dive)
   - [git pull vs git fetch](#git-pull-vs-git-fetch)
   - [git pull --rebase](#git-pull---rebase)
   - [Merge Strategies](#merge-strategies)
   - [git rebase — Deep Dive](#git-rebase--deep-dive)
   - [git stash](#git-stash)
   - [git cherry-pick](#git-cherry-pick)
   - [git diff](#git-diff)
   - [git tag](#git-tag)
   - [git reflog](#git-reflog)
5. [CI/CD — Deep Dive](#cicd--deep-dive)
   - [What is CI/CD?](#what-is-cicd)
   - [GitHub Actions](#github-actions)
   - [YAML Syntax for Workflows](#yaml-syntax-for-workflows)
   - [Writing Your First Workflow](#writing-your-first-workflow)
   - [Workflow Triggers](#workflow-triggers)
   - [Jobs and Steps](#jobs-and-steps)
6. [Step-by-Step Practical Lab](#step-by-step-practical-lab)
7. [Weekly Tasks and Deliverables](#weekly-tasks-and-deliverables)
8. [Common Errors and Fixes](#common-errors-and-fixes)
9. [Key Terms Glossary](#key-terms-glossary)
10. [Quick Reference Cheat Sheet](#quick-reference-cheat-sheet)

---

## Week Overview

| Item | Details |
|---|---|
| **Main Focus** | Git version control, GitHub collaboration, CI/CD automation |
| **Main Output** | GitHub repo with branches, PR workflow, first GitHub Actions pipeline |
| **Tools Required** | Git, GitHub account, GitHub CLI (optional), VS Code |
| **Prerequisite** | Week 1 Linux work pushed to GitHub |

**Why this week matters:**
Every professional DevOps engineer works with Git daily. Code is never written by one person in isolation — teams collaborate, review, and merge changes continuously. CI/CD ensures that every code change is automatically tested and validated before it reaches production. Without Git and CI/CD, no modern software team can operate reliably.

---

## What is Version Control?

Version control is a system that records changes to files over time so you can recall specific versions later.

**Without version control:**
- You manually save files like `app_v1.py`, `app_v2_final.py`, `app_v2_FINAL_final.py`
- Collaboration becomes chaotic — two people overwrite each other's work
- There is no way to trace who changed what and when
- Rolling back a mistake means manually comparing dozens of files

**With Git:**
- Every change is recorded with who made it, when, and why
- Multiple people work on isolated branches without interfering
- Rolling back a change is a single command
- The entire history of a project is stored and queryable

**Types of version control:**
- **Local VCS** — changes tracked on one machine only (risky)
- **Centralized VCS** — one central server, everyone connects to it (SVN, CVS)
- **Distributed VCS** — every contributor has a full copy of the history (Git)

Git is distributed. Even without an internet connection, you can commit, branch, and view history locally.

---

## Git — Deep Dive

### How Git Works Internally

Understanding Git internals helps you debug problems instead of guessing.

**Three areas of Git:**

```
Working Directory   →   Staging Area (Index)   →   Repository (.git)
(your files)            (what you plan to save)     (permanent history)
```

| Area | What it contains | How you move files here |
|---|---|---|
| Working Directory | Files you are actively editing | Edit files normally |
| Staging Area | Changes selected for next commit | `git add filename` |
| Repository | Committed history | `git commit -m "message"` |

**What a commit really is:**

A commit is a snapshot of all staged files at that moment. Git stores this as a hash (a unique ID like `a3f8d2c`). Every commit points to its parent commit, forming a chain called the **commit history**.

**What HEAD means:**

`HEAD` is a pointer to the current commit you are on. When you switch branches, `HEAD` moves. It tells Git "this is where you are right now."

---

### Git Installation and Configuration

#### Ubuntu / WSL

```bash
sudo apt update
sudo apt install -y git
git --version
```

#### macOS

```bash
brew install git
git --version
```

#### Global Configuration (required before first commit)

```bash
# Set your name — this appears in every commit you make
git config --global user.name "Your Full Name"

# Set your email — must match your GitHub email for contributions to be linked
git config --global user.email "your-email@example.com"

# Set default branch name to 'main' (modern standard, not 'master')
git config --global init.defaultBranch main

# Set VS Code as your default editor for commit messages
git config --global core.editor "code --wait"

# Verify all settings
git config --list
```

**What `--global` means:** The setting applies to all Git repositories on your machine. Without `--global`, the setting only applies to the current repository.

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

**Understanding git status output:**

```
?? filename    → Untracked (Git does not know about this file)
M  filename    → Modified and staged
 M filename    → Modified but not staged
A  filename    → New file added to staging
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

> **Important:** `git add .` adds ALL changed and new files. Be careful — you might accidentally stage files you did not intend to.

#### Committing

```bash
# Commit staged changes with a message
git commit -m "feat: add system info script"

# Commit and stage tracked files in one step (does not add new untracked files)
git commit -am "fix: correct path in backup script"

# Open editor to write a longer commit message
git commit
```

**Good commit message format — Conventional Commits:**

```
type: short description (max 72 characters)

Optional longer explanation of what and why (not how).
```

| Type | When to use |
|---|---|
| `feat` | New feature or functionality |
| `fix` | Bug fix |
| `chore` | Maintenance, tooling, no code change |
| `docs` | Documentation update |
| `ci` | CI/CD pipeline changes |
| `refactor` | Code restructure without behavior change |
| `test` | Adding or updating tests |

**Examples:**
```
feat: add week1 linux scripts
fix: correct permission on system_info.sh
docs: update README with commands
ci: add github actions basic check workflow
chore: add week2 folder structure
```

---

### Branching and Merging

**Why branches?**

The `main` branch is the stable, production-ready version of the code. You never work directly on `main` in a team. Instead, you create a branch, do your work, and merge it back after review.

```
main ──────────────────────────────────────────► (stable)
          │                           ▲
          └── week2-git-cicd ─────────┘
              (your feature work)
```

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

### Merge Conflicts

A merge conflict happens when two branches changed the same line of a file differently.

**Example:**
```
Branch main:    "Server running on port 3000"
Branch feature: "Server running on port 8080"
```
Git cannot decide which one is correct — you must resolve it manually.

**What a conflict looks like in the file:**

```
<<<<<<< HEAD
Server running on port 3000
=======
Server running on port 8080
>>>>>>> feature-branch
```

**How to resolve:**

1. Open the conflicted file in VS Code
2. Delete the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
3. Keep the correct code (or combine both)
4. Save the file
5. Stage and commit the resolution

```bash
# After resolving all conflicts:
git add conflicted-file.txt
git commit -m "fix: resolve merge conflict in server port"
```

**VS Code makes this easier** — it shows a UI with buttons: Accept Current Change, Accept Incoming Change, Accept Both.

---

### Git Log and History

```bash
# View full commit history
git log

# Compact one-line view
git log --oneline

# Last 5 commits
git log --oneline --max-count=5

# Graphical branch view in terminal
git log --oneline --graph --all

# Show what changed in each commit
git log -p

# Search commits by message
git log --grep="feat"

# Show who changed each line of a file
git blame filename.txt

# Show changes in a specific commit
git show commit-hash
```

---

### Undoing Changes

```bash
# Discard changes in working directory (CANNOT be undone)
git checkout -- filename.txt
# Modern syntax:
git restore filename.txt

# Unstage a file (keeps changes in working directory)
git reset HEAD filename.txt
# Modern syntax:
git restore --staged filename.txt

# Undo last commit but keep changes staged
git reset --soft HEAD~1

# Undo last commit and unstage changes (keep files modified)
git reset --mixed HEAD~1

# Undo last commit and DELETE all changes (DANGEROUS)
git reset --hard HEAD~1

# Create a new commit that reverses a previous commit (safe for shared branches)
git revert commit-hash
```

> **Rule:** Never use `git reset --hard` or force-push on shared branches. It rewrites history and breaks everyone else's work.

---

### git clone — Deep Dive

`git clone` downloads a full copy of a remote repository to your local machine — including all commits, branches, and tags.

```bash
# Basic clone using SSH (recommended)
git clone git@github.com:USERNAME/repo-name.git

# Clone using HTTPS
git clone https://github.com/USERNAME/repo-name.git

# Clone into a custom folder name
git clone git@github.com:USERNAME/repo-name.git my-project

# Clone only the latest snapshot — no full history (faster for large repos)
git clone --depth=1 git@github.com:USERNAME/repo-name.git

# Clone a specific branch only
git clone --branch week2-git-cicd git@github.com:USERNAME/repo-name.git

# Clone all branches and submodules
git clone --recurse-submodules git@github.com:USERNAME/repo-name.git
```

**What happens during clone:**
1. Git creates a new folder with the repo name
2. Downloads all objects (commits, trees, blobs) from the remote
3. Creates a local `main` branch tracking `origin/main`
4. Sets `origin` as the remote automatically

**After cloning, verify remote is set:**
```bash
cd repo-name
git remote -v
# origin  git@github.com:USERNAME/repo-name.git (fetch)
# origin  git@github.com:USERNAME/repo-name.git (push)

git branch -a
# * main
#   remotes/origin/HEAD -> origin/main
#   remotes/origin/main
```

**SSH vs HTTPS clone:**

| Method | URL format | Auth method |
|---|---|---|
| SSH | `git@github.com:USER/repo.git` | SSH key pair |
| HTTPS | `https://github.com/USER/repo.git` | Token or password |

SSH is preferred for DevOps work because it does not require entering credentials on every push/pull.

---

### git pull vs git fetch

These two commands are often confused. Understanding the difference is critical.

**`git fetch`** — Downloads changes from remote but does NOT modify your working directory or current branch. It is safe to run at any time.

**`git pull`** — Downloads changes AND immediately merges them into your current branch. It is `git fetch` + `git merge` in one step.

```bash
# fetch — see what changed on remote without applying it
git fetch origin

# After fetch, you can inspect what is new
git log HEAD..origin/main --oneline

# Then manually merge when you are ready
git merge origin/main

# pull — fetch + merge in one step
git pull

# pull from a specific remote and branch
git pull origin main
```

**When to use which:**

| Situation | Use |
|---|---|
| You want to check what changed before applying | `git fetch` then inspect |
| You are on a clean branch and want latest code | `git pull` |
| You want to avoid surprise merge commits | `git pull --rebase` |
| You are in the middle of work and not ready to merge | `git fetch` only |

---

### git pull --rebase

`git pull --rebase` is one of the most important commands in professional Git workflows. It keeps history clean by avoiding unnecessary merge commits.

**The problem with regular `git pull`:**

```
Before pull:
main (local):  A → B → C
main (remote): A → B → D → E

After git pull (merge):
main (local):  A → B → C → M    (M = ugly merge commit)
                        ↑   ↑
                        D → E
```

**With `git pull --rebase`:**

```
After git pull --rebase:
main (local):  A → B → D → E → C    (C replayed cleanly on top)
```

Your local commit `C` is temporarily removed, the remote changes `D` and `E` are applied, then your commit `C` is replayed on top. The result is a linear, clean history with no merge commit.

```bash
# Pull and rebase instead of merge
git pull --rebase

# Pull and rebase from specific branch
git pull --rebase origin main

# Set rebase as default behavior for all pulls
git config --global pull.rebase true

# If rebase causes a conflict during pull --rebase:
# 1. Resolve the conflict in the file
# 2. Stage the fixed file
git add conflicted-file.txt
# 3. Continue the rebase
git rebase --continue

# If you want to cancel the rebase entirely
git rebase --abort
```

**When to use `git pull --rebase`:**
- When working on a feature branch that others may have updated
- When you want a clean, linear history
- Before pushing to avoid "Updates were rejected" errors

**Rule of thumb:** Use `git pull --rebase` for feature branches. Use regular `git pull` only for `main` when you want to preserve merge history.

---

### Merge Strategies

Git has multiple ways to merge branches. Understanding each one helps you choose the right approach.

#### 1. Fast-Forward Merge (default when possible)

When the branch being merged into has not diverged from the feature branch, Git simply moves the pointer forward — no new commit created.

```bash
# Fast-forward happens automatically when no new commits on target
git checkout main
git merge feature-branch
# Result: main pointer moves forward to tip of feature-branch
```

```
Before:           After fast-forward:
main: A → B       main: A → B → C → D
feature:    → C → D
```

#### 2. Three-Way Merge (merge commit)

When both branches have new commits, Git creates a new **merge commit** that has two parents.

```bash
# Force a merge commit even when fast-forward is possible
git merge --no-ff feature-branch

# Write a custom merge commit message
git merge --no-ff feature-branch -m "Merge week2 feature branch"
```

```
Before:                After merge commit:
main:    A → B         main:  A → B ─────── M
feature: A → C → D            └──── C → D ─┘
                               M = merge commit with 2 parents
```

**When to use `--no-ff`:** Always for feature branches in team projects. It preserves the history of when a feature was worked on as a unit.

#### 3. Squash Merge

Combines all commits from the feature branch into a single commit on the target branch. Useful when feature branch has many messy "WIP" commits.

```bash
git checkout main
git merge --squash feature-branch
git commit -m "feat: add complete login system"
# The feature-branch history is collapsed into one clean commit
```

```
Before:                After squash merge:
feature: A → B → C     main: ... → S
                               S = one squashed commit
```

#### 4. Rebase Merge

Replays feature branch commits on top of the target branch. Creates linear history without a merge commit.

```bash
# Rebase feature branch onto main first
git checkout feature-branch
git rebase main

# Then fast-forward merge
git checkout main
git merge feature-branch
```

**Merge strategy comparison:**

| Strategy | Command | History style | Use when |
|---|---|---|---|
| Fast-forward | `git merge` | Linear | Simple single-developer updates |
| Merge commit | `git merge --no-ff` | Branched, preserves feature | Team feature branches |
| Squash | `git merge --squash` | Linear, condensed | Cleaning up WIP commits |
| Rebase | `git rebase` then merge | Linear, replayed | Keeping history clean |

---

### git rebase — Deep Dive

Rebasing moves or replays your commits onto a different base commit. It rewrites commit history.

```bash
# Rebase current branch onto main
# (replay all commits of current branch on top of latest main)
git checkout feature-branch
git rebase main

# Interactive rebase — edit, squash, reorder last N commits
git rebase -i HEAD~3     # Interactively edit last 3 commits
git rebase -i HEAD~5     # Interactively edit last 5 commits
```

**Interactive rebase — what you can do:**

When you run `git rebase -i HEAD~3`, Git opens an editor showing:
```
pick a1b2c3 feat: add login page
pick d4e5f6 fix: typo in login
pick g7h8i9 wip: still debugging

# Commands:
# p, pick   = use commit as-is
# r, reword = use commit, but edit the message
# e, edit   = use commit, but pause to amend it
# s, squash = combine this commit with the previous one
# f, fixup  = like squash but discard this commit's message
# d, drop   = remove this commit entirely
```

**Common interactive rebase workflows:**

```bash
# Squash last 3 commits into 1
git rebase -i HEAD~3
# Change pick → squash (or s) for 2nd and 3rd commits
# Save → write combined commit message

# Fix a typo in the last commit message
git rebase -i HEAD~1
# Change pick → reword
# Save → edit the message in next prompt

# Remove a bad commit from history
git rebase -i HEAD~4
# Change pick → drop for the bad commit
```

> **WARNING:** Never rebase commits that have already been pushed to a shared branch. Rebase rewrites history — if others have pulled those commits, their history will conflict with yours. Only rebase on local or personal branches.

---

### git stash

`git stash` temporarily saves your uncommitted work so you can switch branches or do something else, then come back and restore it.

**The problem it solves:** You are halfway through work on `feature-branch` and need to urgently switch to `main` to fix a bug. You cannot commit half-done work. `git stash` saves it temporarily.

```bash
# Stash current changes (working dir + staged)
git stash

# Stash with a descriptive name
git stash push -m "half-done login form"

# Stash including untracked files (new files not yet added)
git stash push --include-untracked

# List all stashes
git stash list
# stash@{0}: On feature-branch: half-done login form
# stash@{1}: WIP on main: a1b2c3 fix typo

# Apply the most recent stash (keeps stash in list)
git stash apply

# Apply a specific stash
git stash apply stash@{1}

# Apply most recent stash AND remove it from list
git stash pop

# Remove a specific stash without applying
git stash drop stash@{0}

# Remove all stashes
git stash clear

# Show what is in the most recent stash
git stash show

# Show full diff of a stash
git stash show -p stash@{0}
```

**Typical stash workflow:**

```bash
# You are on feature-branch with unsaved work
git stash push -m "WIP: login validation"

# Switch to fix urgent bug on main
git checkout main
# ... fix the bug, commit, push ...

# Return to your feature
git checkout feature-branch
git stash pop
# Your work is restored exactly as you left it
```

---

### git cherry-pick

`git cherry-pick` copies a specific commit from one branch and applies it to your current branch. You pick one commit and "cherry-pick" just that change.

```bash
# Apply a specific commit to current branch
git cherry-pick a1b2c3

# Cherry-pick multiple commits
git cherry-pick a1b2c3 d4e5f6

# Cherry-pick a range of commits
git cherry-pick a1b2c3..g7h8i9

# Cherry-pick without committing (apply changes but don't commit yet)
git cherry-pick --no-commit a1b2c3

# If a conflict occurs during cherry-pick:
# 1. Resolve the conflict
git add resolved-file.txt
# 2. Continue
git cherry-pick --continue
# Or abort
git cherry-pick --abort
```

**When to use cherry-pick:**

| Situation | Example |
|---|---|
| A bug fix is on a feature branch but needs to go to main immediately | Pick just the fix commit onto main |
| You accidentally committed to the wrong branch | Cherry-pick it to the right branch, then drop it from wrong one |
| You need one specific feature from an old branch | Pick just that commit |

```bash
# Example: bug fix on feature branch needs to go to main
git log feature-branch --oneline
# a1b2c3 fix: critical security patch   ← you want this
# d4e5f6 feat: half-done feature

git checkout main
git cherry-pick a1b2c3
# The fix is now on main without bringing the unfinished feature
```

---

### git diff

`git diff` shows exactly what changed between files, commits, or branches.

```bash
# Show unstaged changes (working dir vs staging area)
git diff

# Show staged changes (staging area vs last commit)
git diff --staged
# Also written as:
git diff --cached

# Show changes between two commits
git diff a1b2c3 d4e5f6

# Show changes between two branches
git diff main feature-branch

# Show changes in a specific file only
git diff filename.txt

# Show only file names that changed (no content)
git diff --name-only

# Show summary of how many lines changed per file
git diff --stat

# Show changes between local and remote main
git diff main origin/main

# Show difference between last commit and 2 commits ago
git diff HEAD HEAD~2
```

**Reading diff output:**

```diff
--- a/scripts/system_info.sh     ← original file
+++ b/scripts/system_info.sh     ← modified file
@@ -3,7 +3,8 @@                  ← line numbers affected
 echo "User: $(whoami)"
-echo "Date: $(date)"            ← removed line (red)
+echo "Date: $(date '+%Y-%m-%d')"← added line (green)
+echo "Uptime: $(uptime -p)"     ← new line added (green)
 echo "Current directory: $(pwd)"
```

Lines starting with `-` were removed. Lines starting with `+` were added. Lines with no prefix are context (unchanged).

---

### git tag

Tags mark specific commits as important — usually version releases. Unlike branches, tags do not move.

```bash
# Create a lightweight tag on current commit
git tag v1.0.0

# Create an annotated tag (recommended — stores tagger, date, message)
git tag -a v1.0.0 -m "Release version 1.0.0 - Week 2 complete"

# Tag a specific commit (not current)
git tag -a v0.9.0 a1b2c3 -m "Beta release"

# List all tags
git tag

# List tags matching a pattern
git tag -l "v1.*"

# Show tag details and the commit it points to
git show v1.0.0

# Push a specific tag to remote
git push origin v1.0.0

# Push all tags to remote
git push origin --tags

# Delete a local tag
git tag -d v1.0.0

# Delete a remote tag
git push origin --delete v1.0.0

# Checkout code at a specific tag (detached HEAD state)
git checkout v1.0.0
```

**Semantic versioning (SemVer) — standard tag naming:**

```
v MAJOR . MINOR . PATCH
v  1   .   2   .   3

MAJOR → Breaking changes (not backward compatible)
MINOR → New features (backward compatible)
PATCH → Bug fixes only
```

Examples: `v1.0.0`, `v2.3.1`, `v0.9.0-beta`, `v1.0.0-rc1`

---

### git reflog

`git reflog` records every movement of HEAD — every checkout, commit, reset, merge, rebase. It is your safety net when you think you have lost commits.

```bash
# Show all HEAD movements
git reflog

# Example output:
# a1b2c3 HEAD@{0}: commit: ci: add workflow
# d4e5f6 HEAD@{1}: checkout: moving from main to week2-git-cicd
# g7h8i9 HEAD@{2}: reset: moving to HEAD~1
# h8i9j0 HEAD@{3}: commit: feat: add linux scripts

# Recover a commit after accidental git reset --hard
git reflog
# Find the commit hash before the reset
git checkout h8i9j0         # Go back to that state
# Or restore to that commit:
git reset --hard h8i9j0
```

**Reflog is local only.** It is not pushed to GitHub. It expires after 90 days by default. Use it quickly after an accident.

---

## GitHub — Deep Dive

GitHub is a cloud platform for hosting Git repositories. It adds collaboration features: pull requests, issues, code review, Actions (CI/CD), and more.

### Setting Up SSH Key Authentication

GitHub no longer accepts passwords for Git operations. You must use SSH keys or personal access tokens.

**SSH key = a pair of keys:**
- **Private key** — stays on your machine, never shared
- **Public key** — uploaded to GitHub

When you push, GitHub verifies you have the private key that matches the public key on record.

```bash
# Step 1: Generate SSH key pair
ssh-keygen -t ed25519 -C "your-email@example.com"
# Press Enter to accept default location (~/.ssh/id_ed25519)
# Set a passphrase (optional but recommended)

# Step 2: Start the SSH agent
eval "$(ssh-agent -s)"

# Step 3: Add private key to the agent
ssh-add ~/.ssh/id_ed25519

# Step 4: Copy public key to clipboard
cat ~/.ssh/id_ed25519.pub
# Copy the entire output

# Step 5: Add to GitHub
# Go to: GitHub → Settings → SSH and GPG keys → New SSH key
# Paste the public key and give it a title like "WSL Ubuntu" or "MacBook"

# Step 6: Test the connection
ssh -T git@github.com
# Expected output: "Hi USERNAME! You've successfully authenticated..."
```

---

### GitHub CLI (gh)

The GitHub CLI lets you manage GitHub directly from your terminal — create repos, open PRs, view issues — without opening the browser.

```bash
# Install on Ubuntu/WSL
sudo snap install gh
# OR
sudo apt install gh

# Install on macOS
brew install gh

# Login
gh auth login
# Choose: GitHub.com → SSH → browser login

# Check authentication
gh auth status
```

**Useful gh commands:**

```bash
# Create a new repository
gh repo create devops-internship-labs --public

# Clone a repository
gh repo clone USERNAME/repo-name

# View open pull requests
gh pr list

# Create a pull request
gh pr create --title "Week 2 CI/CD setup" --body "Added GitHub Actions workflow"

# Merge a pull request
gh pr merge 1

# View issues
gh issue list

# Create an issue
gh issue create --title "Fix login bug" --body "Login fails on mobile"
```

---

### GitHub Repository Setup

```bash
# Option A: Create on GitHub first, then clone
gh repo create devops-internship-labs --public --clone
cd devops-internship-labs

# Option B: Initialize locally and push to GitHub
cd ~/devops-internship
git init
git add .
git commit -m "chore: initial commit with week1 linux work"
git branch -M main
git remote add origin git@github.com:YOUR_USERNAME/devops-internship-labs.git
git push -u origin main
```

**Repository structure to create:**

```
devops-internship-labs/
├── README.md
├── week1-linux/
│   ├── scripts/
│   │   └── system_info.sh
│   ├── logs/
│   └── README.md
└── week2-git-cicd/
    ├── .github/
    │   └── workflows/
    │       └── basic-check.yml
    └── README.md
```

---

### Pull Request Workflow

A **Pull Request (PR)** is a request to merge your branch into another branch (usually `main`). It is the central place for code review in professional teams.

**Standard PR workflow:**

```
1. Create branch        → git checkout -b week2-git-cicd
2. Make changes         → edit files, write code
3. Commit changes       → git add . && git commit -m "..."
4. Push branch          → git push -u origin week2-git-cicd
5. Open PR on GitHub    → Compare & pull request button
6. CI checks run        → GitHub Actions validates the code
7. Code review          → Teammates leave comments
8. Address feedback     → Make more commits on same branch
9. Merge PR             → Squash and merge or merge commit
10. Delete branch       → Clean up after merge
```

**Creating a PR from terminal:**

```bash
gh pr create \
  --title "ci: add github actions basic check workflow" \
  --body "Adds a workflow that runs on push and PR to validate shell scripts and show repo files. Closes #1"
```

**PR description best practices:**
- What does this PR do?
- Why was this change needed?
- How was it tested?
- Screenshots if UI changed
- Link to related issue: `Closes #issue-number`

---

### GitHub Best Practices

**Branch naming:**
```
week2-git-cicd
feature/user-login
fix/docker-port-conflict
chore/update-dependencies
```

**What NOT to commit:**
- Passwords, API keys, tokens, secrets
- `.env` files with real credentials
- `node_modules/`, `__pycache__/`, build artifacts
- Large binary files

**Use `.gitignore`:**

```bash
cat > .gitignore <<'EOF'
# Environment files
.env
.env.local
.env.production

# Dependency folders
node_modules/
__pycache__/
*.pyc

# Build output
dist/
build/
*.class

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/settings.json
.idea/
EOF

git add .gitignore
git commit -m "chore: add gitignore"
```

---

## CI/CD — Deep Dive

### What is CI/CD?

**CI — Continuous Integration:**
Every time code is pushed or a PR is opened, an automated system pulls the code, runs tests, linters, and checks. If anything fails, the team is notified immediately. The goal: catch problems early, before they reach production.

**CD — Continuous Delivery:**
After CI passes, the code is automatically prepared for deployment. A human approves the final release.

**CD — Continuous Deployment:**
After CI passes, deployment to production happens automatically without human approval. Used by companies with high test confidence.

**Why CI/CD matters in DevOps:**
- Eliminates "it works on my machine" problems
- Catches bugs before they reach users
- Enforces code quality standards automatically
- Makes deployments faster, smaller, and safer
- Provides an audit trail of every change

**CI/CD pipeline stages:**

```
Code Push → Lint/Format Check → Unit Tests → Build → Deploy (Staging) → Deploy (Production)
```

---

### GitHub Actions

GitHub Actions is GitHub's built-in CI/CD system. It is free for public repositories.

**Key concepts:**

| Concept | Description |
|---|---|
| **Workflow** | A YAML file that defines automation |
| **Event / Trigger** | What starts the workflow (push, PR, schedule, manual) |
| **Job** | A group of steps that run on one machine |
| **Step** | A single action or command in a job |
| **Action** | A reusable plugin (e.g., `actions/checkout@v4`) |
| **Runner** | The machine that runs the job (`ubuntu-latest`, `macos-latest`, `windows-latest`) |

**Where workflows live:**

All workflow files go inside `.github/workflows/` at the root of the repository. File extension must be `.yml` or `.yaml`.

```
devops-internship-labs/
└── .github/
    └── workflows/
        ├── basic-check.yml       ← runs on every push
        └── pr-validation.yml     ← runs on pull requests
```

---

### YAML Syntax for Workflows

YAML is indentation-based. Wrong indentation breaks the workflow.

**Rules:**
- Use 2 spaces for each indentation level (not tabs)
- Keys and values are separated by `: `
- Lists use `- ` prefix
- Strings with special characters need quotes

**YAML structure example:**

```yaml
name: My Workflow            # Workflow name (shown in GitHub UI)

on:                          # Trigger section
  push:                      # Trigger on push
    branches: [ main ]       # Only on these branches

jobs:                        # Jobs section
  my-job:                    # Job ID (any name)
    runs-on: ubuntu-latest   # Runner machine

    steps:                   # List of steps
      - name: Checkout       # Step name (shown in logs)
        uses: actions/checkout@v4    # Use a pre-built action

      - name: Run command    # Another step
        run: echo "Hello"    # Run a shell command
```

**Multi-line run commands:**

```yaml
- name: Multiple commands
  run: |
    echo "Line 1"
    echo "Line 2"
    ls -la
```

---

### Writing Your First Workflow

```bash
mkdir -p .github/workflows

cat > .github/workflows/basic-check.yml <<'EOF'
name: Basic DevOps Check

on:
  push:
    branches: [ main, week2-git-cicd ]
  pull_request:
    branches: [ main ]

jobs:
  check:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Show repository files
        run: ls -la

      - name: Show current directory
        run: pwd

      - name: Check shell script syntax
        run: bash -n week1-linux/scripts/system_info.sh

      - name: Print environment info
        run: |
          echo "Runner OS: $RUNNER_OS"
          echo "GitHub Actor: $GITHUB_ACTOR"
          echo "Branch: $GITHUB_REF_NAME"
          echo "Commit SHA: $GITHUB_SHA"
EOF
```

**Commit and push the workflow:**

```bash
git add .github/workflows/basic-check.yml
git commit -m "ci: add basic github actions workflow"
git push -u origin week2-git-cicd
```

Go to your GitHub repository → **Actions** tab → you will see the workflow running.

---

### Workflow Triggers

```yaml
on:
  # Trigger on push to specific branches
  push:
    branches: [ main, develop ]

  # Trigger on pull request to main
  pull_request:
    branches: [ main ]

  # Run on a schedule (cron syntax)
  schedule:
    - cron: '0 9 * * 1'   # Every Monday at 9 AM UTC

  # Allow manual trigger from GitHub UI
  workflow_dispatch:

  # Trigger when another workflow completes
  workflow_run:
    workflows: ["Build"]
    types: [completed]
```

**Cron syntax reference:**

```
*  *  *  *  *
│  │  │  │  └─ Day of week (0=Sunday, 7=Saturday)
│  │  │  └──── Month (1-12)
│  │  └─────── Day of month (1-31)
│  └────────── Hour (0-23)
└───────────── Minute (0-59)
```

---

### Jobs and Steps

**Multiple jobs in one workflow:**

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check syntax
        run: bash -n week1-linux/scripts/system_info.sh

  validate:
    runs-on: ubuntu-latest
    needs: lint        # This job only runs if 'lint' passes
    steps:
      - uses: actions/checkout@v4
      - name: Validate folder structure
        run: |
          test -d week1-linux/scripts || (echo "Missing scripts folder" && exit 1)
          test -d week1-linux/logs || (echo "Missing logs folder" && exit 1)
          echo "Folder structure is valid"
```

**Using environment variables in steps:**

```yaml
jobs:
  demo:
    runs-on: ubuntu-latest
    env:
      APP_ENV: staging          # Job-level env variable

    steps:
      - name: Show variables
        env:
          STEP_VAR: hello       # Step-level env variable
        run: |
          echo "App env: $APP_ENV"
          echo "Step var: $STEP_VAR"
          echo "GitHub Actor: $GITHUB_ACTOR"
```

**Built-in GitHub environment variables:**

| Variable | Value |
|---|---|
| `GITHUB_ACTOR` | Username who triggered the workflow |
| `GITHUB_REPOSITORY` | `owner/repo-name` |
| `GITHUB_REF_NAME` | Branch or tag name |
| `GITHUB_SHA` | Full commit hash |
| `GITHUB_WORKSPACE` | Path to checked-out code |
| `RUNNER_OS` | `Linux`, `macOS`, or `Windows` |

---

## Step-by-Step Practical Lab

Follow these steps in order. Do not skip any step.

### Step 1 — Set up Git and verify configuration

```bash
git --version
git config --list
# Confirm user.name and user.email are set
```

### Step 2 — Create the GitHub repository

```bash
# Option A: Using GitHub CLI
gh repo create devops-internship-labs --public --clone
cd devops-internship-labs

# Option B: Manually
# Create repo on github.com first, then:
git clone git@github.com:YOUR_USERNAME/devops-internship-labs.git
cd devops-internship-labs
```

### Step 3 — Add Week 1 work and push to main

```bash
mkdir -p week1-linux/scripts week1-linux/logs week1-linux/notes week1-linux/backup

# Copy your Week 1 scripts here, or create them fresh
cat > week1-linux/scripts/system_info.sh <<'EOF'
#!/bin/bash
echo "User: $(whoami)"
echo "Date: $(date)"
echo "Current directory: $(pwd)"
echo "Disk usage:"
df -h
echo "Memory usage:"
free -h
EOF

chmod +x week1-linux/scripts/system_info.sh
./week1-linux/scripts/system_info.sh | tee week1-linux/logs/system-info.log

cat > README.md <<'EOF'
# DevOps Internship Labs

Week-by-week DevOps practice repository.

## Weeks
- [Week 1 - Linux Fundamentals](./week1-linux/README.md)
- [Week 2 - Git, GitHub, and CI/CD](./week2-git-cicd/README.md)
EOF

git add .
git commit -m "chore: add week1 linux practice and root README"
git branch -M main
git remote add origin git@github.com:YOUR_USERNAME/devops-internship-labs.git
git push -u origin main
```

### Step 4 — Create Week 2 branch

```bash
git checkout -b week2-git-cicd
git branch
# Confirm you are on week2-git-cicd
```

### Step 5 — Create the GitHub Actions workflow

```bash
mkdir -p .github/workflows

cat > .github/workflows/basic-check.yml <<'EOF'
name: Basic DevOps Check

on:
  push:
    branches: [ main, week2-git-cicd ]
  pull_request:
    branches: [ main ]

jobs:
  check:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Show repository files
        run: ls -la

      - name: Show current directory and environment
        run: |
          pwd
          echo "Branch: $GITHUB_REF_NAME"
          echo "Triggered by: $GITHUB_ACTOR"

      - name: Run shell script syntax check
        run: bash -n week1-linux/scripts/system_info.sh

      - name: Validate folder structure
        run: |
          test -d week1-linux/scripts && echo "scripts folder exists" || echo "WARNING: scripts folder missing"
          test -f week1-linux/scripts/system_info.sh && echo "system_info.sh exists" || echo "WARNING: script missing"
EOF
```

### Step 6 — Create Week 2 README and notes

```bash
mkdir -p week2-git-cicd

cat > week2-git-cicd/README.md <<'EOF'
# Week 2 - Git, GitHub, and CI/CD

## What I Learned
- Git three-area model: working directory, staging, repository
- Branching and merging workflow
- SSH key authentication for GitHub
- GitHub pull request workflow
- GitHub Actions CI/CD pipeline

## Key Commands Used
- `git init`, `git add`, `git commit`, `git push`, `git pull`
- `git checkout -b branch-name`
- `git log --oneline --graph`
- `gh pr create`

## CI/CD Workflow
The workflow at `.github/workflows/basic-check.yml` runs on every push and pull request.
It checks out the code, shows the repo structure, and validates shell script syntax.

## Problems Faced and Solutions
- Issue: SSH authentication failed
  Solution: Generated ed25519 key and added public key to GitHub settings

## Screenshots
(Add screenshots of: Actions tab, PR page, merged PR, workflow run)
EOF
```

### Step 7 — Commit and push Week 2 work

```bash
git add .
git commit -m "ci: add github actions workflow and week2 notes"
git push -u origin week2-git-cicd
```

### Step 8 — Open a Pull Request

```bash
# Using GitHub CLI
gh pr create \
  --title "ci: add github actions basic check workflow" \
  --body "Week 2 submission: Added GitHub Actions CI pipeline that validates shell scripts and folder structure. Includes week2 README documentation."

# Or open GitHub in browser → Compare & pull request
```

### Step 9 — Check the Actions tab

On GitHub:
1. Go to your repository
2. Click **Actions** tab
3. You should see your workflow running
4. Click on the run to see each step's output
5. All steps should show green checkmarks

### Step 10 — Merge the Pull Request

```bash
# After CI passes:
gh pr merge 1 --merge
# Or merge from GitHub UI

# Switch back to main and pull latest
git checkout main
git pull

# Delete the merged branch locally
git branch -d week2-git-cicd
```

---

## Weekly Tasks and Deliverables

Complete all of the following and document each with screenshots:

- [x] Install Git and configure `user.name`, `user.email`, `init.defaultBranch`
- [x] Set up SSH key authentication for GitHub
- [x] Create GitHub repository `devops-internship-labs`
- [x] Push Week 1 Linux work to `main` branch
- [x] Create `week2-git-cicd` feature branch
- [x] Create `.github/workflows/basic-check.yml` with at least 4 steps
- [x] Push branch and verify workflow runs in Actions tab
- [x] Open a Pull Request with proper title and description
- [x] Merge the Pull Request after CI passes
- [x] Write `week2-git-cicd/README.md` explaining:
  - What CI/CD means and why it matters
  - What each step in the workflow does
  - Problems faced and how you solved them
  - Screenshot of the green workflow run
- [x] Add `.gitignore` to repository root

---

## Common Errors and Fixes

| Error | Cause | Fix |
|---|---|---|
| `Permission denied (publickey)` | SSH key not added to GitHub or agent | Run `ssh-add ~/.ssh/id_ed25519` and verify key in GitHub Settings |
| `remote: Repository not found` | Wrong remote URL or no access | Check `git remote -v` and verify the URL |
| `Authentication failed` | Password auth is no longer accepted | Use SSH key or create a Personal Access Token |
| `YAML workflow not running` | File is in wrong path or YAML syntax error | File must be at `.github/workflows/*.yml`. Check indentation. |
| `bash: bad interpreter` | Script has Windows line endings (`\r\n`) | Run `sed -i 's/\r//' script.sh` |
| `Merge conflict` | Two branches changed the same lines | Open file, remove conflict markers, keep correct code, commit |
| `Updates were rejected` | Remote has commits you do not have | Run `git pull --rebase` first, then push |
| `error: src refspec main does not match any` | No commits exist yet | Make at least one commit before pushing |
| `fatal: not a git repository` | Running Git command outside a repo | `cd` into the correct folder or run `git init` |

---

## Key Terms Glossary

| Term | Definition |
|---|---|
| **Repository (repo)** | A folder tracked by Git containing all project files and history |
| **Commit** | A saved snapshot of staged changes with a message and unique hash |
| **Branch** | An independent line of development branching off from another point |
| **Merge** | Combining changes from one branch into another |
| **HEAD** | A pointer to your current position in Git history |
| **Remote** | A repository hosted on another server (e.g., GitHub) |
| **Origin** | The conventional name for the primary remote repository |
| **Pull Request (PR)** | A GitHub feature requesting that a branch be merged into another |
| **CI** | Continuous Integration — automatically test code on every push |
| **CD** | Continuous Delivery/Deployment — automatically prepare or release code |
| **Workflow** | A YAML file defining automated tasks in GitHub Actions |
| **Runner** | The virtual machine that executes a GitHub Actions job |
| **Action** | A reusable building block for GitHub Actions steps |
| **Staging Area** | The intermediate zone where you select changes before committing |
| **Working Directory** | The folder where you actively edit files |
| **Fast-forward** | A merge where Git simply moves the branch pointer forward — no merge commit created |
| **No-fast-forward** | A merge that always creates a merge commit, preserving branch history |
| **Squash merge** | Collapsing all commits from a branch into a single commit before merging |
| **Rebase** | Replaying commits on top of another branch for a linear, clean history |
| **Interactive rebase** | A rebase where you can edit, squash, reorder, or drop individual commits |
| **git fetch** | Downloads remote changes without applying them to your working branch |
| **git pull** | Downloads remote changes and immediately merges them into your current branch |
| **git pull --rebase** | Downloads remote changes and replays your local commits on top instead of creating a merge commit |
| **git stash** | Temporarily saves uncommitted work so you can switch context and restore it later |
| **git cherry-pick** | Copies a specific commit from one branch and applies it to your current branch |
| **git diff** | Shows the exact line-by-line changes between files, commits, or branches |
| **git tag** | Marks a specific commit as a named reference point, usually for version releases |
| **git reflog** | A local log of all HEAD movements — your safety net for recovering lost commits |
| **Detached HEAD** | A state where HEAD points directly to a commit instead of a branch |
| **Upstream** | The remote branch that a local branch tracks for push and pull |
| **SSH Key** | A cryptographic key pair used for secure, passwordless authentication |
| **Webhook** | An HTTP callback triggered by events (GitHub uses these to start Actions) |
| **SemVer** | Semantic Versioning — the `v MAJOR.MINOR.PATCH` standard for release tags |

---

## Quick Reference Cheat Sheet

```bash
# ── SETUP ──────────────────────────────────────────────────────────
git config --global user.name "Name"
git config --global user.email "email@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase true       # Always rebase on pull

# ── INITIALIZE / CLONE ─────────────────────────────────────────────
git init                                   # Create new repo
git clone git@github.com:USER/repo.git     # Clone via SSH
git clone --depth=1 URL                    # Shallow clone (no full history)
git clone --branch branchname URL          # Clone specific branch

# ── DAILY WORKFLOW ─────────────────────────────────────────────────
git status                      # See what changed
git diff                        # See unstaged changes
git diff --staged               # See staged changes
git add .                       # Stage all changes
git add -p filename             # Stage interactively (chunk by chunk)
git commit -m "type: message"   # Save staged changes
git push                        # Upload to GitHub
git pull                        # Download + merge from GitHub
git pull --rebase               # Download + rebase (cleaner history)

# ── FETCH vs PULL ──────────────────────────────────────────────────
git fetch origin                # Download without merging
git log HEAD..origin/main       # See what is new on remote
git merge origin/main           # Merge fetched changes manually

# ── BRANCHING ──────────────────────────────────────────────────────
git checkout -b branch-name     # Create and switch to new branch
git checkout main               # Switch to main
git switch -c branch-name       # Modern way to create + switch
git branch -a                   # List all branches (local + remote)
git branch -d branch-name       # Delete branch (safe, only if merged)
git branch -D branch-name       # Force delete branch

# ── MERGING ────────────────────────────────────────────────────────
git merge branch-name           # Merge (fast-forward if possible)
git merge --no-ff branch-name   # Always create merge commit
git merge --squash branch-name  # Squash all commits into one

# ── REBASE ─────────────────────────────────────────────────────────
git rebase main                 # Replay current branch onto main
git rebase -i HEAD~3            # Interactively edit last 3 commits
git rebase --continue           # Continue after conflict resolution
git rebase --abort              # Cancel rebase in progress

# ── STASH ──────────────────────────────────────────────────────────
git stash                       # Save current uncommitted work
git stash push -m "description" # Stash with a label
git stash list                  # View all stashes
git stash pop                   # Apply latest stash + remove from list
git stash apply stash@{1}       # Apply specific stash, keep in list
git stash drop stash@{0}        # Delete a stash
git stash clear                 # Delete all stashes

# ── CHERRY-PICK ────────────────────────────────────────────────────
git cherry-pick a1b2c3          # Copy one commit to current branch
git cherry-pick a1b2c3 d4e5f6   # Copy multiple commits
git cherry-pick --no-commit abc # Apply changes without committing

# ── HISTORY ────────────────────────────────────────────────────────
git log --oneline               # Compact history
git log --oneline --graph --all # Visual branch graph
git log --oneline --max-count=5 # Last 5 commits only
git show commit-hash            # Show a specific commit
git blame filename              # Who changed each line
git reflog                      # All HEAD movements (safety net)

# ── DIFF ───────────────────────────────────────────────────────────
git diff                        # Unstaged changes
git diff --staged               # Staged changes
git diff main feature-branch    # Between two branches
git diff HEAD HEAD~2            # Between current and 2 commits ago
git diff --stat                 # Summary of changed files

# ── TAGS ───────────────────────────────────────────────────────────
git tag -a v1.0.0 -m "message"  # Create annotated tag
git tag                         # List all tags
git push origin v1.0.0          # Push tag to remote
git push origin --tags          # Push all tags

# ── UNDO ───────────────────────────────────────────────────────────
git restore filename            # Discard working dir changes
git restore --staged filename   # Unstage a file
git reset --soft HEAD~1         # Undo last commit, keep staged
git reset --mixed HEAD~1        # Undo last commit, unstage changes
git reset --hard HEAD~1         # Undo last commit, delete changes (DANGEROUS)
git revert commit-hash          # Undo commit safely (shared branches)

# ── REMOTE ─────────────────────────────────────────────────────────
git remote -v                   # View remotes
git remote add origin URL       # Add remote
git remote set-url origin URL   # Change remote URL
git push -u origin branch       # Push and set upstream
git push --force-with-lease     # Safe force push (checks remote first)

# ── GITHUB CLI ─────────────────────────────────────────────────────
gh repo create name --public    # Create repo
gh pr create                    # Open pull request
gh pr list                      # List pull requests
gh pr merge 1                   # Merge PR #1
gh auth status                  # Check login status
```

---

*Week 2 Complete — Continue to Week 3: Docker and Docker Compose*
