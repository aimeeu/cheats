# Generating Reference Documentation for the Kubernetes API

## Generate manually
using instructions in contribute/generate-ref-docs https://kubernetes.io/docs/contribute/generate-ref-docs/kubernetes-api/

### Clone repos
make sure my fork is current with upstream

```shell
aimee@aimee-lemur:~/Dev/go$ go get -u github.com/kubernetes-incubator/reference-docs
aimee@aimee-lemur:~/Dev/go$ go get -u github.com/go-openapi/loads
aimee@aimee-lemur:~/Dev/go$ go get -u github.com/go-openapi/spec
aimee@aimee-lemur:~/Dev/go$ git clone https://github.com/aimeeu/website $GOPATH/src/github.com/aimeeu/website
fatal: destination path '/home/aimee/Dev/go/src/github.com/aimeeu/website' already exists and is not an empty directory.
aimee@aimee-lemur:~/Dev/go$ git clone https://github.com/aimeeu/website $GOPATH/src/github.com/aimeeu/website
Cloning into '/home/aimee/Dev/go/src/github.com/aimeeu/website'...
remote: Enumerating objects: 19, done.
remote: Counting objects: 100% (19/19), done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 116641 (delta 6), reused 9 (delta 2), pack-reused 116622
Receiving objects: 100% (116641/116641), 236.39 MiB | 27.13 MiB/s, done.
Resolving deltas: 100% (76178/76178), done.
aimee@aimee-lemur:~/Dev/go$ git clone https://github.com/kubernetes/kubernetes $GOPATH/src/k8s.io/kubernetes
Cloning into '/home/aimee/Dev/go/src/k8s.io/kubernetes'...
remote: Enumerating objects: 340, done.
remote: Counting objects: 100% (340/340), done.
remote: Compressing objects: 100% (206/206), done.
remote: Total 1009646 (delta 174), reused 156 (delta 134), pack-reused 1009306
Receiving objects: 100% (1009646/1009646), 670.85 MiB | 27.67 MiB/s, done.
Resolving deltas: 100% (709662/709662), done.
Checking out files: 100% (21030/21030), done.

```
![file-system](../img/apiDocsReposLocal.png)

### Manually modify reference-docs makefile

Update the makefile with local directories:
```
WEBROOT=~/Dev/go/src/github.com/aimeeu/website
K8SROOT=~/Dev/go/src/k8s.io/kubernetes
MINOR_VERSION=16
```

### Generate API Docs

Run ```updateapispec```
```shell
aimee@aimee-lemur:~/Dev/go/src/github.com/kubernetes-incubator/reference-docs$ make updateapispec
cp ~/Dev/go/src/k8s.io/kubernetes/api/openapi-spec/swagger.json gen-apidocs/generators/openapi-spec/swagger.json
```

