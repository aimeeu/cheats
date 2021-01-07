
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

# Contributing
The Kubernetes projects use a single fork with multiple branch approach, as opposed to the git/gerrit workflow.
- https://kubernetes.io/docs/contribute/intermediate/#work-from-a-local-clone
- https://github.com/kubernetes/community/blob/master/contributors/guide/github-workflow.md

## Set up

1. Fork in the cloud: go to https://www.github.com/kubernetes/website and fork
1. Clone your local fork

   git clone git@github.com:<github_id>/website.git
   
    ```bash
    git clone git@github.com:aimeeu/website.git
    ```
1. Set kubernetes/website as upstream remote
    ```bash
    git remote add upstream https://github.com/kubernetes/kubernetes.git
    ```
1. Confirm remotes
    ```bash
    git remote -v
    origin	git@github.com:aimeeu/website.git (fetch)
    origin	git@github.com:aimeeu/website.git (push)
    upstream	https://github.com/kubernetes/website (fetch)
    upstream	https://github.com/kubernetes/website (push)
    ```

Note: if you need to change the url for a remote, use git remote set-url <upstream> <new url>

## Update fork master from kubernetes/website master

**Always always always** update your master fork before you create a branch for a PR!

```bash
git checkout master
git fetch origin
git fetch upstream
git merge upstream/master
git push -f origin
```

``` bash
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git fetch upstream
remote: Enumerating objects: 40, done.
remote: Counting objects: 100% (40/40), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 57 (delta 36), reused 36 (delta 36), pack-reused 17
Unpacking objects: 100% (57/57), done.
From https://github.com/kubernetes/website
   24eee4265..5153d6e4f  master        -> upstream/master
   de2a1b36a..8480ad721  dev-1.15-ja.1 -> upstream/dev-1.15-ja.1
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git merge upstream/master
Updating 24eee4265..5153d6e4f
Fast-forward
 content/en/docs/concepts/storage/storage-classes.md                | 18 +++++++++++++++---
 content/en/docs/setup/production-environment/container-runtimes.md |  5 +++++
 content/es/docs/reference/glossary/applications.md                 | 13 +++++++++++++
 content/fr/docs/reference/glossary/pod.md                          | 18 ++++++++++++++++++
 4 files changed, 51 insertions(+), 3 deletions(-)
 create mode 100644 content/es/docs/reference/glossary/applications.md
 create mode 100644 content/fr/docs/reference/glossary/pod.md
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git push -f origin
Total 0 (delta 0), reused 0 (delta 0)
To github.com:aimeeu/website.git
 + 8398508e5...5153d6e4f master -> master (forced update)
```

# Working locally

1. **Always** update origin/master from upstream/master before creating a local working branch!! **Never** use ```git pull``` to do a merge because that creates a merge commit, which makes commit history messy. https://kubernetes.io/docs/contribute/new-content/open-a-pr/#changes-using-github
1. Create a local working branch
    ```bash
    git checkout -b <branch-name> upstream/master
    ```
1. Makes changes, test locally
    ```bash
    hugo serve
    ```
1. Commit and push
    ```bash
    git commit -as
    git push -f origin <branch-name>
    ```
1. Go to https://github.com/kubernetes/website and create a Pull Request; follow instructions in #7 https://kubernetes.io/docs/contribute/intermediate/#work-on-the-local-repository
1. Address feedback, push updates
    ```bash
    git commit -a --amend
    git push -f origin <branch-name>
    ```
1. When all feedback has been addressed, squash commits down to a single commit (k8s project policy); check the number of commits on the PR's Commits tab and with ```git log```. If the number of commits you made is not the same between the two, you've foobarred something. Might lead to squash/rebase hell. Note: you will not have to squash commits if you use ```git commit --amend`` 
    ```bash
    git rebase -i HEAD~<number of commits>
    ```
    - https://www.devroom.io/2011/07/05/git-squash-your-latests-commits-into-one/
    - https://git-scm.com/docs/git-rebase
    

Note: if you use ```git commit -a --amend```, only one commit will appear in the GitHub UI. So keep the commit message the same and just add line items for what was updated in each commit (the opposite of OpenStack etiquette).

# Pulling down somebody's PR for local testing

https://help.github.com/en/articles/checking-out-pull-requests-locally

```bash
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git checkout master
Switched to branch 'master'
Your branch is up to date with 'upstream/master'.
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git remote -v
origin	git@github.com:aimeeu/website.git (fetch)
origin	git@github.com:aimeeu/website.git (push)
upstream	https://github.com/kubernetes/website (fetch)
upstream	no_push (push)
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git fetch upstream pull/16813/head:update115toHugo572
remote: Enumerating objects: 1, done.
remote: Counting objects: 100% (1/1), done.
remote: Total 2 (delta 1), reused 1 (delta 1), pack-reused 1
Unpacking objects: 100% (2/2), done.
From https://github.com/kubernetes/website
 * [new ref]             refs/pull/16813/head -> update115toHugo572
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ git branch
  15748-removeThirdPartyContent
  15965-blog
  aimeeu-15878-contribIntermediate
  aimeeu-2019SurveyResultsBlog
  aimeeu-addReviewBestPractices
  aimeeu-bootstrapVersion
  aimeeu-updateImportedDocsScriptDirections
  aimeeu-updateRefDocsLocation
  clarifyContentGuide
* master
  release-1.16
  update115toHugo572

```
