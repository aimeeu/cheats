# Generating Reference Pages for Kubernetes Components and Tools

https://kubernetes.io/docs/contribute/generate-ref-docs/kubernetes-components/

The python script appears at first glance to generate all the required reference docs, making the manual process described in the previous 2 pages obsolete. Some website files do need to be updated when generating the docs for a newly created branch.

# Experiment
- Clone 1.15 but copy contents of update-important-docs from master
- Delete reference directory under website/static/docs
- Run update-imported-docs python script, reference.yml configured to pull from 1.16

```shell
mee@aimee-lemur:~/Dev/go/src/github.com/aimeeu$ git clone --single-branch --branch release-1.15 git@github.com:aimeeu/website
Cloning into 'website'...
remote: Enumerating objects: 22, done.
remote: Counting objects: 100% (22/22), done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 101780 (delta 0), reused 22 (delta 0), pack-reused 101758
Receiving objects: 100% (101780/101780), 214.57 MiB | 26.72 MiB/s, done.
Resolving deltas: 100% (65476/65476), done.
```

reference.yml - changed kubernetes-incubator to kubernetes-sigs; changed git checkout release to 1.16
```yaml
repos:
- name: reference-docs
  remote: https://github.com/kubernetes-sigs/reference-docs.git
  # This and the generate-command below needs a change when reference-docs has
  # branches properly defined
  branch: master
  generate-command: |
    cd $GOPATH
    git clone https://github.com/kubernetes/kubernetes.git src/k8s.io/kubernetes
    cd src/k8s.io/kubernetes
    git checkout release-1.16
    make generated_files
    cp -L -R vendor $GOPATH/src
    rm -r vendor
    cd $GOPATH
    go get -v github.com/kubernetes-sigs/reference-docs/gen-compdocs
    cd src/github.com/kubernetes-sigs/reference-docs/
    make comp
```

```shell
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website/update-imported-docs$ ./update-imported-docs reference.yml
bash: ./update-imported-docs: No such file or directory
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website/update-imported-docs$ ./update-imported-docs.py reference.yml
  File "./update-imported-docs.py", line 130
    os.mkdir(workDir, 0750)
                         ^
SyntaxError: invalid token
```

Fix udate-imported-docs.py, line 130
``` os.mkdir(workDir, 0o750)```

