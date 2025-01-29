
<!---
.. ===============LICENSE_START=======================================================
.. Aimee Ukasick CC-BY-4.0
.. ===================================================================================
.. Copyright (C) 2019 Aimee Ukasick. All rights reserved.
.. ===================================================================================
.. This documentation file is distributed by Aimee Ukasick
.. under the Creative Commons Attribution 4.0 International License (the "License");
.. you may not use this file except in compliance with the License.
.. You may obtain a copy of the License at
..
.. http://creativecommons.org/licenses/by/4.0
..
.. This file is distributed on an "AS IS" BASIS,
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
.. See the License for the specific language governing permissions and
.. limitations under the License.
.. ===============LICENSE_END=========================================================
-->

# Git Tutorial

https://github.com/Gazler/githug

# Clone single branch

 - ``git clone --single-branch --branch <branchname> <remote-repo>``

## Mirror single branch
- `git clone --bare --single-branch --branch master git@github.com:<user>/<repo>.git`
- `git push --mirror git@github.com:<user>/<new-repo>.git`

New repo must exist before you push.
https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository  

# Branches

- ```git checkout <branch_name>``` switches to that branch, pulling it down from origin if needed
- ```git checkout -b <branch_name>``` creates and checks out a new branch
- ```git branch``` lists names of local branches

## Check out a branch and create a local working copy against that branch

```
# Check out remote feature branch, such as dev
git checkout dynamic-host-volumes-docs

# Creates the ce805 branch off dynamic-host-volumes-docs. Do your work and then
git checkout -b ce805 dynamic-host-volumes-docs

# update and commit
git commit -am "Your message"

# push local to origin, which should be the existing dynamic-host-volumes-docs branch
git push -u origin ce805
# The -u flag ensures that myFeature is created in our remote repository and linked to our local myFeature branch.
```
https://www.geeksforgeeks.org/git-create-a-branch-from-another-branch/

## Rename

1. Rename your local branch.
If you are on the branch you want to rename: `git branch -m new-name`
If you are on a different branch: `git branch -m old-name new-name`
2. Delete the old-name remote branch and push the new-name local branch.

   `git push origin :old-name new-name`

3. Reset the upstream branch for the new-name local branch.
   Switch to the branch and then: `git push origin -u new-name`

## Delete

- ```git branch -d <branch_name>``` The -d option is an alias for --delete, which only deletes the branch if it has already been fully merged in its upstream branch
- ``` git branch -D <branch_name>``` You could also use -D, which is an alias for --delete --force, which deletes the branch "irrespective of its merged status."
- ```git push <remote_name> --delete <branch_name>``` to delete a remote branch
# File
https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting

git revert: an operation that takes a specified commit and creates a new commit which inverses the specified commit. git revert can only be run at a commit level scope and has no file level functionality

git checkout:  A file level checkout will change the file's contents to those of the specific commit; discard changes in the working directory

git reset: an operation that takes a specified commit and resets the "three trees" to match the state of the repository at that specified commit. A reset can be invoked in three different modes which correspond to the three trees.



- ```git checkout -- <file>```

# Log
- ```git log --pretty=format:"%h - %an, %ar : %s"```  ca82a6d - Scott Chacon, 6 years ago : changed the version number
- `git log --oneline`

# Rebase vs Merge

courtesy of Kevin Woo:

* **rebase**: if you are working by yourself and pulling in changes from somewhere (but you ultimately are owning it and just you)
* **merge**: works well with others because you don't rewrite commits that you don't own

If you have a branch branched from another branch instead of master, and you want to update from master:

```bash
git checkout master
git pull
git checkout matrix/pcm-v1
git merge master
git push
git checkout matrix/pcm-v1-clouddriver
git merge matrix/pcm-v1   <---- merging from this branch because I based off of of matrix/pcm-v1
git push
```

this keeps the history as clean as possible


rebasing is saying "i'm going to override all the existing commits with a new signature so nothing will be easily matched"


another option is just to do:

```bash
git checkout matrix/pcm-v1-clouddriver
git merge master
```
# Cherry Pick

- Cherry pick commit from master into a release branch.
- Make sure origin is up-to-date upstream.