Run ```make apidocs``` (why does ```cleanapi``` require sudo??? shouldn't!!! neither should ```cleancli```)
```shell
aimee@aimee-lemur:~/Dev/go/src/github.com/kubernetes-incubator/reference-docs$ make api
sudo rm -rf /home/aimee/Dev/go/src/github.com/kubernetes-incubator/reference-docs/gen-apidocs/generators/build
[sudo] password for aimee:
sudo rm -rf /home/aimee/Dev/go/src/github.com/kubernetes-incubator/reference-docs/gen-apidocs/generators/includes
go run gen-apidocs/main.go --config-dir=gen-apidocs/generators --munge-groups=false

..... plus lots more output
```

Verify files have been generated:
```shell
aimee@aimee-lemur:~/Dev/go/src/github.com/kubernetes-incubator/reference-docs$ [ -e "gen-apidocs/generators/build/index.html" ] && echo "index.html built" || echo "no index.html"
index.html built
aimee@aimee-lemur:~/Dev/go/src/github.com/kubernetes-incubator/reference-docs$ [ -e "gen-apidocs/generators/build/navData.js" ] && echo "navData.js built" || echo "no navData.js"
navData.js built
```

### Copying the generated docs to the kubernetes/website repository

```shell
aimee@aimee-lemur:~/Dev/go/src/github.com/kubernetes-incubator/reference-docs$ make copyapi
cp gen-apidocs/generators/build/index.html ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/index.html
cp gen-apidocs/generators/build/navData.js ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/navData.js
cp gen-apidocs/generators/static/scroll.js ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/scroll.js
mkdir -p ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/css
cp gen-apidocs/generators/static/stylesheet.css ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/css/stylesheet.css
cp gen-apidocs/generators/static/bootstrap.min.css ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/css/bootstrap.min.css
cp gen-apidocs/generators/static/jquery.scrollTo.min.js ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/jquery.scrollTo.min.js
cp gen-apidocs/generators/static/font-awesome.min.css ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/css/font-awesome.min.css
mkdir -p ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/fonts
cp gen-apidocs/generators/static/FontAwesome.otf ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/fonts/FontAwesome.otf
cp gen-apidocs/generators/static/fontawesome-webfont.eot ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/fonts/fontawesome-webfont.eot
cp gen-apidocs/generators/static/fontawesome-webfont.svg ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/fonts/fontawesome-webfont.svg
cp gen-apidocs/generators/static/fontawesome-webfont.ttf ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/fonts/fontawesome-webfont.ttf
cp gen-apidocs/generators/static/fontawesome-webfont.woff ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/fonts/fontawesome-webfont.woff
cp gen-apidocs/generators/static/fontawesome-webfont.woff2 ~/Dev/go/src/github.com/aimeeu/website/static/docs/reference/generated/kubernetes-api/v1.16/fonts/fontawesome-webfont.woff2

aimee@aimee-lemur:~/Dev/go/src/github.com/kubernetes-incubator/reference-docs$ cd ../../aimeeu/website
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website$

aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website$ git status
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   static/docs/reference/generated/kubernetes-api/v1.16/index.html
	modified:   static/docs/reference/generated/kubernetes-api/v1.16/navData.js

no changes added to commit (use "git add" and/or "git commit -a")

```

### Manually update the API reference index page
Update the API reference version number - this is the .dot version that is set in the Makefile

```shell
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website$ cd content/en/docs/reference/kubernetes-api
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website/content/en/docs/reference/kubernetes-api$ cat index.md
---
title: v1.16
---

[Kubernetes API v1.16](/docs/reference/generated/kubernetes-api/v1.16/)
```

### Manually add link to new version of ref docs

Open ```<web-base>/content/en/docs/reference/_index.md``` for editing, and add a new link for the latest API reference. Remove the oldest API reference version. There should be five links to the most recent API references.

```shell
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website/content/en/docs/reference/kubernetes-api$ cd ../
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website/content/en/docs/reference$ cat _index.md
---
title: Reference
approvers:
- chenopis
linkTitle: "Reference"
main_menu: true
weight: 70
content_template: templates/concept
---

{{% capture overview %}}

This section of the Kubernetes documentation contains references.

{{% /capture %}}

{{% capture body %}}

## API Reference
* [Kubernetes API Overview](/docs/reference/using-api/api-overview/) - Overview of the API for Kubernetes.
* Kubernetes API Versions
  * [1.16](/docs/reference/generated/kubernetes-api/v1.16/)
  * [1.15](/docs/reference/generated/kubernetes-api/v1.15/)
  * [1.14](/docs/reference/generated/kubernetes-api/v1.14/)
  * [1.13](/docs/reference/generated/kubernetes-api/v1.13/)
  * [1.12](/docs/reference/generated/kubernetes-api/v1.12/)
```

### Test locally

```shell
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website$ hugo serve
```

or use ```make docker-serve``` although I got a 'pull access denied for kubernetes-hugo' repo

## Automate process

- create bash script (or python or go??) that takes in k8s_base, web_base, rdocs_base, minor_version, github_username
- git clone https://github.com/<your-username>/website $GOPATH/src/github.com/<your-username>/website  IS WRONG WRONG WRONG - use git clone git@github.com:<github_username>/website so SSH is used to push the PR at the end
- after cloning k/website, checkout branch
- remove sudo from cleanapi and cleancli targets
- modify reference-docs/makefile to take in parameters? web_base, k8s_base, minor_version  OR rename Makefile to Makefile.orig and use sed to update and stream results to Makefile
- how to modify ```<web-base>/content/en/docs/reference/_index.md```  ????