Run python script
```shell
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website/update-imported-docs$ ./update-imported-docs.py reference.yml
./update-imported-docs.py:122: YAMLLoadWarning: calling yaml.load() without Loader=... is deprecated, as the default Loader is unsafe. Please read https://msg.pyyaml.org/load for full details.
  configData = yaml.load(open(configFile, 'r'))
Cloning repo reference-docs...
Cloning into 'src/github.com/kubernetes-sigs/reference-docs'...
remote: Enumerating objects: 139, done.
remote: Counting objects: 100% (139/139), done.
remote: Compressing objects: 100% (121/121), done.
remote: Total 139 (delta 26), reused 75 (delta 9), pack-reused 0
Receiving objects: 100% (139/139), 1.01 MiB | 4.13 MiB/s, done.
Resolving deltas: 100% (26/26), done.
Generating docs for reference-docs with export GOPATH=/tmp/update_docs
cd $GOPATH
git clone https://github.com/kubernetes/kubernetes.git src/k8s.io/kubernetes
cd src/k8s.io/kubernetes
git checkout release-1.16
make generated_files
cp -L -R vendor $GOPATH/src
rm -r vendor
cd $GOPATH
go get -v github.com/kubernetes-sigs/reference-docs/gen-compdocs
cd src/github.com/kubernetes-sigs/reference-docs/
make comp

Cloning into 'src/k8s.io/kubernetes'...
remote: Enumerating objects: 252, done.
remote: Counting objects: 100% (252/252), done.
remote: Compressing objects: 100% (129/129), done.
remote: Total 1011480 (delta 140), reused 123 (delta 123), pack-reused 1011228
Receiving objects: 100% (1011480/1011480), 670.97 MiB | 27.69 MiB/s, done.
Resolving deltas: 100% (711141/711141), done.
Checking out files: 100% (21044/21044), done.
Branch 'release-1.16' set up to track remote branch 'release-1.16' from 'origin'.
Switched to a new branch 'release-1.16'
go: downloading github.com/spf13/pflag v1.0.3
go: extracting github.com/spf13/pflag v1.0.3
go: finding github.com/spf13/pflag v1.0.3
go/build: importGo k8s.io/kubernetes: exit status 1
can't load package: package k8s.io/kubernetes: cannot find module providing package k8s.io/kubernetes


+++ [1002 12:28:53] Building go targets for linux/amd64:
    ./vendor/k8s.io/code-generator/cmd/deepcopy-gen
go: finding k8s.io/kubernetes/vendor latest
go: finding k8s.io/kubernetes/vendor/k8s.io/code-generator/cmd latest
go: finding k8s.io/kubernetes/vendor/k8s.io/code-generator latest
go: finding k8s.io/kubernetes/vendor/k8s.io/code-generator/cmd/deepcopy-gen latest
go: finding k8s.io/kubernetes/vendor/k8s.io latest
can't load package: package k8s.io/kubernetes/vendor/k8s.io/code-generator/cmd/deepcopy-gen: no matching versions for query "latest"
!!! [1002 12:29:11] Call tree:
!!! [1002 12:29:11]  1: /tmp/update_docs/src/k8s.io/kubernetes/hack/lib/golang.sh:714 kube::golang::build_some_binaries(...)
!!! [1002 12:29:11]  2: /tmp/update_docs/src/k8s.io/kubernetes/hack/lib/golang.sh:853 kube::golang::build_binaries_for_platform(...)
!!! [1002 12:29:11]  3: hack/make-rules/build.sh:27 kube::golang::build_binaries(...)
!!! [1002 12:29:11] Call tree:
!!! [1002 12:29:11]  1: hack/make-rules/build.sh:27 kube::golang::build_binaries(...)
!!! [1002 12:29:11] Call tree:
!!! [1002 12:29:11]  1: hack/make-rules/build.sh:27 kube::golang::build_binaries(...)
Makefile.generated_files:200: recipe for target '_output/bin/deepcopy-gen' failed
make[1]: *** [_output/bin/deepcopy-gen] Error 1
Makefile:559: recipe for target 'generated_files' failed
make: *** [generated_files] Error 2
src/vendor/k8s.io/apiserver/pkg/storage/value/encrypt/envelope/envelope.go:31:2: use of vendored package not allowed
src/vendor/github.com/google/certificate-transparency-go/x509/x509.go:68:2: use of vendored package not allowed
src/vendor/golang.org/x/crypto/ssh/kex.go:17:2: use of vendored package not allowed
src/vendor/golang.org/x/crypto/ssh/cipher.go:21:2: use of internal package vendor/golang.org/x/crypto/internal/chacha20 not allowed
src/vendor/golang.org/x/crypto/nacl/secretbox/secretbox.go:38:2: use of internal package vendor/golang.org/x/crypto/internal/subtle not allowed
src/vendor/golang.org/x/crypto/ssh/cipher.go:22:2: use of vendored package not allowed
src/vendor/golang.org/x/net/http2/frame.go:17:2: use of vendored package not allowed
src/vendor/golang.org/x/net/http2/frame.go:18:2: use of vendored package not allowed
src/vendor/golang.org/x/net/http2/transport.go:35:2: use of vendored package not allowed
src/vendor/k8s.io/cli-runtime/pkg/resource/visitor.go:31:2: use of vendored package not allowed
src/vendor/github.com/spf13/afero/util.go:29:2: use of vendored package not allowed
rm -rf /tmp/update_docs/src/github.com/kubernetes-sigs/reference-docs/gen-compdocs/build
mkdir -p gen-compdocs/build
go run gen-compdocs/main.go gen-compdocs/build kube-apiserver
../../../vendor/k8s.io/apiserver/pkg/storage/value/encrypt/envelope/envelope.go:31:2: use of vendored package not allowed
../../../vendor/github.com/google/certificate-transparency-go/x509/x509.go:68:2: use of vendored package not allowed
../../../vendor/golang.org/x/crypto/ssh/kex.go:17:2: use of vendored package not allowed
../../../vendor/golang.org/x/crypto/ssh/cipher.go:21:2: use of internal package vendor/golang.org/x/crypto/internal/chacha20 not allowed
../../../vendor/golang.org/x/crypto/nacl/secretbox/secretbox.go:38:2: use of internal package vendor/golang.org/x/crypto/internal/subtle not allowed
../../../vendor/golang.org/x/crypto/ssh/cipher.go:22:2: use of vendored package not allowed
../../../vendor/golang.org/x/net/http2/frame.go:17:2: use of vendored package not allowed
../../../vendor/golang.org/x/net/http2/frame.go:18:2: use of vendored package not allowed
../../../vendor/golang.org/x/net/http2/transport.go:35:2: use of vendored package not allowed
../../../vendor/k8s.io/cli-runtime/pkg/resource/visitor.go:31:2: use of vendored package not allowed
../../../vendor/github.com/spf13/afero/util.go:29:2: use of vendored package not allowed
Makefile:46: recipe for target 'comp' failed
make: *** [comp] Error 1
[Error] failed in generating docs for 'reference-docs'
Completed docs update. Now run the following command to commit:

 git add .
 git commit -m <comment>
 git push
```