## In master, find the commit you want to cherry pick.
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git log --oneline
...
82d811354 Fix site build (#16531)
```

```git branch -r``` to see all available branches

## git checkout release branch
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git checkout origin/release-1.16
Note: checking out 'origin/release-1.16'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 32b0e539a promote AWS-NLB Support from alpha to beta (#14451) (#16459) (#16484)
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git branch
* (HEAD detached at origin/release-1.16)
  15748-removeThirdPartyContent
  15965-blog
  16100-mentionContentGuide
  aimeeu-2019SurveyResultsBlog
  aimeeu-bootstrapVersion
  aimeeu-updateRefDocsLocation
  clarifyContentGuide
  master
  release-1.16
  updateTriageSection
```

## Create a local branch for changes.
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git checkout -b aimeeu-1.16-cherrypick-pr16531
Switched to a new branch 'aimeeu-1.16-cherrypick-pr16531'
```

## Cherry pick

https://git-scm.com/docs/git-cherry-pick

Note: using ```git cherry-pick --edit <hash>``` will enable you to edit the commit message
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git cherry-pick 82d811354 --edit
[aimeeu-1.16-cherrypick-pr16531 14105459f] Fix site build (#16531)
 Author: Qiming <tengqim@cn.ibm.com>
 Date: Wed Sep 25 00:35:30 2019 +0800
 4 files changed, 24 insertions(+), 22 deletions(-)
 delete mode 100644 content/en/docs/tutorials/clusters/deny-write.profile
 delete mode 100644 content/ko/docs/tutorials/clusters/deny-write.profile
```
Note that ```git status``` says nothing to commit
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git status
On branch aimeeu-1.16-cherrypick-pr16531
nothing to commit, working tree clean
```

## Test compile
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo version
Hugo Static Site Generator v0.57.2-A849CB2D/extended linux/amd64 BuildDate: 2019-08-17T17:57:54Z
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo serve
Building sites … WARN 2019/10/01 15:26:00 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 15:26:00 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 15:26:00 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.

                   |  EN  |  ZH  |  KO  |  JA  |  FR  |  DE  |  ES  |  PT  |  ID   
+------------------+------+------+------+------+------+------+------+------+------+
  Pages            | 1069 |  208 |  270 |  136 |  206 |  103 |  144 |   25 |   83  
  Paginator pages  |  296 |    7 |    0 |    0 |    0 |    0 |    0 |    0 |    0  
  Non-page files   |  438 |  181 |  150 |  215 |  106 |   67 |   77 |   12 |   42  
  Static files     | 1012 | 1012 | 1012 | 1012 | 1012 | 1012 | 1012 | 1012 | 1012  
  Processed images |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0  
  Aliases          |    5 |    1 |    0 |    0 |    1 |    1 |    1 |    1 |    0  
  Sitemaps         |    2 |    1 |    1 |    1 |    1 |    1 |    1 |    1 |    1  
  Cleaned          |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0  

Total in 8509 ms
Watching for changes in /home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/{archetypes,assets,content,data,i18n,layouts,static}
Watching for config changes in /home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

## Force push changes
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git push -f origin aimeeu-1.16-cherrypick-pr16531
Enumerating objects: 22, done.
Counting objects: 100% (22/22), done.
Delta compression using up to 4 threads
Compressing objects: 100% (9/9), done.
Writing objects: 100% (13/13), 8.59 KiB | 8.59 MiB/s, done.
Total 13 (delta 8), reused 7 (delta 4)
remote: Resolving deltas: 100% (8/8), completed with 8 local objects.
remote:
remote: Create a pull request for 'aimeeu-1.16-cherrypick-pr16531' on GitHub by visiting:
remote:      https://github.com/aimeeu/website/pull/new/aimeeu-1.16-cherrypick-pr16531
remote:
To github.com:aimeeu/website.git
 * [new branch]          aimeeu-1.16-cherrypick-pr16531 -> aimeeu-1.16-cherrypick-pr16531
```

## Create PR
Create PR in kubernetes/website - **be sure to pick the correct kubernetes/website branch**

## Stash and pop and unstash

The default interactive shell is now zsh.
To update your account to use zsh, please run `chsh -s /bin/zsh`.
For more details, please visit https://support.apple.com/kb/HT208050.
aimeeu@aimeeuMBP16:~/Dev/git/github.com/armory/docs$ git status
On branch agent-mtls
Your branch is up to date with 'origin/agent-mtls'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   content/en/docs/armory-agent/agent-monitoring.md
        modified:   content/en/docs/armory-agent/agent-uninstalling.md

Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add <file>..." to mark resolution)
        both modified:   content/en/docs/armory-agent/_index.md
        both modified:   content/en/docs/armory-agent/agent-options.md
        both modified:   content/en/docs/armory-agent/agent-plugin-options.md
        both modified:   content/en/docs/armory-agent/agent-troubleshooting.md
        both modified:   content/en/docs/armory-agent/armory-agent-quick.md

aimeeu@aimeeuMBP16:~/Dev/git/github.com/armory/docs$ git reset HEAD .
Unstaged changes after reset:
M       content/en/docs/armory-agent/_index.md
M       content/en/docs/armory-agent/agent-monitoring.md
M       content/en/docs/armory-agent/agent-options.md
M       content/en/docs/armory-agent/agent-plugin-options.md
M       content/en/docs/armory-agent/agent-troubleshooting.md
M       content/en/docs/armory-agent/agent-uninstalling.md
M       content/en/docs/armory-agent/armory-agent-quick.md
aimeeu@aimeeuMBP16:~/Dev/git/github.com/armory/docs$ git status
On branch agent-mtls
Your branch is up to date with 'origin/agent-mtls'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   content/en/docs/armory-agent/_index.md
        modified:   content/en/docs/armory-agent/agent-monitoring.md
        modified:   content/en/docs/armory-agent/agent-options.md
        modified:   content/en/docs/armory-agent/agent-plugin-options.md
        modified:   content/en/docs/armory-agent/agent-troubleshooting.md
        modified:   content/en/docs/armory-agent/agent-uninstalling.md
        modified:   content/en/docs/armory-agent/armory-agent-quick.md

no changes added to commit (use "git add" and/or "git commit -a")
aimeeu@aimeeuMBP16:~/Dev/git/github.com/armory/docs$ git stash list
stash@{0}: WIP on eng5172-agentClusterRole: add3ec2 eng-5896
stash@{1}: WIP on cookiebot-375: b3b872f Merge branch 'master' into cookiebot-375
aimeeu@aimeeuMBP16:~/Dev/git/github.com/armory/docs$ git checkout content/en/docs/armory-agent/_index.md
Updated 1 path from the index
aimeeu@aimeeuMBP16:~/Dev/git/github.com/armory/docs$ git status
On branch agent-mtls
Your branch is up to date with 'origin/agent-mtls'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   content/en/docs/armory-agent/agent-monitoring.md
        modified:   content/en/docs/armory-agent/agent-options.md
        modified:   content/en/docs/armory-agent/agent-plugin-options.md
        modified:   content/en/docs/armory-agent/agent-troubleshooting.md
        modified:   content/en/docs/armory-agent/agent-uninstalling.md
        modified:   content/en/docs/armory-agent/armory-agent-quick.md

no changes added to commit (use "git add" and/or "git commit -a")
aimeeu@aimeeuMBP16:~/Dev/git/github.com/armory/docs$ git checkout master
error: Your local changes to the following files would be overwritten by checkout:
        content/en/docs/armory-agent/agent-monitoring.md
        content/en/docs/armory-agent/agent-options.md
        content/en/docs/armory-agent/agent-plugin-options.md
        content/en/docs/armory-agent/agent-troubleshooting.md
        content/en/docs/armory-agent/armory-agent-quick.md
Please commit your changes or stash them before you switch branches.
Aborting
aimeeu@aimeeuMBP16:~/Dev/git/github.com/armory/docs$ git checkout agent-mtls -- content/en/docs/armory-agent/
aimeeu@aimeeuMBP16:~/Dev/git/github.com/armory/docs$ git status
On branch agent-mtls
Your branch is up to date with 'origin/agent-mtls'.

nothing to commit, working tree clean
aimeeu@aimeeuMBP16:~/Dev/git/github.com/armory/docs$ git checkout master
Switched to branch 'master'
Your branch is ahead of 'origin/master' by 7 commits.
  (use "git push" to publish your local commits)
  
  
  type killmerged
killmerged is an alias for git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -dexport
