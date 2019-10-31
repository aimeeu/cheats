# Manually generate API and kubectl reference docs

## Prerequisites

1. Golang version that is [supported](https://github.com/kubernetes/community/blob/master/contributors/devel/development.md#go) by Kubernetes; currently Golan v1.12.x
2. Git
3. Hugo 57.2 OR Docker for building and testing the website locally
4. Your kubernetes/website fork is up to date with upstream/master

## Create Go workspace and set GOPATH
This presumes you start in your HOME directory.
```bash
mkdir ref-docs-gen
cd ref*
mkdir src
export GOPATH=$HOME/ref-docs-gen/src
echo $GOPATH
```

## Clone repos
```bash
go get -u github.com/go-openapi/loads
go get -u github.com/go-openapi/spec
go get -u github.com/kubernetes-sigs/reference-docs
git clone https://github.com/aimeeu/website $GOPATH/src/github.com/aimeeu/website
git clone https://github.com/kubernetes/kubernetes $GOPATH/src/k8s.io/kubernetes
```

## Update kubernetes-sigs/reference-docs makefile

