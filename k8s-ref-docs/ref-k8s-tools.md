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

## Second attempt
- Cloned website master
- Add file extension to update-imported-docs; fixed line 130 for python3

```shell
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website/update-imported-docs$ ./update-imported-docs.py reference.yml
./update-imported-docs.py:128: YAMLLoadWarning: calling yaml.load() without Loader=... is deprecated, as the default Loader is unsafe. Please read https://msg.pyyaml.org/load for full details.
  configData = yaml.load(open(configFile, 'r'))
Traceback (most recent call last):
  File "./update-imported-docs.py", line 187, in <module>
    sys.exit(main())
  File "./update-imported-docs.py", line 136, in main
    os.mkdir(workDir, 0o750)
FileExistsError: [Errno 17] File exists: '/tmp/update_docs'
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website/update-imported-docs$ sudo rm -rf /tmp/update_docs
[sudo] password for aimee: 
aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website/update-imported-docs$ ./update-imported-docs.py reference.yml
./update-imported-docs.py:129: YAMLLoadWarning: calling yaml.load() without Loader=... is deprecated, as the default Loader is unsafe. Please read https://msg.pyyaml.org/load for full details.
  configData = yaml.load(open(configFile, 'r'))
Cloning repo reference-docs...
Cloning into 'src/github.com/kubernetes-sigs/reference-docs'...
remote: Enumerating objects: 139, done.
remote: Counting objects: 100% (139/139), done.
remote: Compressing objects: 100% (121/121), done.
remote: Total 139 (delta 26), reused 75 (delta 9), pack-reused 0
Receiving objects: 100% (139/139), 1.01 MiB | 3.78 MiB/s, done.
Resolving deltas: 100% (26/26), done.
Generating docs for reference-docs with export GOPATH=/tmp/update_docs
cd $GOPATH
git clone https://github.com/kubernetes/kubernetes.git src/k8s.io/kubernetes
cd src/k8s.io/kubernetes
git checkout master
make generated_files
cp -L -R vendor $GOPATH/src
rm -r vendor
cd $GOPATH
go get -v github.com/kubernetes-sigs/reference-docs/gen-compdocs
cd src/github.com/kubernetes-sigs/reference-docs/
make comp

Cloning into 'src/k8s.io/kubernetes'...
remote: Enumerating objects: 249, done.
remote: Counting objects: 100% (249/249), done.
remote: Compressing objects: 100% (126/126), done.
remote: Total 1011480 (delta 140), reused 123 (delta 123), pack-reused 1011231
Receiving objects: 100% (1011480/1011480), 671.26 MiB | 22.71 MiB/s, done.
Resolving deltas: 100% (711112/711112), done.
Checking out files: 100% (21044/21044), done.
Already on 'master'
Your branch is up to date with 'origin/master'.
go: downloading github.com/spf13/pflag v1.0.3
go: extracting github.com/spf13/pflag v1.0.3
go: finding github.com/spf13/pflag v1.0.3
go/build: importGo k8s.io/kubernetes: exit status 1
can't load package: package k8s.io/kubernetes: cannot find module providing package k8s.io/kubernetes


+++ [1002 13:10:46] Building go targets for linux/amd64:
    ./vendor/k8s.io/code-generator/cmd/deepcopy-gen
go: finding k8s.io/kubernetes/vendor latest
go: finding k8s.io/kubernetes/vendor/k8s.io latest
go: finding k8s.io/kubernetes/vendor/k8s.io/code-generator/cmd/deepcopy-gen latest
go: finding k8s.io/kubernetes/vendor/k8s.io/code-generator latest
go: finding k8s.io/kubernetes/vendor/k8s.io/code-generator/cmd latest
can't load package: package k8s.io/kubernetes/vendor/k8s.io/code-generator/cmd/deepcopy-gen: no matching versions for query "latest"
!!! [1002 13:11:23] Call tree:
!!! [1002 13:11:23]  1: /tmp/update_docs/src/k8s.io/kubernetes/hack/lib/golang.sh:714 kube::golang::build_some_binaries(...)
!!! [1002 13:11:23]  2: /tmp/update_docs/src/k8s.io/kubernetes/hack/lib/golang.sh:853 kube::golang::build_binaries_for_platform(...)
!!! [1002 13:11:23]  3: hack/make-rules/build.sh:27 kube::golang::build_binaries(...)
!!! [1002 13:11:23] Call tree:
!!! [1002 13:11:23]  1: hack/make-rules/build.sh:27 kube::golang::build_binaries(...)
!!! [1002 13:11:23] Call tree:
!!! [1002 13:11:23]  1: hack/make-rules/build.sh:27 kube::golang::build_binaries(...)
Makefile.generated_files:200: recipe for target '_output/bin/deepcopy-gen' failed
make[1]: *** [_output/bin/deepcopy-gen] Error 1
Makefile:561: recipe for target 'generated_files' failed
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

aimee@aimee-lemur:~/Dev/go/src/github.com/aimeeu/website/update-imported-docs$ pip show pyyaml
Name: PyYAML
Version: 5.1
Summary: YAML parser and emitter for Python
Home-page: https://github.com/yaml/pyyaml
Author: Kirill Simonov
Author-email: xi@resolvent.net
License: MIT
Location: /home/aimee/anaconda3/lib/python3.6/site-packages
Requires: 
Required-by: bokeh, anaconda-client
```

# Python 2.7, Go 1.12, PyYAML 3.13
Create Python virtual environment with 2.7.16, install PyYAML 3.13
Unset GOPATH in .bashrc

```bash
aimee@aimee-lemur:~/Dev/git/github.com/k8s-website-master$ conda activate k8sUpdateImportedDocsPy27
(k8sUpdateImportedDocsPy27) aimee@aimee-lemur:~/Dev/git/github.com/k8s-website-master$ conda install pyyaml=3.13
(k8sUpdateImportedDocsPy27) aimee@aimee-lemur:~/Dev/git/github.com/k8s-website-master$ git clone https://github.com/kubernetes/website.git
(k8sUpdateImportedDocsPy27) aimee@aimee-lemur:~/Dev/git/github.com/k8s-website-master$ cd website
(k8sUpdateImportedDocsPy27) aimee@aimee-lemur:~/Dev/git/github.com/k8s-website-master/website$ python --version
Python 2.7.16 :: Anaconda, Inc.
(k8sUpdateImportedDocsPy27) aimee@aimee-lemur:~/Dev/git/github.com/k8s-website-master/website$ go version
go version go1.12.10 linux/amd64
(k8sUpdateImportedDocsPy27) aimee@aimee-lemur:~/Dev/git/github.com/k8s-website-master/website$ echo $GOPATH

(k8sUpdateImportedDocsPy27) aimee@aimee-lemur:~/Dev/git/github.com/k8s-website-master/website/update-imported-docs$ cat reference.yml
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

  files:
  - src: gen-compdocs/build/cloud-controller-manager.md
    dst: content/en/docs/reference/command-line-tools-reference/
  - src: gen-compdocs/build/kube-apiserver.md
    dst: content/en/docs/reference/command-line-tools-reference/
  - src: gen-compdocs/build/kube-controller-manager.md
    dst: content/en/docs/reference/command-line-tools-reference/
  # We have problems generating docs for kubelet, it is done manually now
  # - src: gen-compdocs/build/kubelet.md
  # dst: content/en/docs/reference/command-line-tools-reference/
  - src: gen-compdocs/build/kube-proxy.md
    dst: content/en/docs/reference/command-line-tools-reference/
  - src: gen-compdocs/build/kube-scheduler.md
    dst: content/en/docs/reference/command-line-tools-reference/
  - src: gen-compdocs/build/kubectl.md
    dst: content/en/docs/reference/kubectl/
  - src: gen-compdocs/build/kubeadm*.md
    dst: content/en/docs/reference/setup-tools/kubeadm/generated/

#- name: federation
#  remote: https://github.com/kubernetes/federation.git
  # Change this to a release branch when federation has release branches.
#  branch: master
#  generate-command: hack/generate-docs.sh
#  files:
#  - src: docs/admin/federation-apiserver.md
#    dst: content/en/docs/reference/command-line-tools-reference/federation-apiserver.md
#  - src: docs/admin/federation-controller-manager.md
#    dst: content/en/docs/reference/command-line-tools-reference/federation-controller-manager.md
#  - src: docs/admin/kubefed_init.md
#    dst: content/en/docs/reference/setup-tools/kubefed/kubefed_init.md
#  - src: docs/admin/kubefed_join.md
#    dst: content/en/docs/reference/setup-tools/kubefed/kubefed_join.md
#  - src: docs/admin/kubefed.md
#    dst: content/en/docs/reference/setup-tools/kubefed/kubefed.md
#  - src: docs/admin/kubefed_options.md
#    dst: content/en/docs/reference/setup-tools/kubefed/kubefed_options.md
#  - src: docs/admin/kubefed_unjoin.md
#    dst: content/en/docs/reference/setup-tools/kubefed/kubefed_unjoin.md
#  - src: docs/admin/kubefed_version.md
#    dst: content/en/docs/reference/setup-tools/kubefed/kubefed_version.md

(k8sUpdateImportedDocsPy27) aimee@aimee-lemur:~/Dev/git/github.com/k8s-website-master/website/update-imported-docs$ ./update-imported-docs reference.yml
Cloning repo reference-docs...
Cloning into 'src/github.com/kubernetes-sigs/reference-docs'...
remote: Enumerating objects: 139, done.
remote: Counting objects: 100% (139/139), done.
remote: Compressing objects: 100% (121/121), done.
remote: Total 139 (delta 26), reused 75 (delta 9), pack-reused 0
Receiving objects: 100% (139/139), 1.01 MiB | 3.96 MiB/s, done.
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
remote: Enumerating objects: 248, done.
remote: Counting objects: 100% (248/248), done.
remote: Compressing objects: 100% (128/128), done.
remote: Total 1015133 (delta 137), reused 120 (delta 120), pack-reused 1014885
Receiving objects: 100% (1015133/1015133), 672.23 MiB | 27.77 MiB/s, done.
Resolving deltas: 100% (714071/714071), done.
Checking out files: 100% (21095/21095), done.
Branch 'release-1.16' set up to track remote branch 'release-1.16' from 'origin'.
Switched to a new branch 'release-1.16'
+++ [1009 13:50:56] Building go targets for linux/amd64:
    ./vendor/k8s.io/code-generator/cmd/deepcopy-gen
+++ [1009 13:51:03] Building go targets for linux/amd64:
    ./vendor/k8s.io/code-generator/cmd/defaulter-gen
+++ [1009 13:51:08] Building go targets for linux/amd64:
    ./vendor/k8s.io/code-generator/cmd/conversion-gen
+++ [1009 13:51:17] Building go targets for linux/amd64:
    ./vendor/k8s.io/kube-openapi/cmd/openapi-gen
+++ [1009 13:51:27] Building go targets for linux/amd64:
    ./vendor/github.com/go-bindata/go-bindata/go-bindata
vendor/k8s.io/apimachinery/pkg/selection
vendor/k8s.io/apiserver/pkg/authentication/user
vendor/k8s.io/apimachinery/pkg/util/sets
vendor/github.com/spf13/pflag
vendor/github.com/google/uuid
vendor/k8s.io/apimachinery/pkg/types
vendor/k8s.io/klog
vendor/github.com/coreos/go-systemd/daemon
vendor/k8s.io/apimachinery/pkg/util/uuid
vendor/k8s.io/apimachinery/pkg/util/runtime
vendor/github.com/emicklei/go-restful/log
vendor/github.com/evanphx/json-patch
vendor/k8s.io/apimachinery/pkg/util/wait
vendor/github.com/emicklei/go-restful
vendor/github.com/mailru/easyjson/jlexer
vendor/github.com/mailru/easyjson/buffer
vendor/github.com/mailru/easyjson/jwriter
vendor/gopkg.in/yaml.v2
vendor/github.com/PuerkitoBio/urlesc
vendor/golang.org/x/text/transform
vendor/github.com/spf13/cobra
vendor/golang.org/x/text/unicode/bidi
vendor/golang.org/x/text/unicode/norm
vendor/golang.org/x/text/secure/bidirule
vendor/golang.org/x/text/width
vendor/github.com/pborman/uuid
vendor/golang.org/x/net/http2/hpack
vendor/github.com/gogo/protobuf/proto
vendor/github.com/gogo/protobuf/sortkeys
vendor/github.com/google/gofuzz
vendor/gopkg.in/inf.v0
vendor/golang.org/x/net/idna
vendor/github.com/go-openapi/swag
vendor/k8s.io/apimachinery/third_party/forked/golang/reflect
vendor/github.com/PuerkitoBio/purell
vendor/golang.org/x/net/http/httpguts
vendor/github.com/go-openapi/jsonpointer
vendor/golang.org/x/net/http2
vendor/k8s.io/apimachinery/pkg/conversion
vendor/github.com/go-openapi/jsonreference
vendor/github.com/go-openapi/spec
vendor/k8s.io/apimachinery/pkg/fields
vendor/k8s.io/apimachinery/pkg/util/errors
vendor/k8s.io/apimachinery/pkg/util/validation/field
vendor/k8s.io/apimachinery/pkg/util/validation
vendor/k8s.io/apimachinery/pkg/labels
vendor/k8s.io/apimachinery/pkg/conversion/queryparams
vendor/k8s.io/apimachinery/pkg/util/json
vendor/k8s.io/apimachinery/pkg/util/naming
vendor/github.com/modern-go/concurrent
vendor/k8s.io/apimachinery/pkg/util/framer
vendor/github.com/modern-go/reflect2
vendor/sigs.k8s.io/yaml
vendor/k8s.io/apimachinery/pkg/util/net
vendor/k8s.io/apimachinery/pkg/util/yaml
vendor/k8s.io/apimachinery/pkg/util/clock
vendor/k8s.io/apimachinery/pkg/util/waitgroup
vendor/k8s.io/apimachinery/pkg/version
vendor/k8s.io/apiserver/pkg/authorization/authorizer
vendor/github.com/blang/semver
vendor/github.com/beorn7/perks/quantile
vendor/k8s.io/apimachinery/pkg/api/resource
vendor/k8s.io/apimachinery/pkg/runtime/schema
vendor/k8s.io/apimachinery/pkg/util/intstr
vendor/k8s.io/apimachinery/pkg/runtime
vendor/github.com/golang/protobuf/proto
vendor/github.com/prometheus/common/internal/bitbucket.org/ww/goautoneg
vendor/github.com/json-iterator/go
vendor/github.com/prometheus/common/model
vendor/github.com/prometheus/procfs/internal/util
vendor/github.com/prometheus/procfs/nfs
vendor/github.com/prometheus/procfs/xfs
vendor/github.com/prometheus/procfs
vendor/k8s.io/apimachinery/pkg/watch
vendor/k8s.io/apimachinery/pkg/apis/meta/v1
vendor/k8s.io/apimachinery/pkg/runtime/serializer/recognizer
vendor/k8s.io/component-base/version
vendor/github.com/hashicorp/golang-lru/simplelru
vendor/github.com/hashicorp/golang-lru
vendor/k8s.io/apimachinery/pkg/util/cache
vendor/k8s.io/apimachinery/pkg/runtime/serializer/json
vendor/k8s.io/apimachinery/pkg/runtime/serializer/streaming
vendor/k8s.io/client-go/pkg/version
vendor/github.com/davecgh/go-spew/spew
vendor/golang.org/x/sys/unix
vendor/github.com/prometheus/client_model/go
vendor/github.com/prometheus/client_golang/prometheus/internal
vendor/github.com/matttproud/golang_protobuf_extensions/pbutil
vendor/github.com/golang/protobuf/ptypes/any
vendor/github.com/prometheus/common/expfmt
vendor/github.com/golang/protobuf/ptypes/duration
vendor/github.com/golang/protobuf/ptypes/timestamp
vendor/github.com/golang/protobuf/ptypes
vendor/github.com/googleapis/gnostic/extensions
vendor/github.com/googleapis/gnostic/compiler
vendor/github.com/prometheus/client_golang/prometheus
vendor/golang.org/x/crypto/ssh/terminal
vendor/github.com/googleapis/gnostic/OpenAPIv2
vendor/k8s.io/client-go/tools/clientcmd/api
vendor/golang.org/x/net/context/ctxhttp
vendor/k8s.io/apimachinery/pkg/api/errors
vendor/k8s.io/apimachinery/pkg/api/meta
vendor/k8s.io/apimachinery/pkg/runtime/serializer/protobuf
vendor/k8s.io/apimachinery/pkg/apis/meta/v1/unstructured
vendor/k8s.io/apiserver/pkg/apis/apiserver
vendor/k8s.io/apiserver/pkg/apis/apiserver/v1alpha1
vendor/k8s.io/apimachinery/pkg/runtime/serializer/versioning
vendor/k8s.io/apiserver/pkg/apis/audit
vendor/k8s.io/apimachinery/pkg/runtime/serializer
vendor/k8s.io/api/authentication/v1
vendor/k8s.io/component-base/metrics
vendor/github.com/prometheus/client_golang/prometheus/promhttp
vendor/k8s.io/api/core/v1
vendor/k8s.io/apiserver/pkg/apis/audit/v1
vendor/k8s.io/apiserver/pkg/apis/audit/v1alpha1
vendor/k8s.io/apiserver/pkg/apis/audit/v1beta1
vendor/k8s.io/component-base/metrics/legacyregistry
vendor/k8s.io/api/admissionregistration/v1
vendor/k8s.io/api/admissionregistration/v1beta1
vendor/k8s.io/apiserver/pkg/audit
vendor/k8s.io/api/auditregistration/v1alpha1
vendor/k8s.io/api/certificates/v1beta1
vendor/k8s.io/apiserver/pkg/admission
vendor/k8s.io/api/coordination/v1
vendor/k8s.io/api/coordination/v1beta1
vendor/k8s.io/api/rbac/v1
vendor/k8s.io/api/rbac/v1alpha1
vendor/k8s.io/api/rbac/v1beta1
vendor/k8s.io/api/authentication/v1beta1
vendor/k8s.io/api/authorization/v1
vendor/k8s.io/api/authorization/v1beta1
vendor/k8s.io/client-go/pkg/apis/clientauthentication
vendor/k8s.io/client-go/pkg/apis/clientauthentication/v1alpha1
vendor/k8s.io/client-go/pkg/apis/clientauthentication/v1beta1
vendor/golang.org/x/oauth2/internal
vendor/k8s.io/client-go/util/connrotation
vendor/golang.org/x/oauth2
vendor/k8s.io/client-go/rest/watch
vendor/k8s.io/client-go/tools/metrics
vendor/k8s.io/client-go/util/keyutil
vendor/golang.org/x/net/context
vendor/k8s.io/client-go/transport
vendor/golang.org/x/time/rate
vendor/k8s.io/client-go/util/cert
vendor/k8s.io/utils/integer
vendor/k8s.io/client-go/util/flowcontrol
vendor/github.com/google/go-cmp/cmp/internal/diff
vendor/github.com/google/go-cmp/cmp/internal/flags
vendor/github.com/google/go-cmp/cmp/internal/function
vendor/k8s.io/client-go/plugin/pkg/client/auth/exec
vendor/github.com/google/go-cmp/cmp/internal/value
vendor/k8s.io/apimachinery/pkg/apis/meta/v1beta1
vendor/github.com/google/go-cmp/cmp
vendor/k8s.io/client-go/rest
vendor/k8s.io/apimachinery/pkg/apis/meta/internalversion
vendor/k8s.io/client-go/tools/pager
vendor/k8s.io/client-go/util/retry
vendor/k8s.io/utils/buffer
vendor/k8s.io/utils/trace
vendor/k8s.io/api/admission/v1
vendor/k8s.io/apimachinery/pkg/api/equality
vendor/k8s.io/apimachinery/pkg/util/diff
vendor/github.com/imdario/mergo
vendor/k8s.io/client-go/tools/cache
vendor/k8s.io/client-go/tools/auth
vendor/k8s.io/client-go/tools/clientcmd/api/v1
vendor/k8s.io/client-go/util/homedir
vendor/k8s.io/api/admission/v1beta1
vendor/k8s.io/client-go/tools/clientcmd/api/latest
vendor/k8s.io/client-go/tools/clientcmd
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/config/apis/webhookadmission
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/config/apis/webhookadmission/v1alpha1
vendor/k8s.io/client-go/listers/admissionregistration/v1
vendor/k8s.io/client-go/listers/admissionregistration/v1beta1
vendor/k8s.io/client-go/listers/auditregistration/v1alpha1
vendor/k8s.io/client-go/listers/certificates/v1beta1
vendor/k8s.io/client-go/listers/coordination/v1
vendor/k8s.io/client-go/listers/coordination/v1beta1
vendor/k8s.io/client-go/listers/rbac/v1
vendor/k8s.io/client-go/listers/rbac/v1alpha1
vendor/k8s.io/client-go/listers/rbac/v1beta1
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/config
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/rules
vendor/k8s.io/apiserver/pkg/admission/metrics
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/errors
vendor/k8s.io/apiserver/pkg/apis/apiserver/install
vendor/k8s.io/apimachinery/pkg/apis/meta/v1/validation
vendor/k8s.io/apiserver/pkg/authentication/authenticator
vendor/golang.org/x/net/websocket
vendor/k8s.io/apiserver/pkg/authentication/group
vendor/k8s.io/apimachinery/pkg/api/validation
vendor/k8s.io/apiserver/pkg/authentication/request/anonymous
vendor/k8s.io/apiserver/pkg/authentication/request/bearertoken
vendor/k8s.io/apiserver/pkg/authentication/request/x509
vendor/k8s.io/apiserver/pkg/apis/audit/validation
vendor/k8s.io/apiserver/pkg/authentication/request/union
vendor/k8s.io/apiserver/pkg/authentication/request/headerrequest
vendor/k8s.io/apiserver/pkg/util/wsstream
vendor/k8s.io/apiserver/pkg/audit/policy
vendor/k8s.io/apiserver/pkg/authentication/token/cache
vendor/k8s.io/apiserver/pkg/authentication/request/websocket
vendor/k8s.io/apiserver/pkg/authentication/token/tokenfile
vendor/k8s.io/apiserver/pkg/authorization/union
vendor/github.com/munnerz/goautoneg
vendor/k8s.io/apimachinery/pkg/api/validation/path
vendor/k8s.io/component-base/featuregate
vendor/k8s.io/apiserver/pkg/endpoints/handlers/negotiation
vendor/k8s.io/apiserver/pkg/endpoints/request
vendor/k8s.io/apiserver/pkg/util/feature
vendor/k8s.io/apimachinery/pkg/util/rand
vendor/k8s.io/apiserver/pkg/storage
vendor/k8s.io/apiserver/pkg/features
vendor/k8s.io/apiserver/pkg/storage/names
vendor/k8s.io/apiserver/pkg/util/flushwriter
vendor/k8s.io/apiserver/pkg/endpoints/metrics
vendor/k8s.io/apiserver/pkg/registry/rest
vendor/k8s.io/apimachinery/pkg/apis/meta/v1beta1/validation
vendor/k8s.io/apimachinery/pkg/util/mergepatch
vendor/k8s.io/apimachinery/third_party/forked/golang/json
vendor/k8s.io/kube-openapi/pkg/util/proto
vendor/sigs.k8s.io/structured-merge-diff/schema
vendor/k8s.io/apiserver/pkg/endpoints/handlers/responsewriters
vendor/k8s.io/apimachinery/pkg/util/strategicpatch
vendor/k8s.io/kube-openapi/pkg/schemaconv
vendor/sigs.k8s.io/structured-merge-diff/value
vendor/k8s.io/apiserver/pkg/endpoints/discovery
vendor/k8s.io/apiserver/pkg/server/httplog
vendor/sigs.k8s.io/structured-merge-diff/fieldpath
vendor/k8s.io/apiserver/pkg/util/dryrun
vendor/k8s.io/apiserver/pkg/authentication/serviceaccount
vendor/k8s.io/kube-openapi/pkg/util
vendor/k8s.io/utils/path
vendor/k8s.io/apiserver/pkg/endpoints/openapi
vendor/k8s.io/apiserver/pkg/server/egressselector
vendor/sigs.k8s.io/structured-merge-diff/typed
vendor/google.golang.org/genproto/googleapis/rpc/status
vendor/google.golang.org/grpc/codes
vendor/google.golang.org/grpc/grpclog
vendor/github.com/gogo/protobuf/protoc-gen-gogo/descriptor
vendor/google.golang.org/grpc/connectivity
vendor/google.golang.org/grpc/internal
vendor/google.golang.org/grpc/status
vendor/sigs.k8s.io/structured-merge-diff/merge
vendor/k8s.io/apiserver/pkg/storage/value
vendor/k8s.io/apiserver/pkg/endpoints/handlers/fieldmanager/internal
vendor/k8s.io/apiserver/pkg/storage/storagebackend
vendor/k8s.io/api/apps/v1
vendor/k8s.io/api/apps/v1beta1
vendor/k8s.io/api/apps/v1beta2
vendor/k8s.io/api/autoscaling/v1
vendor/k8s.io/api/autoscaling/v2beta1
vendor/k8s.io/api/autoscaling/v2beta2
vendor/k8s.io/api/batch/v1
vendor/k8s.io/api/discovery/v1alpha1
vendor/k8s.io/api/batch/v1beta1
vendor/k8s.io/api/batch/v2alpha1
vendor/k8s.io/api/events/v1beta1
vendor/k8s.io/api/extensions/v1beta1
vendor/k8s.io/api/networking/v1
vendor/k8s.io/api/networking/v1beta1
vendor/k8s.io/api/node/v1alpha1
vendor/k8s.io/api/node/v1beta1
vendor/k8s.io/api/policy/v1beta1
vendor/k8s.io/api/scheduling/v1
vendor/k8s.io/api/scheduling/v1alpha1
vendor/k8s.io/api/scheduling/v1beta1
vendor/k8s.io/api/settings/v1alpha1
vendor/k8s.io/api/storage/v1
vendor/k8s.io/api/storage/v1alpha1
vendor/k8s.io/api/storage/v1beta1
vendor/k8s.io/client-go/tools/reference
vendor/k8s.io/client-go/listers/apps/v1
vendor/k8s.io/client-go/listers/apps/v1beta1
vendor/k8s.io/client-go/listers/apps/v1beta2
vendor/k8s.io/client-go/listers/autoscaling/v1
vendor/k8s.io/client-go/listers/autoscaling/v2beta1
vendor/k8s.io/client-go/listers/autoscaling/v2beta2
vendor/k8s.io/client-go/kubernetes/scheme
vendor/k8s.io/client-go/discovery
vendor/k8s.io/client-go/kubernetes/typed/admissionregistration/v1
vendor/k8s.io/client-go/kubernetes/typed/admissionregistration/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/apps/v1
vendor/k8s.io/client-go/kubernetes/typed/apps/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/apps/v1beta2
vendor/k8s.io/client-go/kubernetes/typed/auditregistration/v1alpha1
vendor/k8s.io/client-go/kubernetes/typed/authentication/v1
vendor/k8s.io/client-go/kubernetes/typed/authentication/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/authorization/v1
vendor/k8s.io/client-go/kubernetes/typed/authorization/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/autoscaling/v1
vendor/k8s.io/client-go/kubernetes/typed/autoscaling/v2beta1
vendor/k8s.io/client-go/kubernetes/typed/autoscaling/v2beta2
vendor/k8s.io/client-go/kubernetes/typed/batch/v1
vendor/k8s.io/client-go/kubernetes/typed/batch/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/batch/v2alpha1
vendor/k8s.io/client-go/kubernetes/typed/certificates/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/coordination/v1
vendor/k8s.io/client-go/kubernetes/typed/coordination/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/core/v1
vendor/k8s.io/client-go/kubernetes/typed/discovery/v1alpha1
vendor/k8s.io/client-go/kubernetes/typed/events/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/extensions/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/networking/v1
vendor/k8s.io/client-go/kubernetes/typed/networking/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/node/v1alpha1
vendor/k8s.io/client-go/kubernetes/typed/node/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/policy/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/rbac/v1
vendor/k8s.io/client-go/kubernetes/typed/rbac/v1alpha1
vendor/k8s.io/client-go/kubernetes/typed/rbac/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/scheduling/v1
vendor/k8s.io/client-go/kubernetes/typed/scheduling/v1alpha1
vendor/k8s.io/client-go/kubernetes/typed/scheduling/v1beta1
vendor/k8s.io/client-go/kubernetes/typed/settings/v1alpha1
vendor/k8s.io/client-go/kubernetes/typed/storage/v1
vendor/k8s.io/client-go/kubernetes/typed/storage/v1alpha1
vendor/k8s.io/client-go/kubernetes/typed/storage/v1beta1
vendor/k8s.io/client-go/listers/batch/v1
vendor/k8s.io/client-go/listers/batch/v1beta1
vendor/k8s.io/client-go/listers/batch/v2alpha1
vendor/k8s.io/client-go/kubernetes
vendor/k8s.io/client-go/listers/core/v1
vendor/k8s.io/client-go/listers/discovery/v1alpha1
vendor/k8s.io/client-go/listers/events/v1beta1
vendor/k8s.io/client-go/listers/extensions/v1beta1
vendor/k8s.io/client-go/listers/networking/v1
vendor/k8s.io/client-go/listers/networking/v1beta1
vendor/k8s.io/client-go/listers/node/v1alpha1
vendor/k8s.io/client-go/listers/node/v1beta1
vendor/k8s.io/client-go/listers/policy/v1beta1
vendor/k8s.io/client-go/listers/scheduling/v1
vendor/k8s.io/client-go/listers/scheduling/v1alpha1
vendor/k8s.io/client-go/listers/scheduling/v1beta1
vendor/k8s.io/client-go/listers/settings/v1alpha1
vendor/k8s.io/client-go/listers/storage/v1
vendor/k8s.io/client-go/listers/storage/v1alpha1
vendor/k8s.io/client-go/listers/storage/v1beta1
vendor/k8s.io/apiserver/pkg/util/webhook
vendor/k8s.io/apiserver/pkg/endpoints/handlers/fieldmanager
vendor/k8s.io/apiserver/pkg/endpoints/filters
vendor/k8s.io/apiserver/pkg/endpoints/handlers
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook
vendor/k8s.io/apiserver/plugin/pkg/authenticator/token/webhook
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/object
vendor/k8s.io/apiserver/pkg/authentication/authenticatorfactory
vendor/k8s.io/apiserver/plugin/pkg/authorizer/webhook
vendor/github.com/gogo/protobuf/gogoproto
vendor/k8s.io/apiserver/pkg/authorization/authorizerfactory
vendor/k8s.io/client-go/informers/internalinterfaces
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/namespace
vendor/github.com/coreos/etcd/auth/authpb
vendor/k8s.io/apiserver/pkg/endpoints
vendor/go.uber.org/atomic
vendor/k8s.io/client-go/informers/admissionregistration/v1
vendor/k8s.io/client-go/informers/admissionregistration/v1beta1
vendor/k8s.io/client-go/informers/apps/v1
vendor/k8s.io/client-go/informers/admissionregistration
vendor/k8s.io/client-go/informers/apps/v1beta1
vendor/k8s.io/client-go/informers/apps/v1beta2
vendor/k8s.io/client-go/informers/auditregistration/v1alpha1
vendor/k8s.io/client-go/informers/auditregistration
vendor/k8s.io/client-go/informers/autoscaling/v1
vendor/k8s.io/client-go/informers/apps
vendor/k8s.io/client-go/informers/autoscaling/v2beta1
vendor/k8s.io/client-go/informers/autoscaling/v2beta2
vendor/k8s.io/client-go/informers/batch/v1
vendor/k8s.io/client-go/informers/batch/v1beta1
vendor/k8s.io/client-go/informers/batch/v2alpha1
vendor/k8s.io/client-go/informers/autoscaling
vendor/k8s.io/client-go/informers/certificates/v1beta1
vendor/k8s.io/client-go/informers/coordination/v1
vendor/k8s.io/client-go/informers/coordination/v1beta1
vendor/k8s.io/client-go/informers/batch
vendor/k8s.io/client-go/informers/certificates
vendor/k8s.io/client-go/informers/core/v1
vendor/k8s.io/client-go/informers/coordination
vendor/k8s.io/client-go/informers/discovery/v1alpha1
vendor/k8s.io/client-go/informers/events/v1beta1
vendor/k8s.io/client-go/informers/extensions/v1beta1
vendor/k8s.io/client-go/informers/discovery
vendor/k8s.io/client-go/informers/events
vendor/k8s.io/client-go/informers/core
vendor/k8s.io/client-go/informers/networking/v1
vendor/k8s.io/client-go/informers/networking/v1beta1
vendor/k8s.io/client-go/informers/extensions
vendor/k8s.io/client-go/informers/node/v1alpha1
vendor/k8s.io/client-go/informers/node/v1beta1
vendor/k8s.io/client-go/informers/networking
vendor/k8s.io/client-go/informers/policy/v1beta1
vendor/k8s.io/client-go/informers/rbac/v1
vendor/k8s.io/client-go/informers/rbac/v1alpha1
vendor/k8s.io/client-go/informers/node
vendor/k8s.io/client-go/informers/policy
vendor/k8s.io/client-go/informers/rbac/v1beta1
vendor/k8s.io/client-go/informers/scheduling/v1
vendor/k8s.io/client-go/informers/scheduling/v1alpha1
vendor/k8s.io/client-go/informers/scheduling/v1beta1
vendor/k8s.io/client-go/informers/settings/v1alpha1
vendor/k8s.io/client-go/informers/storage/v1
vendor/k8s.io/client-go/informers/rbac
vendor/k8s.io/client-go/informers/scheduling
vendor/k8s.io/client-go/informers/settings
vendor/k8s.io/client-go/informers/storage/v1alpha1
vendor/k8s.io/client-go/informers/storage/v1beta1
vendor/go.uber.org/multierr
vendor/go.uber.org/zap/buffer
vendor/go.uber.org/zap/internal/bufferpool
vendor/go.uber.org/zap/internal/color
vendor/go.uber.org/zap/internal/exit
vendor/google.golang.org/grpc/credentials/internal
vendor/go.uber.org/zap/zapcore
vendor/google.golang.org/grpc/credentials
vendor/google.golang.org/grpc/metadata
vendor/google.golang.org/grpc/serviceconfig
vendor/google.golang.org/grpc/internal/grpcrand
vendor/google.golang.org/grpc/resolver
vendor/google.golang.org/grpc/internal/backoff
vendor/google.golang.org/grpc/balancer
vendor/google.golang.org/grpc/resolver/dns
vendor/google.golang.org/grpc/resolver/passthrough
vendor/k8s.io/client-go/informers/storage
vendor/github.com/coreos/etcd/clientv3/balancer/resolver/endpoint
vendor/github.com/coreos/etcd/etcdserver/api/v3rpc/rpctypes
vendor/go.uber.org/zap
vendor/github.com/coreos/etcd/mvcc/mvccpb
vendor/github.com/coreos/etcd/clientv3/credentials
vendor/github.com/golang/protobuf/protoc-gen-go/descriptor
vendor/golang.org/x/net/internal/timeseries
vendor/golang.org/x/net/trace
vendor/github.com/coreos/etcd/clientv3/balancer/connectivity
vendor/github.com/coreos/etcd/clientv3/balancer/picker
vendor/k8s.io/client-go/informers
vendor/google.golang.org/genproto/googleapis/api/annotations
vendor/google.golang.org/grpc/balancer/base
vendor/github.com/coreos/etcd/clientv3/balancer
vendor/google.golang.org/grpc/balancer/roundrobin
vendor/google.golang.org/grpc/encoding
vendor/google.golang.org/grpc/internal/balancerload
vendor/google.golang.org/grpc/binarylog/grpc_binarylog_v1
vendor/google.golang.org/grpc/encoding/proto
vendor/google.golang.org/grpc/internal/channelz
vendor/google.golang.org/grpc/internal/envconfig
vendor/google.golang.org/grpc/internal/grpcsync
vendor/google.golang.org/grpc/internal/binarylog
vendor/google.golang.org/grpc/internal/syscall
vendor/google.golang.org/grpc/keepalive
vendor/google.golang.org/grpc/peer
vendor/google.golang.org/grpc/stats
vendor/google.golang.org/grpc/tap
vendor/google.golang.org/grpc/naming
vendor/github.com/coreos/etcd/pkg/systemd
vendor/google.golang.org/grpc/internal/transport
vendor/github.com/coreos/etcd/raft/raftpb
vendor/github.com/coreos/go-systemd/journal
vendor/github.com/coreos/pkg/capnslog
vendor/github.com/coreos/etcd/raft
vendor/github.com/coreos/etcd/pkg/types
vendor/github.com/coreos/etcd/pkg/tlsutil
vendor/github.com/coreos/etcd/pkg/transport
vendor/google.golang.org/grpc
vendor/github.com/coreos/etcd/pkg/logutil
vendor/k8s.io/apiserver/pkg/storage/etcd3/metrics
vendor/k8s.io/apiserver/pkg/server/filters
vendor/k8s.io/apiserver/pkg/server/healthz
vendor/k8s.io/apiserver/pkg/server/mux
vendor/k8s.io/kube-openapi/pkg/common
vendor/k8s.io/kube-openapi/pkg/builder
vendor/github.com/NYTimes/gziphandler
vendor/k8s.io/apiserver/pkg/server/storage
vendor/k8s.io/kube-openapi/pkg/handler
vendor/k8s.io/apiserver/pkg/util/openapi
vendor/k8s.io/apiserver/pkg/server/routes
vendor/k8s.io/component-base/logs
vendor/k8s.io/apiserver/pkg/admission/initializer
vendor/github.com/docker/docker/pkg/term
vendor/k8s.io/client-go/tools/leaderelection/resourcelock
vendor/k8s.io/apiserver/pkg/util/term
vendor/k8s.io/cloud-provider
vendor/github.com/coreos/etcd/etcdserver/etcdserverpb
vendor/k8s.io/apiserver/pkg/admission/plugin/namespace/lifecycle
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/generic
vendor/github.com/grpc-ecosystem/go-grpc-prometheus
vendor/k8s.io/apiserver/pkg/admission/configuration
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/request
vendor/k8s.io/client-go/tools/leaderelection
vendor/k8s.io/component-base/cli/flag
vendor/k8s.io/component-base/cli/globalflag
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/mutating
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/validating
vendor/github.com/golang/groupcache/lru
vendor/k8s.io/client-go/tools/record/util
vendor/k8s.io/client-go/tools/record
vendor/k8s.io/component-base/config
k8s.io/kubernetes/pkg/controller/certificates/signer/config
k8s.io/kubernetes/pkg/controller/daemon/config
k8s.io/kubernetes/pkg/controller/deployment/config
k8s.io/kubernetes/pkg/controller/endpoint/config
k8s.io/kubernetes/pkg/controller/endpointslice/config
k8s.io/kubernetes/pkg/controller/garbagecollector/config
k8s.io/kubernetes/pkg/controller/job/config
k8s.io/kubernetes/pkg/controller/namespace/config
k8s.io/kubernetes/pkg/controller/nodeipam/config
k8s.io/kubernetes/pkg/controller/nodelifecycle/config
k8s.io/kubernetes/pkg/controller/podautoscaler/config
k8s.io/kubernetes/pkg/controller/podgc/config
k8s.io/kubernetes/pkg/controller/replicaset/config
k8s.io/kubernetes/pkg/controller/replication/config
k8s.io/kubernetes/pkg/controller/resourcequota/config
k8s.io/kubernetes/pkg/controller/service/config
k8s.io/kubernetes/pkg/controller/serviceaccount/config
k8s.io/kubernetes/pkg/controller/statefulset/config
k8s.io/kubernetes/pkg/controller/ttlafterfinished/config
k8s.io/kubernetes/pkg/controller/volume/attachdetach/config
k8s.io/kubernetes/pkg/controller/volume/persistentvolume/config
vendor/k8s.io/client-go/metadata
vendor/k8s.io/client-go/metadata/metadatalister
k8s.io/kubernetes/pkg/controller/apis/config
k8s.io/kubernetes/cmd/cloud-controller-manager/app/apis/config
vendor/k8s.io/client-go/tools/watch
vendor/k8s.io/client-go/metadata/metadatainformer
k8s.io/kubernetes/pkg/api/legacyscheme
vendor/k8s.io/apiextensions-apiserver/pkg/features
k8s.io/kubernetes/pkg/apis/core
vendor/github.com/opencontainers/go-digest
k8s.io/kubernetes/pkg/features
k8s.io/kubernetes/pkg/api/v1/pod
vendor/github.com/docker/distribution/digestset
vendor/github.com/coreos/etcd/clientv3
vendor/github.com/docker/distribution/reference
vendor/k8s.io/utils/net
vendor/k8s.io/utils/pointer
k8s.io/kubernetes/pkg/fieldpath
k8s.io/kubernetes/pkg/util/parsers
k8s.io/kubernetes/pkg/capabilities
k8s.io/kubernetes/pkg/master/ports
vendor/golang.org/x/crypto/ed25519/internal/edwards25519
vendor/golang.org/x/crypto/pbkdf2
vendor/gopkg.in/square/go-jose.v2/cipher
vendor/gopkg.in/square/go-jose.v2/json
vendor/golang.org/x/crypto/ed25519
k8s.io/kubernetes/pkg/util/hash
vendor/gopkg.in/natefinch/lumberjack.v2
vendor/k8s.io/apiserver/pkg/authorization/path
vendor/k8s.io/apiserver/pkg/storage/cacher
vendor/k8s.io/apiserver/pkg/storage/etcd3
vendor/gopkg.in/square/go-jose.v2
k8s.io/kubernetes/pkg/apis/autoscaling
k8s.io/kubernetes/pkg/api/service
k8s.io/kubernetes/pkg/apis/core/helper
vendor/k8s.io/apiserver/pkg/storage/storagebackend/factory
vendor/k8s.io/apiserver/pkg/registry/generic
k8s.io/kubernetes/pkg/apis/apps
vendor/k8s.io/apiserver/pkg/server
k8s.io/kubernetes/pkg/apis/core/pods
k8s.io/kubernetes/pkg/apis/core/v1/helper
k8s.io/kubernetes/pkg/apis/scheduling
k8s.io/kubernetes/pkg/apis/core/v1
k8s.io/kubernetes/pkg/kubelet/types
vendor/gopkg.in/square/go-jose.v2/jwt
k8s.io/kubernetes/pkg/serviceaccount
k8s.io/kubernetes/pkg/security/apparmor
k8s.io/kubernetes/pkg/util/taints
vendor/k8s.io/apiserver/pkg/storage/errors
vendor/k8s.io/apiserver/pkg/apis/config
vendor/k8s.io/apiserver/pkg/registry/generic/registry
vendor/k8s.io/apiserver/pkg/apis/config/v1
vendor/k8s.io/apiserver/pkg/storage/value/encrypt/aes
vendor/golang.org/x/crypto/cryptobyte/asn1
vendor/k8s.io/apiserver/pkg/storage/value/encrypt/envelope/v1beta1
vendor/golang.org/x/crypto/cryptobyte
vendor/k8s.io/apiserver/pkg/storage/value/encrypt/identity
vendor/golang.org/x/crypto/internal/subtle
vendor/golang.org/x/crypto/poly1305
vendor/k8s.io/apiserver/pkg/storage/value/encrypt/envelope
vendor/golang.org/x/crypto/salsa20/salsa
vendor/golang.org/x/crypto/nacl/secretbox
vendor/k8s.io/apiserver/pkg/server/resourceconfig
vendor/k8s.io/apiserver/pkg/storage/value/encrypt/secretbox
vendor/k8s.io/apiserver/pkg/server/options/encryptionconfig
vendor/k8s.io/apiserver/plugin/pkg/audit/buffered
vendor/k8s.io/apiserver/pkg/apis/audit/install
vendor/k8s.io/apiserver/pkg/audit/util
vendor/k8s.io/apiserver/pkg/audit/event
vendor/k8s.io/apiserver/plugin/pkg/audit/webhook
vendor/k8s.io/apiserver/plugin/pkg/audit/dynamic/enforced
vendor/k8s.io/apiserver/plugin/pkg/audit/log
vendor/k8s.io/apiserver/plugin/pkg/audit/dynamic
vendor/k8s.io/apiserver/plugin/pkg/audit/truncate
vendor/k8s.io/component-base/config/v1alpha1
k8s.io/kubernetes/pkg/client/leaderelectionconfig
k8s.io/kubernetes/cmd/controller-manager/app/options
vendor/k8s.io/kube-controller-manager/config/v1alpha1
k8s.io/kubernetes/pkg/apis/core/install
k8s.io/kubernetes/pkg/apis/core/validation
vendor/k8s.io/apiserver/pkg/server/options
k8s.io/kubernetes/pkg/util/configz
k8s.io/kubernetes/pkg/controller/certificates/signer/config/v1alpha1
k8s.io/kubernetes/pkg/controller/daemon/config/v1alpha1
k8s.io/kubernetes/pkg/controller/deployment/config/v1alpha1
k8s.io/kubernetes/pkg/controller/endpoint/config/v1alpha1
k8s.io/kubernetes/pkg/controller/endpointslice/config/v1alpha1
k8s.io/kubernetes/pkg/controller/garbagecollector/config/v1alpha1
k8s.io/kubernetes/pkg/controller/job/config/v1alpha1
k8s.io/kubernetes/pkg/controller/namespace/config/v1alpha1
k8s.io/kubernetes/pkg/controller/nodeipam/config/v1alpha1
k8s.io/kubernetes/pkg/controller/nodelifecycle/config/v1alpha1
k8s.io/kubernetes/pkg/controller/podautoscaler/config/v1alpha1
k8s.io/kubernetes/pkg/controller/podgc/config/v1alpha1
k8s.io/kubernetes/pkg/controller/replicaset/config/v1alpha1
k8s.io/kubernetes/pkg/controller/replication/config/v1alpha1
k8s.io/kubernetes/pkg/controller/resourcequota/config/v1alpha1
k8s.io/kubernetes/pkg/controller/service/config/v1alpha1
k8s.io/kubernetes/pkg/controller/serviceaccount/config/v1alpha1
k8s.io/kubernetes/pkg/controller/statefulset/config/v1alpha1
k8s.io/kubernetes/pkg/controller/ttlafterfinished/config/v1alpha1
k8s.io/kubernetes/pkg/controller/volume/attachdetach/config/v1alpha1
k8s.io/kubernetes/pkg/controller/volume/persistentvolume/config/v1alpha1
k8s.io/kubernetes/cmd/controller-manager/app
k8s.io/kubernetes/pkg/kubelet/util/format
k8s.io/kubernetes/pkg/controller/apis/config/v1alpha1
k8s.io/kubernetes/pkg/util/node
k8s.io/kubernetes/cmd/cloud-controller-manager/app/apis/config/v1alpha1
k8s.io/kubernetes/cmd/cloud-controller-manager/app/apis/config/scheme
k8s.io/kubernetes/pkg/kubelet/apis
k8s.io/kubernetes/pkg/scheduler/api
k8s.io/kubernetes/pkg/util/metrics
vendor/k8s.io/client-go/util/workqueue
vendor/k8s.io/cloud-provider/service/helpers
k8s.io/kubernetes/pkg/util/flag
k8s.io/kubernetes/pkg/controller/service
k8s.io/kubernetes/pkg/version
k8s.io/kubernetes/pkg/version/verflag
k8s.io/kubernetes/cmd/genutils
vendor/k8s.io/apiextensions-apiserver/pkg/apis/apiextensions
vendor/github.com/asaskevich/govalidator
k8s.io/kubernetes/pkg/controller
vendor/k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1
vendor/k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1beta1
vendor/github.com/globalsign/mgo/internal/json
vendor/github.com/globalsign/mgo/bson
vendor/github.com/go-openapi/errors
vendor/github.com/mitchellh/mapstructure
vendor/github.com/go-openapi/analysis/internal
vendor/k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/install
vendor/k8s.io/apiextensions-apiserver/pkg/apiserver/conversion
vendor/k8s.io/apiextensions-apiserver/pkg/apiserver/schema
vendor/github.com/go-openapi/strfmt
vendor/k8s.io/apiextensions-apiserver/pkg/client/clientset/clientset/scheme
vendor/k8s.io/apiextensions-apiserver/pkg/client/clientset/clientset/typed/apiextensions/v1
vendor/k8s.io/apiextensions-apiserver/pkg/apiserver/schema/objectmeta
vendor/k8s.io/apiextensions-apiserver/pkg/apiserver/schema/pruning
vendor/k8s.io/apiextensions-apiserver/pkg/client/clientset/clientset/typed/apiextensions/v1beta1
vendor/k8s.io/apiextensions-apiserver/pkg/client/clientset/internalclientset/scheme
vendor/k8s.io/apiextensions-apiserver/pkg/client/clientset/internalclientset/typed/apiextensions/internalversion
vendor/k8s.io/apiextensions-apiserver/pkg/client/clientset/clientset
vendor/k8s.io/apiextensions-apiserver/pkg/client/clientset/internalclientset
k8s.io/kubernetes/cmd/cloud-controller-manager/app/config
k8s.io/kubernetes/pkg/controller/util/node
vendor/github.com/go-openapi/analysis
vendor/github.com/go-openapi/runtime
vendor/k8s.io/apiextensions-apiserver/pkg/client/informers/externalversions/internalinterfaces
vendor/k8s.io/apiextensions-apiserver/pkg/client/listers/apiextensions/v1
k8s.io/kubernetes/pkg/controller/cloud
k8s.io/kubernetes/pkg/controller/route
vendor/github.com/go-openapi/loads
vendor/github.com/go-openapi/validate
vendor/k8s.io/apiextensions-apiserver/pkg/client/informers/externalversions/apiextensions/v1
vendor/k8s.io/apiextensions-apiserver/pkg/client/listers/apiextensions/v1beta1
vendor/k8s.io/apiextensions-apiserver/pkg/client/informers/externalversions/apiextensions/v1beta1
vendor/k8s.io/apiextensions-apiserver/pkg/client/informers/internalversion/internalinterfaces
vendor/k8s.io/apiextensions-apiserver/pkg/client/informers/externalversions/apiextensions
vendor/k8s.io/apiextensions-apiserver/pkg/client/listers/apiextensions/internalversion
vendor/k8s.io/apiextensions-apiserver/pkg/client/informers/internalversion/apiextensions/internalversion
vendor/k8s.io/apiextensions-apiserver/pkg/client/informers/externalversions
vendor/k8s.io/apiextensions-apiserver/pkg/client/informers/internalversion/apiextensions
vendor/k8s.io/apiextensions-apiserver/pkg/apiserver/validation
vendor/k8s.io/apiextensions-apiserver/pkg/client/informers/internalversion
vendor/k8s.io/apiextensions-apiserver/pkg/apihelpers
vendor/k8s.io/apiextensions-apiserver/pkg/apiserver/schema/defaulting
vendor/k8s.io/apiextensions-apiserver/pkg/controller/apiapproval
k8s.io/kubernetes/cmd/cloud-controller-manager/app/options
vendor/k8s.io/apiextensions-apiserver/pkg/controller/establish
vendor/k8s.io/apiextensions-apiserver/pkg/controller/finalizer
vendor/k8s.io/apiextensions-apiserver/pkg/controller/nonstructuralschema
vendor/k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/validation
vendor/k8s.io/apiextensions-apiserver/pkg/controller/openapi/v2
vendor/k8s.io/apiextensions-apiserver/pkg/generated/openapi
vendor/k8s.io/kube-openapi/pkg/aggregator
vendor/k8s.io/apiextensions-apiserver/pkg/controller/status
vendor/k8s.io/apiextensions-apiserver/pkg/crdserverscheme
vendor/k8s.io/apiextensions-apiserver/pkg/registry/customresource
vendor/k8s.io/apimachinery/pkg/util/duration
vendor/k8s.io/apimachinery/pkg/api/meta/table
vendor/k8s.io/apiextensions-apiserver/pkg/controller/openapi/builder
vendor/k8s.io/client-go/third_party/forked/golang/template
vendor/k8s.io/apiextensions-apiserver/pkg/registry/customresourcedefinition
vendor/k8s.io/client-go/util/jsonpath
vendor/k8s.io/apiextensions-apiserver/pkg/controller/openapi
vendor/k8s.io/client-go/dynamic
vendor/k8s.io/client-go/scale/scheme
vendor/k8s.io/apiextensions-apiserver/pkg/registry/customresource/tableconvertor
vendor/k8s.io/client-go/scale/scheme/appsint
vendor/k8s.io/client-go/scale/scheme/appsv1beta1
vendor/k8s.io/client-go/scale/scheme/appsv1beta2
vendor/k8s.io/client-go/scale/scheme/autoscalingv1
vendor/k8s.io/client-go/scale/scheme/extensionsint
vendor/k8s.io/client-go/scale/scheme/extensionsv1beta1
vendor/k8s.io/apiserver/pkg/util/proxy
vendor/k8s.io/apiserver/pkg/storage/etcd3/preflight
vendor/k8s.io/client-go/scale
vendor/k8s.io/component-base/metrics/prometheus/workqueue
vendor/k8s.io/kube-aggregator/pkg/apis/apiregistration
vendor/k8s.io/apimachinery/pkg/util/httpstream
vendor/github.com/docker/spdystream/spdy
vendor/k8s.io/kube-aggregator/pkg/apis/apiregistration/v1
vendor/k8s.io/apiextensions-apiserver/pkg/apiserver
vendor/k8s.io/kube-aggregator/pkg/apis/apiregistration/v1beta1
vendor/k8s.io/kube-aggregator/pkg/apis/apiregistration/v1/helper
vendor/github.com/docker/spdystream
vendor/k8s.io/apimachinery/third_party/forked/golang/netutil
vendor/github.com/mxk/go-flowrate/flowrate
k8s.io/kubernetes/cmd/cloud-controller-manager/app
vendor/golang.org/x/net/html/atom
vendor/golang.org/x/net/html
vendor/k8s.io/apimachinery/pkg/util/httpstream/spdy
vendor/k8s.io/kube-aggregator/pkg/apis/apiregistration/install
vendor/k8s.io/kube-aggregator/pkg/apiserver/scheme
vendor/k8s.io/kube-aggregator/pkg/client/clientset_generated/clientset/scheme
vendor/k8s.io/kube-aggregator/pkg/client/clientset_generated/clientset/typed/apiregistration/v1
vendor/k8s.io/kube-aggregator/pkg/client/clientset_generated/clientset/typed/apiregistration/v1beta1
vendor/k8s.io/kube-aggregator/pkg/client/listers/apiregistration/v1
vendor/k8s.io/kube-aggregator/pkg/client/clientset_generated/clientset
vendor/k8s.io/apimachinery/pkg/util/proxy
vendor/k8s.io/kube-aggregator/pkg/client/listers/apiregistration/v1beta1
vendor/k8s.io/kube-aggregator/pkg/client/informers/externalversions/internalinterfaces
vendor/k8s.io/kube-aggregator/pkg/controllers
vendor/k8s.io/kube-aggregator/pkg/client/informers/externalversions/apiregistration/v1
vendor/k8s.io/kube-aggregator/pkg/client/informers/externalversions/apiregistration/v1beta1
vendor/k8s.io/kube-aggregator/pkg/controllers/openapi/aggregator
vendor/k8s.io/kube-aggregator/pkg/controllers/status
vendor/k8s.io/kube-aggregator/pkg/client/informers/externalversions/apiregistration
vendor/k8s.io/kube-aggregator/pkg/controllers/openapi
vendor/k8s.io/kube-aggregator/pkg/client/informers/externalversions
vendor/k8s.io/kube-aggregator/pkg/apis/apiregistration/validation
vendor/k8s.io/apiextensions-apiserver/pkg/cmd/server/options
vendor/k8s.io/kube-aggregator/pkg/registry/apiservice
vendor/k8s.io/kube-aggregator/pkg/controllers/autoregister
vendor/github.com/aws/aws-sdk-go/aws/awserr
vendor/k8s.io/kube-aggregator/pkg/registry/apiservice/etcd
vendor/github.com/aws/aws-sdk-go/internal/ini
vendor/github.com/aws/aws-sdk-go/internal/shareddefaults
vendor/k8s.io/kube-aggregator/pkg/registry/apiservice/rest
vendor/github.com/aws/aws-sdk-go/aws/endpoints
vendor/k8s.io/kube-aggregator/pkg/apiserver
vendor/github.com/aws/aws-sdk-go/aws/credentials
vendor/github.com/aws/aws-sdk-go/internal/sdkio
vendor/github.com/aws/aws-sdk-go/aws/client/metadata
vendor/github.com/jmespath/go-jmespath
vendor/github.com/aws/aws-sdk-go/aws/awsutil
vendor/github.com/aws/aws-sdk-go/internal/sdkrand
vendor/github.com/aws/aws-sdk-go/internal/sdkuri
vendor/github.com/aws/aws-sdk-go/aws/credentials/processcreds
vendor/gopkg.in/gcfg.v1/token
vendor/gopkg.in/gcfg.v1/types
vendor/gopkg.in/gcfg.v1/scanner
vendor/gopkg.in/warnings.v0
vendor/k8s.io/cloud-provider/node/helpers
vendor/gopkg.in/gcfg.v1
vendor/k8s.io/cloud-provider/volume
vendor/k8s.io/cloud-provider/volume/errors
vendor/k8s.io/cloud-provider/volume/helpers
vendor/k8s.io/csi-translation-lib/plugins
vendor/github.com/Azure/azure-sdk-for-go/version
vendor/github.com/Azure/go-autorest/autorest/date
vendor/github.com/Azure/go-autorest/tracing
vendor/github.com/dgrijalva/jwt-go
vendor/github.com/aws/aws-sdk-go/aws
vendor/github.com/Azure/go-autorest/logger
vendor/github.com/Azure/go-autorest/autorest/to
vendor/github.com/Azure/go-autorest/autorest/validation
vendor/github.com/aws/aws-sdk-go/aws/request
vendor/github.com/satori/go.uuid
vendor/github.com/Azure/go-autorest/autorest/adal
vendor/github.com/rubiojr/go-vhd/vhd
vendor/golang.org/x/crypto/pkcs12/internal/rc2
vendor/golang.org/x/crypto/pkcs12
vendor/k8s.io/utils/keymutex
vendor/cloud.google.com/go/compute/metadata
vendor/github.com/Azure/go-autorest/autorest
vendor/github.com/aws/aws-sdk-go/aws/client
vendor/github.com/aws/aws-sdk-go/aws/corehandlers
vendor/github.com/aws/aws-sdk-go/private/protocol
vendor/github.com/aws/aws-sdk-go/aws/csm
vendor/github.com/aws/aws-sdk-go/aws/ec2metadata
vendor/github.com/aws/aws-sdk-go/private/protocol/rest
vendor/github.com/aws/aws-sdk-go/private/protocol/query/queryutil
vendor/github.com/aws/aws-sdk-go/aws/credentials/ec2rolecreds
vendor/github.com/aws/aws-sdk-go/private/protocol/xml/xmlutil
vendor/github.com/aws/aws-sdk-go/aws/credentials/endpointcreds
vendor/github.com/aws/aws-sdk-go/aws/signer/v4
vendor/github.com/aws/aws-sdk-go/private/protocol/json/jsonutil
vendor/github.com/aws/aws-sdk-go/aws/defaults
vendor/github.com/aws/aws-sdk-go/private/protocol/query
vendor/github.com/aws/aws-sdk-go/private/protocol/ec2query
vendor/github.com/Azure/go-autorest/autorest/azure
vendor/github.com/aws/aws-sdk-go/service/sts
vendor/github.com/aws/aws-sdk-go/service/autoscaling
vendor/github.com/aws/aws-sdk-go/service/ec2
vendor/github.com/aws/aws-sdk-go/aws/credentials/stscreds
vendor/github.com/aws/aws-sdk-go/service/elb
vendor/github.com/aws/aws-sdk-go/aws/session
vendor/github.com/aws/aws-sdk-go/service/elbv2
vendor/github.com/aws/aws-sdk-go/private/protocol/jsonrpc
vendor/github.com/aws/aws-sdk-go/service/kms
vendor/github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2019-07-01/compute
vendor/github.com/Azure/azure-sdk-for-go/services/network/mgmt/2019-06-01/network
vendor/github.com/Azure/azure-sdk-for-go/services/storage/mgmt/2019-04-01/storage
vendor/github.com/Azure/azure-sdk-for-go/storage
vendor/k8s.io/legacy-cloud-providers/azure/auth
vendor/github.com/GoogleCloudPlatform/k8s-cloud-provider/pkg/cloud/filter
vendor/google.golang.org/api/googleapi/internal/uritemplates
vendor/google.golang.org/api/googleapi
vendor/google.golang.org/api/gensupport
vendor/golang.org/x/oauth2/jws
vendor/golang.org/x/oauth2/jwt
vendor/golang.org/x/oauth2/google
vendor/google.golang.org/api/internal
vendor/google.golang.org/api/option
vendor/go.opencensus.io
vendor/go.opencensus.io/internal
vendor/go.opencensus.io/trace/internal
vendor/go.opencensus.io/trace/tracestate
vendor/go.opencensus.io/trace
vendor/go.opencensus.io/resource
vendor/go.opencensus.io/metric/metricdata
vendor/go.opencensus.io/trace/propagation
vendor/go.opencensus.io/tag
vendor/go.opencensus.io/plugin/ochttp/propagation/b3
vendor/go.opencensus.io/internal/tagencoding
vendor/go.opencensus.io/metric/metricproducer
vendor/go.opencensus.io/stats/internal
vendor/google.golang.org/api/googleapi/transport
vendor/go.opencensus.io/stats
vendor/google.golang.org/api/transport/http/internal/propagation
vendor/go.opencensus.io/stats/view
vendor/k8s.io/apimachinery/pkg/util/version
vendor/github.com/gophercloud/gophercloud
vendor/go.opencensus.io/plugin/ochttp
vendor/github.com/gophercloud/gophercloud/pagination
vendor/google.golang.org/api/transport/http
vendor/github.com/gophercloud/gophercloud/openstack/identity/v2/tenants
vendor/google.golang.org/api/compute/v0.alpha
vendor/google.golang.org/api/compute/v0.beta
vendor/k8s.io/legacy-cloud-providers/aws
vendor/google.golang.org/api/compute/v1
vendor/k8s.io/legacy-cloud-providers/azure
vendor/google.golang.org/api/container/v1
vendor/google.golang.org/api/tpu/v1
vendor/github.com/gophercloud/gophercloud/openstack/identity/v2/tokens
vendor/github.com/gophercloud/gophercloud/openstack/identity/v3/tokens
vendor/github.com/gophercloud/gophercloud/openstack/utils
vendor/github.com/gophercloud/gophercloud/openstack/blockstorage/extensions/volumeactions
vendor/github.com/gophercloud/gophercloud/openstack/blockstorage/v1/volumes
vendor/github.com/gophercloud/gophercloud/openstack
vendor/github.com/GoogleCloudPlatform/k8s-cloud-provider/pkg/cloud/meta
vendor/github.com/gophercloud/gophercloud/openstack/blockstorage/v2/volumes
vendor/github.com/gophercloud/gophercloud/openstack/blockstorage/v3/volumes
vendor/github.com/gophercloud/gophercloud/openstack/compute/v2/extensions/attachinterfaces
vendor/github.com/gophercloud/gophercloud/openstack/compute/v2/extensions/volumeattach
vendor/github.com/gophercloud/gophercloud/openstack/compute/v2/flavors
vendor/github.com/gophercloud/gophercloud/openstack/compute/v2/images
vendor/github.com/gophercloud/gophercloud/openstack/identity/v3/extensions/trusts
vendor/github.com/gophercloud/gophercloud/openstack/common/extensions
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/networks
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions
vendor/github.com/gophercloud/gophercloud/openstack/compute/v2/servers
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions/layer3/floatingips
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions/external
vendor/github.com/GoogleCloudPlatform/k8s-cloud-provider/pkg/cloud
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions/layer3/routers
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions/lbaas_v2/l7policies
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions/lbaas_v2/monitors
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions/security/rules
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/ports
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions/lbaas_v2/pools
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions/security/groups
vendor/k8s.io/utils/exec
vendor/k8s.io/utils/io
vendor/k8s.io/legacy-cloud-providers/openstack/util/mount
vendor/github.com/vmware/govmomi/vim25/debug
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions/lbaas_v2/listeners
vendor/github.com/vmware/govmomi/vim25/progress
vendor/github.com/vmware/govmomi/vim25/types
vendor/github.com/gophercloud/gophercloud/openstack/networking/v2/extensions/lbaas_v2/loadbalancers
vendor/github.com/vmware/govmomi/vim25/xml
vendor/k8s.io/legacy-cloud-providers/openstack
vendor/k8s.io/apiserver/pkg/authentication/token/union
vendor/k8s.io/apiserver/plugin/pkg/authenticator/password/passwordfile
vendor/k8s.io/apiserver/plugin/pkg/authenticator/request/basicauth
vendor/github.com/pquerna/cachecontrol/cacheobject
vendor/github.com/pquerna/cachecontrol
vendor/github.com/coreos/go-oidc
vendor/k8s.io/apiserver/plugin/pkg/authenticator/token/oidc
vendor/k8s.io/client-go/plugin/pkg/client/auth/azure
vendor/k8s.io/client-go/plugin/pkg/client/auth/gcp
vendor/k8s.io/client-go/plugin/pkg/client/auth/oidc
vendor/k8s.io/client-go/plugin/pkg/client/auth/openstack
k8s.io/kubernetes/pkg/apis/abac
vendor/k8s.io/client-go/plugin/pkg/client/auth
k8s.io/kubernetes/pkg/kubeapiserver/authenticator
k8s.io/kubernetes/pkg/apis/abac/v0
k8s.io/kubernetes/pkg/apis/abac/v1beta1
k8s.io/kubernetes/pkg/apis/abac/latest
k8s.io/kubernetes/pkg/auth/authorizer/abac
k8s.io/kubernetes/pkg/auth/nodeidentifier
k8s.io/kubernetes/pkg/kubeapiserver/authorizer/modes
k8s.io/kubernetes/pkg/api/v1/persistentvolume
k8s.io/kubernetes/pkg/apis/coordination
k8s.io/kubernetes/pkg/apis/storage
k8s.io/kubernetes/pkg/apis/rbac
k8s.io/kubernetes/third_party/forked/gonum/graph
vendor/golang.org/x/tools/container/intsets
k8s.io/kubernetes/pkg/apis/rbac/v1
k8s.io/kubernetes/third_party/forked/gonum/graph/simple
k8s.io/kubernetes/third_party/forked/gonum/graph/internal/linear
k8s.io/kubernetes/third_party/forked/gonum/graph/traverse
k8s.io/kubernetes/pkg/registry/rbac/validation
k8s.io/kubernetes/plugin/pkg/auth/authorizer/rbac/bootstrappolicy
k8s.io/kubernetes/plugin/pkg/auth/authorizer/rbac
k8s.io/kubernetes/plugin/pkg/auth/authorizer/node
k8s.io/kubernetes/plugin/pkg/admission/admit
k8s.io/kubernetes/plugin/pkg/admission/alwayspullimages
k8s.io/kubernetes/plugin/pkg/admission/antiaffinity
k8s.io/kubernetes/plugin/pkg/admission/defaulttolerationseconds
k8s.io/kubernetes/plugin/pkg/admission/deny
k8s.io/kubernetes/plugin/pkg/admission/eventratelimit/apis/eventratelimit
k8s.io/kubernetes/plugin/pkg/admission/eventratelimit/apis/eventratelimit/v1alpha1
k8s.io/kubernetes/plugin/pkg/admission/eventratelimit/apis/eventratelimit/install
k8s.io/kubernetes/plugin/pkg/admission/eventratelimit/apis/eventratelimit/validation
k8s.io/kubernetes/plugin/pkg/admission/eventratelimit
k8s.io/kubernetes/plugin/pkg/admission/exec
k8s.io/kubernetes/pkg/kubeapiserver/authorizer
k8s.io/kubernetes/plugin/pkg/admission/extendedresourcetoleration
k8s.io/kubernetes/plugin/pkg/admission/gc
vendor/k8s.io/api/imagepolicy/v1alpha1
k8s.io/kubernetes/pkg/apis/imagepolicy
k8s.io/kubernetes/pkg/apis/imagepolicy/v1alpha1
k8s.io/kubernetes/pkg/apis/imagepolicy/install
k8s.io/kubernetes/plugin/pkg/admission/imagepolicy
k8s.io/kubernetes/plugin/pkg/admission/limitranger
vendor/github.com/GoogleCloudPlatform/k8s-cloud-provider/pkg/cloud/mock
k8s.io/kubernetes/plugin/pkg/admission/namespace/autoprovision
k8s.io/kubernetes/plugin/pkg/admission/namespace/exists
vendor/k8s.io/legacy-cloud-providers/gce
k8s.io/kubernetes/pkg/api/pod
k8s.io/kubernetes/pkg/apis/authentication
k8s.io/kubernetes/pkg/apis/policy
k8s.io/kubernetes/plugin/pkg/admission/nodetaint
k8s.io/kubernetes/plugin/pkg/admission/podnodeselector
k8s.io/kubernetes/plugin/pkg/admission/noderestriction
k8s.io/kubernetes/plugin/pkg/admission/podpreset
k8s.io/kubernetes/pkg/apis/core/helper/qos
k8s.io/kubernetes/pkg/util/tolerations
k8s.io/kubernetes/plugin/pkg/admission/podtolerationrestriction/apis/podtolerationrestriction
k8s.io/kubernetes/plugin/pkg/admission/priority
k8s.io/kubernetes/plugin/pkg/admission/podtolerationrestriction/apis/podtolerationrestriction/v1alpha1
k8s.io/kubernetes/plugin/pkg/admission/podtolerationrestriction/apis/podtolerationrestriction/install
k8s.io/kubernetes/plugin/pkg/admission/podtolerationrestriction/apis/podtolerationrestriction/validation
k8s.io/kubernetes/plugin/pkg/admission/podtolerationrestriction
vendor/k8s.io/apiserver/pkg/admission/plugin/webhook/initializer
vendor/k8s.io/client-go/discovery/cached/memory
vendor/k8s.io/client-go/restmapper
k8s.io/kubernetes/pkg/quota/v1
k8s.io/kubernetes/pkg/apis/core/v1/helper/qos
k8s.io/kubernetes/pkg/quota/v1/generic
k8s.io/kubernetes/plugin/pkg/admission/resourcequota/apis/resourcequota
k8s.io/kubernetes/plugin/pkg/admission/resourcequota/apis/resourcequota/v1alpha1
k8s.io/kubernetes/pkg/quota/v1/evaluator/core
k8s.io/kubernetes/plugin/pkg/admission/resourcequota/apis/resourcequota/v1beta1
k8s.io/kubernetes/plugin/pkg/admission/resourcequota/apis/resourcequota/validation
k8s.io/kubernetes/pkg/apis/node
k8s.io/kubernetes/plugin/pkg/admission/resourcequota/apis/resourcequota/install
k8s.io/kubernetes/pkg/apis/networking
k8s.io/kubernetes/pkg/apis/node/v1beta1
k8s.io/kubernetes/pkg/quota/v1/install
k8s.io/kubernetes/pkg/kubeapiserver/admission
k8s.io/kubernetes/plugin/pkg/admission/runtimeclass
k8s.io/kubernetes/pkg/apis/extensions
k8s.io/kubernetes/pkg/registry/rbac
k8s.io/kubernetes/pkg/util/maps
k8s.io/kubernetes/pkg/security/podsecuritypolicy/apparmor
k8s.io/kubernetes/pkg/security/podsecuritypolicy/capabilities
k8s.io/kubernetes/pkg/security/podsecuritypolicy/util
k8s.io/kubernetes/pkg/security/podsecuritypolicy/seccomp
k8s.io/kubernetes/pkg/security/podsecuritypolicy/group
k8s.io/kubernetes/pkg/security/podsecuritypolicy/selinux
k8s.io/kubernetes/pkg/security/podsecuritypolicy/sysctl
k8s.io/kubernetes/pkg/security/podsecuritypolicy/user
k8s.io/kubernetes/pkg/securitycontext
k8s.io/kubernetes/plugin/pkg/admission/securitycontext/scdeny
k8s.io/kubernetes/plugin/pkg/admission/serviceaccount
k8s.io/kubernetes/pkg/security/podsecuritypolicy
k8s.io/kubernetes/plugin/pkg/admission/security/podsecuritypolicy
k8s.io/kubernetes/plugin/pkg/admission/storage/persistentvolume/resize
k8s.io/kubernetes/pkg/apis/storage/util
k8s.io/kubernetes/plugin/pkg/admission/storage/storageclass/setdefault
k8s.io/kubernetes/plugin/pkg/admission/resourcequota
k8s.io/kubernetes/plugin/pkg/admission/storage/persistentvolume/label
k8s.io/kubernetes/pkg/util/mount
k8s.io/kubernetes/pkg/volume/util/fsquota/common
k8s.io/kubernetes/pkg/util/resizefs
k8s.io/kubernetes/pkg/volume/util/fsquota
k8s.io/kubernetes/pkg/volume/util/hostutil
k8s.io/kubernetes/pkg/volume/util/recyclerclient
k8s.io/kubernetes/pkg/volume/util/fs
k8s.io/kubernetes/pkg/volume/util/subpath
k8s.io/kubernetes/pkg/volume/util/types
k8s.io/kubernetes/pkg/volume/util/volumepathhandler
vendor/k8s.io/utils/strings
k8s.io/kubernetes/pkg/kubelet/client
k8s.io/kubernetes/pkg/api/v1/endpoints
k8s.io/kubernetes/pkg/master/reconcilers
k8s.io/kubernetes/pkg/volume
k8s.io/kubernetes/pkg/registry/core/secret
k8s.io/kubernetes/pkg/controller/serviceaccount
k8s.io/kubernetes/pkg/generated/openapi
k8s.io/kubernetes/pkg/apis/batch
k8s.io/kubernetes/pkg/apis/events
k8s.io/kubernetes/pkg/kubeapiserver
k8s.io/kubernetes/pkg/kubeapiserver/server
vendor/github.com/vmware/govmomi/vim25/soap
vendor/github.com/vmware/govmomi/vim25/methods
vendor/github.com/vmware/govmomi/pbm/types
vendor/github.com/vmware/govmomi/lookup/types
vendor/github.com/vmware/govmomi/lookup/methods
vendor/github.com/vmware/govmomi/sts/internal
k8s.io/kubernetes/pkg/volume/util
vendor/github.com/vmware/govmomi/pbm/methods
k8s.io/kubernetes/pkg/apis/admission
k8s.io/kubernetes/pkg/apis/admission/v1
k8s.io/kubernetes/pkg/apis/admission/v1beta1
k8s.io/kubernetes/pkg/apis/admission/install
k8s.io/kubernetes/pkg/apis/admissionregistration
k8s.io/kubernetes/pkg/apis/admissionregistration/v1
k8s.io/kubernetes/plugin/pkg/admission/storage/storageobjectinuseprotection
k8s.io/kubernetes/pkg/kubeapiserver/options
k8s.io/kubernetes/pkg/apis/admissionregistration/v1beta1
k8s.io/kubernetes/pkg/apis/admissionregistration/install
k8s.io/kubernetes/pkg/apis/apps/v1
vendor/github.com/vmware/govmomi/vim25
vendor/github.com/vmware/govmomi/vim25/mo
vendor/github.com/vmware/govmomi/pbm
vendor/github.com/vmware/govmomi/property
vendor/github.com/vmware/govmomi/vapi/internal
vendor/github.com/vmware/govmomi/vapi/rest
vendor/github.com/vmware/govmomi/list
vendor/github.com/vmware/govmomi/nfc
vendor/github.com/vmware/govmomi/session
vendor/github.com/vmware/govmomi/task
vendor/github.com/vmware/govmomi/vapi/tags
vendor/github.com/vmware/govmomi/lookup
vendor/github.com/vmware/govmomi/object
vendor/github.com/vmware/govmomi/sts
k8s.io/kubernetes/pkg/apis/apps/v1beta1
k8s.io/kubernetes/pkg/apis/apps/v1beta2
k8s.io/kubernetes/pkg/apis/auditregistration
k8s.io/kubernetes/pkg/apis/auditregistration/v1alpha1
k8s.io/kubernetes/pkg/apis/auditregistration/install
k8s.io/kubernetes/pkg/apis/authentication/v1
k8s.io/kubernetes/pkg/apis/apps/install
k8s.io/kubernetes/pkg/apis/authentication/v1beta1
k8s.io/kubernetes/pkg/apis/authorization
k8s.io/kubernetes/pkg/apis/authentication/install
k8s.io/kubernetes/pkg/apis/autoscaling/v1
k8s.io/kubernetes/pkg/apis/authorization/v1
k8s.io/kubernetes/pkg/apis/authorization/v1beta1
k8s.io/kubernetes/pkg/apis/autoscaling/v2beta1
k8s.io/kubernetes/pkg/apis/authorization/install
k8s.io/kubernetes/pkg/apis/autoscaling/v2beta2
k8s.io/kubernetes/pkg/apis/batch/v1
k8s.io/kubernetes/pkg/apis/autoscaling/install
k8s.io/kubernetes/pkg/apis/certificates
k8s.io/kubernetes/pkg/apis/certificates/v1beta1
k8s.io/kubernetes/pkg/apis/batch/v1beta1
k8s.io/kubernetes/pkg/apis/batch/v2alpha1
vendor/github.com/vmware/govmomi/find
k8s.io/kubernetes/pkg/apis/certificates/install
k8s.io/kubernetes/pkg/apis/coordination/v1
k8s.io/kubernetes/pkg/apis/coordination/v1beta1
k8s.io/kubernetes/pkg/apis/batch/install
k8s.io/kubernetes/pkg/apis/discovery
k8s.io/kubernetes/pkg/apis/coordination/install
vendor/k8s.io/legacy-cloud-providers/vsphere/vclib
k8s.io/kubernetes/pkg/apis/events/v1beta1
k8s.io/kubernetes/pkg/apis/discovery/v1alpha1
k8s.io/kubernetes/pkg/apis/events/install
k8s.io/kubernetes/pkg/apis/discovery/install
k8s.io/kubernetes/pkg/apis/extensions/v1beta1
k8s.io/kubernetes/pkg/apis/networking/v1
k8s.io/kubernetes/pkg/apis/networking/v1beta1
k8s.io/kubernetes/pkg/apis/networking/install
k8s.io/kubernetes/pkg/apis/node/v1alpha1
k8s.io/kubernetes/pkg/apis/node/install
k8s.io/kubernetes/pkg/apis/policy/v1beta1
vendor/k8s.io/legacy-cloud-providers/vsphere/vclib/diskmanagers
k8s.io/kubernetes/pkg/apis/extensions/install
k8s.io/kubernetes/pkg/apis/rbac/v1alpha1
k8s.io/kubernetes/pkg/apis/policy/install
k8s.io/kubernetes/pkg/apis/rbac/v1beta1
vendor/k8s.io/legacy-cloud-providers/vsphere
k8s.io/kubernetes/pkg/apis/scheduling/v1
k8s.io/kubernetes/pkg/apis/rbac/install
k8s.io/kubernetes/pkg/apis/scheduling/v1alpha1
k8s.io/kubernetes/pkg/apis/scheduling/v1beta1
k8s.io/kubernetes/pkg/apis/settings
k8s.io/kubernetes/pkg/apis/scheduling/install
k8s.io/kubernetes/pkg/apis/storage/v1
k8s.io/kubernetes/pkg/apis/settings/v1alpha1
k8s.io/kubernetes/pkg/apis/storage/v1alpha1
k8s.io/kubernetes/pkg/apis/settings/install
k8s.io/kubernetes/pkg/apis/storage/v1beta1
vendor/golang.org/x/crypto/curve25519
k8s.io/kubernetes/pkg/apis/storage/install
vendor/golang.org/x/crypto/internal/chacha20
k8s.io/kubernetes/pkg/apis/admissionregistration/validation
k8s.io/kubernetes/pkg/cloudprovider/providers
vendor/golang.org/x/crypto/ssh
k8s.io/kubernetes/cmd/kube-apiserver/app/options
k8s.io/kubernetes/pkg/registry/admissionregistration/mutatingwebhookconfiguration
k8s.io/kubernetes/pkg/registry/admissionregistration/mutatingwebhookconfiguration/storage
k8s.io/kubernetes/pkg/registry/admissionregistration/validatingwebhookconfiguration
k8s.io/kubernetes/pkg/registry/admissionregistration/validatingwebhookconfiguration/storage
k8s.io/kubernetes/pkg/registry/admissionregistration/rest
vendor/github.com/liggitt/tabwriter
k8s.io/kubernetes/pkg/printers
k8s.io/kubernetes/pkg/printers/internalversion
k8s.io/kubernetes/pkg/ssh
k8s.io/kubernetes/pkg/master/tunneler
k8s.io/kubernetes/pkg/printers/storage
k8s.io/kubernetes/pkg/apis/apps/validation
k8s.io/kubernetes/pkg/apis/autoscaling/validation
k8s.io/kubernetes/pkg/apis/auditregistration/validation
k8s.io/kubernetes/pkg/registry/authentication/tokenreview
k8s.io/kubernetes/pkg/registry/apps/controllerrevision
k8s.io/kubernetes/pkg/registry/apps/daemonset
k8s.io/kubernetes/pkg/registry/apps/controllerrevision/storage
k8s.io/kubernetes/pkg/registry/apps/deployment
k8s.io/kubernetes/pkg/registry/apps/daemonset/storage
k8s.io/kubernetes/pkg/registry/apps/replicaset
k8s.io/kubernetes/pkg/registry/apps/deployment/storage
k8s.io/kubernetes/pkg/registry/apps/replicaset/storage
k8s.io/kubernetes/pkg/registry/apps/statefulset
k8s.io/kubernetes/pkg/registry/apps/statefulset/storage
k8s.io/kubernetes/pkg/registry/auditregistration/auditsink
k8s.io/kubernetes/pkg/registry/authentication/rest
k8s.io/kubernetes/pkg/registry/auditregistration/auditsink/storage
k8s.io/kubernetes/pkg/apis/authorization/validation
k8s.io/kubernetes/pkg/registry/apps/rest
k8s.io/kubernetes/pkg/registry/authorization/util
k8s.io/kubernetes/pkg/registry/auditregistration/rest
k8s.io/kubernetes/pkg/registry/authorization/localsubjectaccessreview
k8s.io/kubernetes/pkg/registry/authorization/selfsubjectaccessreview
k8s.io/kubernetes/pkg/registry/authorization/selfsubjectrulesreview
k8s.io/kubernetes/pkg/registry/authorization/subjectaccessreview
k8s.io/kubernetes/pkg/registry/autoscaling/horizontalpodautoscaler
vendor/github.com/robfig/cron
k8s.io/kubernetes/pkg/registry/authorization/rest
k8s.io/kubernetes/pkg/apis/certificates/validation
k8s.io/kubernetes/pkg/registry/autoscaling/horizontalpodautoscaler/storage
k8s.io/kubernetes/pkg/apis/batch/validation
k8s.io/kubernetes/pkg/registry/certificates/certificates
k8s.io/kubernetes/pkg/registry/autoscaling/rest
k8s.io/kubernetes/pkg/registry/batch/cronjob
k8s.io/kubernetes/pkg/registry/batch/job
k8s.io/kubernetes/pkg/registry/certificates/certificates/storage
k8s.io/kubernetes/pkg/registry/batch/cronjob/storage
k8s.io/kubernetes/pkg/registry/certificates/rest
k8s.io/kubernetes/pkg/registry/batch/job/storage
k8s.io/kubernetes/pkg/apis/coordination/validation
k8s.io/kubernetes/pkg/registry/coordination/lease
k8s.io/kubernetes/pkg/registry/core/rangeallocation
k8s.io/kubernetes/pkg/registry/coordination/lease/storage
k8s.io/kubernetes/pkg/registry/batch/rest
k8s.io/kubernetes/pkg/probe
k8s.io/kubernetes/pkg/probe/http
k8s.io/kubernetes/pkg/registry/coordination/rest
k8s.io/kubernetes/pkg/registry/core/configmap
k8s.io/kubernetes/pkg/api/endpoints
k8s.io/kubernetes/pkg/registry/core/componentstatus
k8s.io/kubernetes/pkg/registry/core/event
k8s.io/kubernetes/pkg/registry/core/configmap/storage
k8s.io/kubernetes/pkg/registry/core/endpoint
k8s.io/kubernetes/pkg/registry/core/event/storage
k8s.io/kubernetes/pkg/registry/core/limitrange
k8s.io/kubernetes/pkg/registry/core/endpoint/storage
k8s.io/kubernetes/pkg/registry/core/namespace
k8s.io/kubernetes/pkg/registry/core/limitrange/storage
k8s.io/kubernetes/pkg/proxy/util
k8s.io/kubernetes/pkg/api/persistentvolume
k8s.io/kubernetes/pkg/volume/validation
k8s.io/kubernetes/pkg/api/persistentvolumeclaim
k8s.io/kubernetes/pkg/registry/core/node
k8s.io/kubernetes/pkg/registry/core/namespace/storage
k8s.io/kubernetes/pkg/registry/core/persistentvolumeclaim
k8s.io/kubernetes/pkg/registry/core/persistentvolume
k8s.io/kubernetes/pkg/registry/core/persistentvolume/storage
k8s.io/kubernetes/pkg/registry/core/persistentvolumeclaim/storage
k8s.io/kubernetes/pkg/registry/core/node/rest
k8s.io/kubernetes/pkg/registry/core/pod
k8s.io/kubernetes/pkg/registry/core/node/storage
vendor/k8s.io/apiserver/pkg/registry/generic/rest
k8s.io/kubernetes/pkg/registry/core/podtemplate
k8s.io/kubernetes/pkg/registry/core/replicationcontroller
k8s.io/kubernetes/pkg/registry/core/podtemplate/storage
k8s.io/kubernetes/pkg/api/resourcequota
k8s.io/kubernetes/pkg/registry/core/replicationcontroller/storage
k8s.io/kubernetes/pkg/registry/core/pod/rest
k8s.io/kubernetes/pkg/registry/core/resourcequota
k8s.io/kubernetes/pkg/registry/core/secret/storage
k8s.io/kubernetes/pkg/registry/core/resourcequota/storage
k8s.io/kubernetes/pkg/registry/core/pod/storage
k8s.io/kubernetes/pkg/registry/core/service/allocator
k8s.io/kubernetes/pkg/registry/core/service
k8s.io/kubernetes/pkg/apis/authentication/validation
k8s.io/kubernetes/pkg/registry/core/service/allocator/storage
k8s.io/kubernetes/pkg/registry/core/service/ipallocator
k8s.io/kubernetes/pkg/registry/core/service/portallocator
k8s.io/kubernetes/pkg/registry/core/serviceaccount
k8s.io/kubernetes/pkg/registry/core/service/ipallocator/controller
k8s.io/kubernetes/pkg/registry/core/service/storage
k8s.io/kubernetes/pkg/registry/core/serviceaccount/storage
k8s.io/kubernetes/pkg/registry/core/service/portallocator/controller
k8s.io/kubernetes/pkg/apis/discovery/validation
k8s.io/kubernetes/pkg/registry/events/rest
k8s.io/kubernetes/pkg/registry/discovery/endpointslice
k8s.io/kubernetes/pkg/registry/extensions/controller/storage
k8s.io/kubernetes/pkg/registry/discovery/endpointslice/storage
k8s.io/kubernetes/pkg/apis/networking/validation
k8s.io/kubernetes/pkg/api/podsecuritypolicy
k8s.io/kubernetes/pkg/apis/policy/validation
k8s.io/kubernetes/pkg/registry/core/rest
k8s.io/kubernetes/pkg/registry/discovery/rest
k8s.io/kubernetes/pkg/registry/networking/ingress
k8s.io/kubernetes/pkg/registry/networking/networkpolicy
k8s.io/kubernetes/pkg/registry/networking/ingress/storage
k8s.io/kubernetes/pkg/registry/policy/podsecuritypolicy
k8s.io/kubernetes/pkg/registry/networking/networkpolicy/storage
k8s.io/kubernetes/pkg/registry/policy/podsecuritypolicy/storage
k8s.io/kubernetes/pkg/apis/node/validation
k8s.io/kubernetes/pkg/registry/policy/poddisruptionbudget
k8s.io/kubernetes/pkg/registry/networking/rest
k8s.io/kubernetes/pkg/registry/node/runtimeclass
k8s.io/kubernetes/pkg/registry/policy/poddisruptionbudget/storage
k8s.io/kubernetes/pkg/registry/extensions/rest
k8s.io/kubernetes/pkg/registry/node/runtimeclass/storage
k8s.io/kubernetes/pkg/apis/rbac/validation
k8s.io/kubernetes/pkg/registry/policy/rest
k8s.io/kubernetes/pkg/registry/node/rest
k8s.io/kubernetes/pkg/registry/rbac/clusterrole
k8s.io/kubernetes/pkg/registry/rbac/clusterrole/policybased
k8s.io/kubernetes/pkg/registry/rbac/clusterrolebinding
k8s.io/kubernetes/pkg/registry/rbac/clusterrolebinding/policybased
k8s.io/kubernetes/pkg/registry/rbac/clusterrole/storage
k8s.io/kubernetes/pkg/registry/rbac/reconciliation
k8s.io/kubernetes/pkg/registry/rbac/clusterrolebinding/storage
k8s.io/kubernetes/pkg/registry/rbac/role
k8s.io/kubernetes/pkg/registry/rbac/role/policybased
k8s.io/kubernetes/pkg/registry/rbac/rolebinding
k8s.io/kubernetes/pkg/registry/rbac/rolebinding/policybased
k8s.io/kubernetes/pkg/registry/rbac/role/storage
k8s.io/kubernetes/pkg/apis/scheduling/util
k8s.io/kubernetes/pkg/registry/rbac/rolebinding/storage
k8s.io/kubernetes/pkg/apis/scheduling/validation
k8s.io/kubernetes/pkg/apis/settings/validation
k8s.io/kubernetes/pkg/registry/scheduling/priorityclass
k8s.io/kubernetes/pkg/apis/storage/validation
k8s.io/kubernetes/pkg/registry/settings/podpreset
k8s.io/kubernetes/pkg/registry/rbac/rest
k8s.io/kubernetes/pkg/registry/scheduling/priorityclass/storage
k8s.io/kubernetes/pkg/registry/settings/podpreset/storage
k8s.io/kubernetes/pkg/registry/storage/csidriver
k8s.io/kubernetes/pkg/registry/scheduling/rest
k8s.io/kubernetes/pkg/registry/storage/csidriver/storage
k8s.io/kubernetes/pkg/registry/settings/rest
k8s.io/kubernetes/pkg/registry/storage/csinode
k8s.io/kubernetes/pkg/registry/storage/storageclass
k8s.io/kubernetes/pkg/registry/storage/volumeattachment
k8s.io/kubernetes/pkg/routes
k8s.io/kubernetes/pkg/registry/storage/csinode/storage
k8s.io/kubernetes/pkg/util/async
k8s.io/kubernetes/pkg/registry/storage/storageclass/storage
k8s.io/kubernetes/pkg/registry/storage/volumeattachment/storage
k8s.io/kubernetes/pkg/master/controller/crdregistration
k8s.io/kubernetes/pkg/registry/cachesize
vendor/k8s.io/cluster-bootstrap/token/api
vendor/k8s.io/client-go/discovery/cached
k8s.io/kubernetes/cmd/kube-controller-manager/app/config
vendor/k8s.io/cluster-bootstrap/token/util
k8s.io/kubernetes/pkg/registry/storage/rest
vendor/k8s.io/cluster-bootstrap/util/secrets
vendor/k8s.io/cluster-bootstrap/util/tokens
k8s.io/kubernetes/pkg/controller/apis/config/scheme
k8s.io/kubernetes/pkg/master
k8s.io/kubernetes/plugin/pkg/auth/authenticator/token/bootstrap
vendor/gonum.org/v1/gonum/graph
vendor/gonum.org/v1/gonum/graph/formats/dot/ast
vendor/gonum.org/v1/gonum/graph/formats/dot/internal/token
vendor/gonum.org/v1/gonum/graph/formats/dot/internal/lexer
vendor/gonum.org/v1/gonum/graph/encoding
vendor/gonum.org/v1/gonum/graph/formats/dot/internal/astx
vendor/gonum.org/v1/gonum/graph/formats/dot/internal/errors
vendor/gonum.org/v1/gonum/graph/internal/ordered
vendor/gonum.org/v1/gonum/graph/formats/dot/internal/parser
vendor/gonum.org/v1/gonum/graph/internal/set
vendor/gonum.org/v1/gonum/graph/internal/uid
vendor/gonum.org/v1/gonum/graph/iterator
vendor/gonum.org/v1/gonum/graph/formats/dot
vendor/gonum.org/v1/gonum/blas
vendor/gonum.org/v1/gonum/graph/encoding/dot
vendor/gonum.org/v1/gonum/internal/asm/c128
vendor/gonum.org/v1/gonum/internal/asm/c64
vendor/gonum.org/v1/gonum/internal/asm/f32
vendor/gonum.org/v1/gonum/internal/asm/f64
k8s.io/kubernetes/cmd/kube-apiserver/app
vendor/gonum.org/v1/gonum/internal/math32
vendor/gonum.org/v1/gonum/lapack
vendor/gonum.org/v1/gonum/internal/cmplx64
k8s.io/kubernetes/pkg/controller/garbagecollector/metaonly
vendor/k8s.io/cluster-bootstrap/token/jws
k8s.io/kubernetes/pkg/controller/bootstrap
k8s.io/kubernetes/pkg/controller/certificates
vendor/gonum.org/v1/gonum/blas/gonum
vendor/gonum.org/v1/gonum/floats
k8s.io/kubernetes/pkg/controller/certificates/approver
k8s.io/kubernetes/pkg/controller/certificates/cleaner
k8s.io/kubernetes/pkg/controller/certificates/rootcacertpublisher
vendor/github.com/cloudflare/cfssl/auth
vendor/github.com/cloudflare/cfssl/errors
vendor/github.com/cloudflare/cfssl/crypto/pkcs7
vendor/github.com/cloudflare/cfssl/helpers/derhelpers
vendor/github.com/cloudflare/cfssl/log
vendor/github.com/google/certificate-transparency-go/asn1
vendor/golang.org/x/crypto/ocsp
vendor/github.com/cloudflare/cfssl/ocsp/config
vendor/github.com/cloudflare/cfssl/certdb
vendor/github.com/cloudflare/cfssl/info
vendor/github.com/google/certificate-transparency-go/client/configpb
vendor/github.com/google/certificate-transparency-go/tls
vendor/github.com/google/certificate-transparency-go/x509/pkix
k8s.io/kubernetes/pkg/controller/clusterroleaggregation
k8s.io/kubernetes/pkg/controller/cronjob
vendor/github.com/google/certificate-transparency-go/x509
k8s.io/kubernetes/pkg/controller/daemon/util
vendor/k8s.io/csi-translation-lib
vendor/gonum.org/v1/gonum/blas/blas64
vendor/gonum.org/v1/gonum/blas/cblas128
vendor/gonum.org/v1/gonum/lapack/gonum
k8s.io/kubernetes/pkg/scheduler/algorithm/priorities/util
k8s.io/kubernetes/pkg/scheduler/nodeinfo
k8s.io/kubernetes/pkg/controller/volume/persistentvolume/util
vendor/github.com/google/certificate-transparency-go
k8s.io/kubernetes/pkg/controller/volume/scheduling
k8s.io/kubernetes/pkg/scheduler/algorithm
vendor/github.com/cloudflare/cfssl/helpers
vendor/github.com/cloudflare/cfssl/config
vendor/github.com/cloudflare/cfssl/csr
vendor/github.com/cloudflare/cfssl/signer
vendor/github.com/google/certificate-transparency-go/jsonclient
k8s.io/kubernetes/pkg/util/labels
vendor/github.com/google/certificate-transparency-go/client
k8s.io/kubernetes/pkg/controller/deployment/util
k8s.io/kubernetes/pkg/scheduler/metrics
vendor/github.com/cloudflare/cfssl/signer/local
k8s.io/kubernetes/pkg/scheduler/util
k8s.io/kubernetes/pkg/controller/certificates/signer
k8s.io/kubernetes/pkg/scheduler/volumebinder
k8s.io/kubernetes/pkg/controller/deployment
vendor/gonum.org/v1/gonum/lapack/lapack64
vendor/gonum.org/v1/gonum/mat
k8s.io/kubernetes/pkg/controller/disruption
k8s.io/kubernetes/pkg/scheduler/algorithm/predicates
k8s.io/kubernetes/pkg/controller/util/endpoint
k8s.io/kubernetes/pkg/controller/job
k8s.io/kubernetes/pkg/controller/endpoint
k8s.io/kubernetes/pkg/controller/daemon
k8s.io/kubernetes/pkg/controller/endpointslice
vendor/gonum.org/v1/gonum/graph/simple
k8s.io/kubernetes/pkg/controller/namespace/deletion
k8s.io/kubernetes/pkg/controller/namespace
k8s.io/kubernetes/pkg/controller/garbagecollector
k8s.io/kubernetes/pkg/controller/nodeipam/ipam/cidrset
k8s.io/kubernetes/pkg/controller/nodeipam/ipam/sync
vendor/k8s.io/metrics/pkg/apis/metrics
k8s.io/kubernetes/pkg/controller/nodelifecycle/scheduler
vendor/k8s.io/heapster/metrics/api/v1/types
vendor/k8s.io/metrics/pkg/apis/metrics/v1alpha1
vendor/k8s.io/metrics/pkg/apis/metrics/v1beta1
k8s.io/kubernetes/cmd/kube-controller-manager/app/options
vendor/k8s.io/metrics/pkg/apis/custom_metrics
vendor/k8s.io/metrics/pkg/client/clientset/versioned/scheme
vendor/k8s.io/metrics/pkg/apis/custom_metrics/v1beta2
k8s.io/kubernetes/pkg/controller/nodeipam/ipam
k8s.io/kubernetes/pkg/controller/nodelifecycle
vendor/k8s.io/metrics/pkg/client/clientset/versioned/typed/metrics/v1beta1
vendor/k8s.io/metrics/pkg/apis/custom_metrics/v1beta1
vendor/k8s.io/metrics/pkg/apis/external_metrics
vendor/k8s.io/metrics/pkg/client/custom_metrics/scheme
vendor/k8s.io/metrics/pkg/apis/external_metrics/v1beta1
vendor/k8s.io/metrics/pkg/client/custom_metrics
vendor/k8s.io/metrics/pkg/client/external_metrics
k8s.io/kubernetes/pkg/controller/podgc
k8s.io/kubernetes/pkg/controller/nodeipam
k8s.io/kubernetes/pkg/controller/podautoscaler/metrics
k8s.io/kubernetes/pkg/controller/replicaset
k8s.io/kubernetes/pkg/controller/podautoscaler
k8s.io/kubernetes/pkg/controller/resourcequota
k8s.io/kubernetes/pkg/controller/history
k8s.io/kubernetes/pkg/controller/replication
k8s.io/kubernetes/pkg/controller/ttl
vendor/k8s.io/kubectl/pkg/scheme
k8s.io/kubernetes/pkg/controller/statefulset
k8s.io/kubernetes/pkg/controller/ttlafterfinished
k8s.io/kubernetes/pkg/kubelet/events
vendor/github.com/golang/protobuf/ptypes/wrappers
vendor/github.com/container-storage-interface/spec/lib/go/csi
k8s.io/kubernetes/pkg/volume/csi/csiv0
k8s.io/kubernetes/pkg/volume/csi/nodeinfomanager
k8s.io/kubernetes/pkg/util/goroutinemap/exponentialbackoff
k8s.io/kubernetes/pkg/volume/util/nestedpendingoperations
k8s.io/kubernetes/pkg/controller/volume/events
k8s.io/kubernetes/pkg/controller/volume/persistentvolume/metrics
k8s.io/kubernetes/pkg/util/goroutinemap
k8s.io/kubernetes/pkg/util/slice
k8s.io/kubernetes/pkg/volume/awsebs
k8s.io/kubernetes/pkg/controller/volume/protectionutil
k8s.io/kubernetes/pkg/volume/csi
k8s.io/kubernetes/pkg/controller/volume/pvcprotection
k8s.io/kubernetes/pkg/controller/volume/persistentvolume
k8s.io/kubernetes/pkg/controller/volume/pvprotection
k8s.io/kubernetes/pkg/volume/azure_dd
k8s.io/kubernetes/pkg/volume/azure_file
k8s.io/kubernetes/pkg/volume/util/operationexecutor
k8s.io/kubernetes/pkg/volume/cinder
k8s.io/kubernetes/pkg/volume/fc
vendor/github.com/fsnotify/fsnotify
vendor/github.com/spf13/afero/mem
vendor/github.com/clusterhq/flocker-go
vendor/github.com/spf13/afero
k8s.io/kubernetes/pkg/util/env
k8s.io/kubernetes/pkg/volume/flocker
k8s.io/kubernetes/pkg/volume/gcepd
k8s.io/kubernetes/pkg/util/filesystem
k8s.io/kubernetes/pkg/volume/flexvolume
vendor/github.com/go-ozzo/ozzo-validation
vendor/github.com/go-ozzo/ozzo-validation/is
vendor/github.com/heketi/heketi/pkg/glusterfs/api
k8s.io/kubernetes/pkg/controller/volume/attachdetach/cache
k8s.io/kubernetes/pkg/controller/volume/expand
vendor/github.com/heketi/heketi/pkg/utils
k8s.io/kubernetes/pkg/volume/hostpath
vendor/github.com/heketi/heketi/client/api/go-client
k8s.io/kubernetes/pkg/volume/glusterfs
k8s.io/kubernetes/pkg/kubelet/checkpointmanager/errors
k8s.io/kubernetes/pkg/controller/volume/attachdetach/util
k8s.io/kubernetes/pkg/controller/volume/attachdetach/statusupdater
k8s.io/kubernetes/pkg/kubelet/util/store
k8s.io/kubernetes/pkg/kubelet/checkpointmanager
k8s.io/kubernetes/pkg/kubelet/checkpointmanager/checksum
vendor/k8s.io/apimachinery/pkg/util/remotecommand
k8s.io/kubernetes/pkg/kubelet/checkpoint
vendor/k8s.io/client-go/transport/spdy
k8s.io/kubernetes/pkg/controller/volume/attachdetach/metrics
k8s.io/kubernetes/pkg/controller/volume/attachdetach/populator
vendor/k8s.io/client-go/util/exec
vendor/k8s.io/client-go/tools/remotecommand
vendor/k8s.io/cri-api/pkg/apis/runtime/v1alpha2
k8s.io/kubernetes/third_party/forked/golang/expansion
k8s.io/kubernetes/pkg/util/config
k8s.io/kubernetes/pkg/controller/volume/attachdetach/reconciler
k8s.io/kubernetes/pkg/volume/local
k8s.io/kubernetes/pkg/volume/nfs
k8s.io/kubernetes/pkg/controller/volume/attachdetach
vendor/github.com/mohae/deepcopy
vendor/github.com/libopenstorage/openstorage/api
vendor/github.com/libopenstorage/openstorage/api/client
vendor/github.com/libopenstorage/openstorage/pkg/parser
vendor/github.com/libopenstorage/openstorage/pkg/units
vendor/github.com/quobyte/api
k8s.io/kubernetes/pkg/volume/rbd
vendor/github.com/libopenstorage/openstorage/volume
vendor/github.com/libopenstorage/openstorage/api/spec
vendor/github.com/libopenstorage/openstorage/api/client/volume
k8s.io/kubernetes/pkg/volume/quobyte
k8s.io/kubernetes/pkg/volume/portworx
vendor/github.com/sirupsen/logrus
vendor/github.com/thecodeteam/goscaleio/types/v1
vendor/github.com/storageos/go-api/serror
vendor/github.com/storageos/go-api/types
vendor/github.com/storageos/go-api/netutil
vendor/github.com/thecodeteam/goscaleio
k8s.io/kubernetes/pkg/volume/vsphere_volume
vendor/github.com/storageos/go-api
k8s.io/kubernetes/pkg/volume/storageos
k8s.io/kubernetes/pkg/volume/scaleio
k8s.io/kubernetes/pkg/kubelet/container
vendor/k8s.io/kube-proxy/config/v1alpha1
k8s.io/kubernetes/pkg/kubelet/qos
k8s.io/kubernetes/pkg/api/v1/service
k8s.io/kubernetes/pkg/proxy/config
k8s.io/kubernetes/pkg/proxy/metrics
k8s.io/kubernetes/pkg/proxy/apis
k8s.io/kubernetes/pkg/proxy
k8s.io/kubernetes/pkg/proxy/apis/config
k8s.io/kubernetes/pkg/kubelet/config
k8s.io/kubernetes/pkg/proxy/apis/config/v1alpha1
k8s.io/kubernetes/pkg/proxy/apis/config/validation
vendor/github.com/lithammer/dedent
k8s.io/kubernetes/pkg/proxy/apis/config/scheme
k8s.io/kubernetes/pkg/proxy/healthcheck
k8s.io/kubernetes/pkg/util/conntrack
vendor/github.com/godbus/dbus
k8s.io/kubernetes/pkg/util/sysctl
vendor/github.com/vishvananda/netns
k8s.io/kubernetes/pkg/util/ipset
vendor/github.com/vishvananda/netlink/nl
vendor/github.com/docker/go-units
vendor/github.com/opencontainers/runtime-spec/specs-go
vendor/github.com/vishvananda/netlink
vendor/github.com/docker/libnetwork/ipvs
k8s.io/kubernetes/pkg/volume/iscsi
k8s.io/kubernetes/pkg/util/ipvs
vendor/github.com/opencontainers/runc/libcontainer/configs
k8s.io/kubernetes/pkg/util/dbus
vendor/github.com/opencontainers/runc/libcontainer/cgroups
k8s.io/kubernetes/pkg/util/iptables
vendor/github.com/opencontainers/runc/libcontainer/utils
k8s.io/kubernetes/pkg/proxy/iptables
k8s.io/kubernetes/cmd/kube-controller-manager/app
k8s.io/kubernetes/pkg/proxy/userspace
k8s.io/kubernetes/pkg/kubelet/cm/util
k8s.io/kubernetes/pkg/util/oom
vendor/k8s.io/client-go/tools/events
k8s.io/kubernetes/pkg/scheduler/apis/config
vendor/k8s.io/kube-scheduler/config/v1alpha1
k8s.io/kubernetes/cmd/kube-scheduler/app/config
k8s.io/kubernetes/pkg/scheduler/apis/config/v1alpha1
k8s.io/kubernetes/pkg/scheduler/apis/config/scheme
vendor/k8s.io/component-base/config/validation
k8s.io/kubernetes/pkg/scheduler/apis/config/validation
k8s.io/kubernetes/pkg/scheduler/algorithm/priorities
k8s.io/kubernetes/pkg/proxy/ipvs
k8s.io/kubernetes/pkg/scheduler/api/validation
k8s.io/kubernetes/pkg/scheduler/framework/v1alpha1
k8s.io/kubernetes/pkg/scheduler/internal/cache
k8s.io/kubernetes/cmd/kube-proxy/app
k8s.io/kubernetes/pkg/scheduler/internal/queue
vendor/k8s.io/apimachinery/pkg/runtime/serializer/yaml
k8s.io/kubernetes/pkg/scheduler/api/v1
vendor/github.com/pkg/errors
k8s.io/kubernetes/pkg/kubelet/apis/config
k8s.io/kubernetes/pkg/scheduler/core
k8s.io/kubernetes/pkg/scheduler/internal/cache/debugger
k8s.io/kubernetes/pkg/scheduler/api/latest
k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm
k8s.io/kubernetes/cmd/kubeadm/app/features
vendor/k8s.io/kubelet/config/v1beta1
k8s.io/kubernetes/cmd/kubeadm/app/constants
k8s.io/kubernetes/cmd/kubeadm/app/version
k8s.io/kubernetes/pkg/scheduler/factory
vendor/k8s.io/client-go/testing
k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta1
k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2
k8s.io/kubernetes/cmd/kubeadm/app/util
vendor/k8s.io/client-go/discovery/fake
k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/scheme
k8s.io/kubernetes/cmd/kubeadm/app/cmd/options
vendor/k8s.io/client-go/kubernetes/typed/admissionregistration/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/admissionregistration/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/apps/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/apps/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/apps/v1beta2/fake
vendor/k8s.io/client-go/kubernetes/typed/auditregistration/v1alpha1/fake
vendor/k8s.io/client-go/kubernetes/typed/authentication/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/authentication/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/authorization/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/authorization/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/autoscaling/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/autoscaling/v2beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/autoscaling/v2beta2/fake
k8s.io/kubernetes/cmd/kube-scheduler/app/options
k8s.io/kubernetes/pkg/scheduler
k8s.io/kubernetes/pkg/scheduler/algorithmprovider/defaults
vendor/k8s.io/client-go/kubernetes/typed/batch/v1/fake
k8s.io/kubernetes/pkg/scheduler/algorithmprovider
vendor/k8s.io/client-go/kubernetes/typed/batch/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/batch/v2alpha1/fake
vendor/k8s.io/client-go/kubernetes/typed/certificates/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/coordination/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/coordination/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/core/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/discovery/v1alpha1/fake
vendor/k8s.io/client-go/kubernetes/typed/events/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/extensions/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/networking/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/networking/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/node/v1alpha1/fake
vendor/k8s.io/client-go/kubernetes/typed/node/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/policy/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/rbac/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/rbac/v1alpha1/fake
k8s.io/kubernetes/cmd/kube-scheduler/app
vendor/k8s.io/client-go/kubernetes/typed/rbac/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/scheduling/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/scheduling/v1alpha1/fake
vendor/k8s.io/client-go/kubernetes/typed/scheduling/v1beta1/fake
vendor/k8s.io/client-go/kubernetes/typed/settings/v1alpha1/fake
vendor/k8s.io/client-go/kubernetes/typed/storage/v1/fake
vendor/k8s.io/client-go/kubernetes/typed/storage/v1alpha1/fake
vendor/k8s.io/client-go/kubernetes/typed/storage/v1beta1/fake
k8s.io/kubernetes/pkg/kubelet/apis/config/v1beta1
k8s.io/kubernetes/pkg/kubelet/apis/config/validation
k8s.io/kubernetes/cmd/kubeadm/app/cmd/phases
k8s.io/kubernetes/cmd/kubeadm/app/util/kubeconfig
k8s.io/kubernetes/cmd/kubeadm/app/util/pubkeypin
vendor/k8s.io/client-go/util/certificate/csr
vendor/k8s.io/client-go/kubernetes/fake
k8s.io/kubernetes/cmd/kubeadm/app/util/pkiutil
k8s.io/kubernetes/cmd/kubeadm/app/util/crypto
k8s.io/kubernetes/cmd/kubeadm/app/phases/certs
k8s.io/kubernetes/cmd/kubeadm/app/images
k8s.io/kubernetes/cmd/kubeadm/app/util/initsystem
k8s.io/kubernetes/cmd/kubeadm/app/phases/certs/renewal
k8s.io/kubernetes/cmd/kubeadm/app/util/runtime
k8s.io/kubernetes/cmd/kubeadm/app/util/system
k8s.io/kubernetes/cmd/kubeadm/app/preflight
k8s.io/kubernetes/cmd/kubeadm/app/cmd/phases/workflow
vendor/github.com/caddyserver/caddy/caddyfile
vendor/github.com/coredns/corefile-migration/migration/corefile
vendor/k8s.io/cli-runtime/pkg/kustomize/k8sdeps/kv
vendor/github.com/coredns/corefile-migration/migration
vendor/sigs.k8s.io/kustomize/pkg/gvk
vendor/sigs.k8s.io/kustomize/pkg/image
vendor/sigs.k8s.io/kustomize/pkg/patch
vendor/sigs.k8s.io/kustomize/pkg/types
vendor/sigs.k8s.io/kustomize/pkg/ifc
vendor/k8s.io/cli-runtime/pkg/kustomize/k8sdeps/configmapandsecret
vendor/k8s.io/cli-runtime/pkg/kustomize/k8sdeps/kunstruct
k8s.io/kubernetes/cmd/kubeadm/app/cmd/util
k8s.io/kubernetes/cmd/kubeadm/app/phases/kubeconfig
vendor/github.com/ghodss/yaml
vendor/sigs.k8s.io/kustomize/pkg/internal/error
vendor/sigs.k8s.io/kustomize/pkg/resid
vendor/sigs.k8s.io/kustomize/pkg/expansion
vendor/sigs.k8s.io/kustomize/pkg/transformers/config/defaultconfig
vendor/sigs.k8s.io/kustomize/pkg/resource
vendor/k8s.io/cli-runtime/pkg/kustomize/k8sdeps/validator
vendor/sigs.k8s.io/kustomize/pkg/transformers/config
vendor/sigs.k8s.io/kustomize/pkg/constants
vendor/sigs.k8s.io/kustomize/pkg/fs
k8s.io/kubernetes/cmd/kubeadm/app/util/apiclient
vendor/sigs.k8s.io/kustomize/pkg/resmap
vendor/github.com/pmezard/go-difflib/difflib
vendor/sigs.k8s.io/kustomize/pkg/git
vendor/sigs.k8s.io/kustomize/pkg/transformers
vendor/sigs.k8s.io/kustomize/pkg/loader
vendor/k8s.io/cli-runtime/pkg/kustomize/k8sdeps/transformer/hash
vendor/k8s.io/cli-runtime/pkg/kustomize/k8sdeps/transformer/patch
vendor/sigs.k8s.io/kustomize/pkg/ifc/transformer
vendor/sigs.k8s.io/kustomize/pkg/factory
vendor/sigs.k8s.io/kustomize/pkg/patch/transformer
k8s.io/kubernetes/cmd/kubeadm/app/discovery/file
vendor/k8s.io/cli-runtime/pkg/kustomize/k8sdeps/transformer
vendor/k8s.io/cli-runtime/pkg/kustomize/k8sdeps
vendor/sigs.k8s.io/kustomize/pkg/target
k8s.io/kubernetes/cmd/kubeadm/app/discovery/token
vendor/sigs.k8s.io/kustomize/pkg/commands/build
k8s.io/kubernetes/cmd/kubeadm/app/discovery/https
vendor/k8s.io/cli-runtime/pkg/kustomize
vendor/k8s.io/client-go/util/certificate
k8s.io/kubernetes/cmd/kubeadm/app/util/kustomize
k8s.io/kubernetes/cmd/kubeadm/app/util/staticpod
k8s.io/kubernetes/cmd/kubeadm/app/discovery
vendor/github.com/docker/docker/pkg/mount
vendor/github.com/google/cadvisor/devicemapper
vendor/github.com/google/cadvisor/utils
vendor/github.com/docker/docker/api/types/blkiodev
vendor/github.com/docker/docker/api/types/mount
vendor/github.com/docker/docker/api/types/strslice
k8s.io/kubernetes/cmd/kubeadm/app/phases/controlplane
vendor/github.com/docker/go-connections/nat
vendor/github.com/docker/docker/api/types/versions
vendor/github.com/docker/docker/api/types/filters
vendor/github.com/docker/docker/api/types/container
vendor/github.com/docker/distribution/registry/api/errcode
vendor/github.com/opencontainers/image-spec/specs-go
vendor/github.com/opencontainers/image-spec/specs-go/v1
vendor/github.com/docker/docker/errdefs
vendor/github.com/docker/docker/api/types/swarm/runtime
vendor/github.com/docker/docker/api/types/registry
vendor/github.com/mistifyio/go-zfs
vendor/github.com/docker/docker/api/types/network
vendor/github.com/google/cadvisor/info/v1
vendor/github.com/docker/docker/api/types/swarm
vendor/github.com/docker/docker/api/types
vendor/github.com/google/cadvisor/watcher
vendor/github.com/karrick/godirwalk
vendor/k8s.io/utils/inotify
vendor/github.com/gogo/protobuf/types
vendor/github.com/containerd/containerd/dialer
vendor/github.com/google/cadvisor/utils/docker
vendor/github.com/containerd/containerd/errdefs
vendor/github.com/google/cadvisor/fs
vendor/github.com/containerd/containerd/namespaces
vendor/github.com/checkpoint-restore/go-criu/rpc
vendor/github.com/google/cadvisor/container
vendor/github.com/containerd/console
vendor/github.com/google/cadvisor/container/common
k8s.io/kubernetes/cmd/kubeadm/app/componentconfigs
k8s.io/kubernetes/cmd/kubeadm/app/phases/bootstraptoken/node
k8s.io/kubernetes/cmd/kubeadm/app/phases/selfhosting
k8s.io/kubernetes/cmd/kubeadm/app/phases/copycerts
k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/validation
k8s.io/kubernetes/cmd/kubeadm/app/phases/kubelet
k8s.io/kubernetes/cmd/kubeadm/app/util/config/strict
k8s.io/kubernetes/cmd/kubeadm/app/phases/addons/dns
k8s.io/kubernetes/cmd/kubeadm/app/util/config
k8s.io/kubernetes/cmd/kubeadm/app/phases/addons/proxy
k8s.io/kubernetes/cmd/kubeadm/app/phases/bootstraptoken/clusterinfo
k8s.io/kubernetes/cmd/kubeadm/app/phases/markcontrolplane
k8s.io/kubernetes/cmd/kubeadm/app/phases/patchnode
k8s.io/kubernetes/cmd/kubeadm/app/cmd/alpha
k8s.io/kubernetes/cmd/kubeadm/app/util/etcd
k8s.io/kubernetes/cmd/kubeadm/app/phases/uploadconfig
k8s.io/kubernetes/cmd/kubeadm/app/util/dryrun
vendor/github.com/containerd/containerd/api/services/containers/v1
vendor/github.com/containerd/containerd/api/types
k8s.io/kubernetes/cmd/kubeadm/app/phases/etcd
vendor/github.com/containerd/containerd/api/types/task
vendor/github.com/containerd/containerd/api/services/version/v1
vendor/github.com/containerd/containerd/api/services/tasks/v1
vendor/github.com/containerd/containerd/containers
vendor/github.com/cyphar/filepath-securejoin
vendor/github.com/mrunalp/fileutils
vendor/github.com/opencontainers/runc/libcontainer/apparmor
vendor/github.com/opencontainers/runc/libcontainer/user
vendor/github.com/coreos/go-systemd/dbus
k8s.io/kubernetes/cmd/kubeadm/app/cmd/phases/init
k8s.io/kubernetes/cmd/kubeadm/app/cmd/phases/join
k8s.io/kubernetes/cmd/kubeadm/app/cmd/phases/reset
k8s.io/kubernetes/cmd/kubeadm/app/phases/upgrade
vendor/github.com/opencontainers/runc/libcontainer/system
k8s.io/kubernetes/cmd/kubeadm/app/cmd/phases/upgrade/node
vendor/github.com/opencontainers/runc/libcontainer/cgroups/fs
vendor/github.com/coreos/pkg/dlopen
vendor/github.com/opencontainers/runc/libcontainer/intelrdt
vendor/github.com/opencontainers/selinux/go-selinux
vendor/github.com/opencontainers/runc/libcontainer/configs/validate
vendor/github.com/opencontainers/runc/libcontainer/keys
vendor/github.com/opencontainers/runc/libcontainer/logs
vendor/github.com/opencontainers/runc/libcontainer/mount
vendor/github.com/opencontainers/runc/libcontainer/seccomp
vendor/github.com/opencontainers/runc/libcontainer/stacktrace
vendor/github.com/opencontainers/selinux/go-selinux/label
vendor/github.com/syndtr/gocapability/capability
vendor/github.com/docker/docker/api
vendor/github.com/docker/docker/api/types/events
vendor/github.com/docker/docker/api/types/image
vendor/github.com/docker/docker/api/types/time
k8s.io/kubernetes/cmd/kubeadm/app/cmd/upgrade
vendor/github.com/docker/docker/api/types/volume
vendor/golang.org/x/net/internal/socks
vendor/github.com/coreos/go-systemd/util
vendor/github.com/docker/go-connections/tlsconfig
vendor/github.com/mattn/go-shellwords
vendor/golang.org/x/net/proxy
vendor/github.com/docker/docker/pkg/parsers/operatingsystem
vendor/github.com/docker/go-connections/sockets
vendor/github.com/google/cadvisor/utils/cloudinfo
vendor/github.com/google/cadvisor/utils/sysfs
vendor/github.com/docker/docker/client
vendor/github.com/google/cadvisor/utils/sysinfo
k8s.io/kubernetes/cmd/kubeadm/app/cmd
vendor/github.com/google/cadvisor/machine
vendor/github.com/google/cadvisor/zfs
vendor/github.com/mindprince/gonvml
vendor/github.com/opencontainers/runc/libcontainer/cgroups/systemd
vendor/github.com/opencontainers/runc/libcontainer
vendor/github.com/google/cadvisor/storage
vendor/github.com/google/cadvisor/cache/memory
vendor/github.com/google/cadvisor/collector
vendor/github.com/google/cadvisor/events
vendor/github.com/google/cadvisor/info/v2
vendor/github.com/google/cadvisor/utils/cpuload/netlink
vendor/github.com/google/cadvisor/summary
vendor/github.com/google/cadvisor/utils/cpuload
vendor/github.com/euank/go-kmsg-parser/kmsgparser
vendor/github.com/google/cadvisor/version
vendor/github.com/google/cadvisor/utils/oomparser
vendor/k8s.io/utils/clock
vendor/github.com/Azure/azure-sdk-for-go/services/containerregistry/mgmt/2019-05-01/containerregistry
k8s.io/kubernetes/pkg/credentialprovider
k8s.io/kubernetes/pkg/credentialprovider/gcp
vendor/github.com/google/cadvisor/container/libcontainer
k8s.io/kubernetes/pkg/kubelet/apis/config/scheme
vendor/github.com/aws/aws-sdk-go/service/ecr
vendor/github.com/google/cadvisor/accelerators
vendor/github.com/google/cadvisor/container/containerd
vendor/github.com/google/cadvisor/container/docker
vendor/github.com/google/cadvisor/container/raw
vendor/k8s.io/cri-api/pkg/apis
vendor/github.com/google/cadvisor/manager
k8s.io/kubernetes/pkg/api/v1/resource
k8s.io/kubernetes/pkg/kubelet/apis/pluginregistration/v1
k8s.io/kubernetes/pkg/credentialprovider/aws
k8s.io/kubernetes/pkg/kubelet/apis/podresources/v1alpha1
k8s.io/kubernetes/pkg/kubelet/util
vendor/github.com/google/cadvisor/container/containerd/install
vendor/github.com/google/cadvisor/container/crio
vendor/github.com/google/cadvisor/container/docker/install
vendor/github.com/google/cadvisor/container/systemd
vendor/github.com/google/cadvisor/container/systemd/install
vendor/github.com/google/cadvisor/container/crio/install
k8s.io/kubernetes/pkg/kubelet/apis/podresources
vendor/github.com/google/cadvisor/utils/cloudinfo/aws
vendor/github.com/google/cadvisor/utils/cloudinfo/azure
vendor/github.com/google/cadvisor/utils/cloudinfo/gce
k8s.io/kubernetes/pkg/kubelet/metrics
k8s.io/kubernetes/pkg/kubelet/cadvisor
k8s.io/kubernetes/pkg/kubelet/cloudresource
k8s.io/kubernetes/pkg/kubelet/cm/cpuset
k8s.io/kubernetes/pkg/kubelet/certificate
k8s.io/kubernetes/pkg/credentialprovider/azure
k8s.io/kubernetes/pkg/kubelet/cm/cpumanager/state
k8s.io/kubernetes/cmd/kubelet/app/options
k8s.io/kubernetes/pkg/kubelet/cm/cpumanager/topology
k8s.io/kubernetes/pkg/kubelet/cm/topologymanager/socketmask
k8s.io/kubernetes/pkg/kubelet/lifecycle
k8s.io/kubernetes/pkg/kubelet/util/manager
k8s.io/kubernetes/pkg/util/pod
k8s.io/kubernetes/pkg/kubelet/apis/deviceplugin/v1beta1
k8s.io/kubernetes/pkg/kubelet/configmap
k8s.io/kubernetes/pkg/kubelet/cm/topologymanager
k8s.io/kubernetes/pkg/kubelet/secret
k8s.io/kubernetes/pkg/kubelet/cm/devicemanager/checkpoint
k8s.io/kubernetes/pkg/kubelet/pluginmanager/cache
k8s.io/kubernetes/pkg/util/selinux
k8s.io/kubernetes/pkg/kubelet/eviction/api
k8s.io/kubernetes/pkg/kubelet/apis/stats/v1alpha1
k8s.io/kubernetes/pkg/util/procfs
k8s.io/kubernetes/pkg/kubelet/cm/devicemanager
k8s.io/kubernetes/pkg/kubelet/stats/pidlimit
vendor/github.com/armon/circbuf
vendor/github.com/morikuni/aec
vendor/github.com/docker/docker/pkg/stdcopy
k8s.io/kubernetes/pkg/kubelet/pod
k8s.io/kubernetes/pkg/kubelet/dockershim/metrics
vendor/github.com/docker/docker/pkg/jsonmessage
k8s.io/kubernetes/pkg/kubelet/dockershim/network/hostport
k8s.io/kubernetes/pkg/kubelet/dockershim/libdocker
k8s.io/kubernetes/pkg/kubelet/dockershim/network/metrics
vendor/github.com/containernetworking/cni/pkg/types
k8s.io/kubernetes/pkg/kubelet/dockershim/network
vendor/github.com/containernetworking/cni/pkg/types/020
vendor/github.com/containernetworking/cni/pkg/types/current
k8s.io/kubernetes/pkg/kubelet/status
k8s.io/kubernetes/pkg/util/bandwidth
k8s.io/kubernetes/pkg/util/ebtables
vendor/github.com/containernetworking/cni/pkg/version
k8s.io/kubernetes/pkg/credentialprovider/secrets
vendor/github.com/containernetworking/cni/pkg/invoke
k8s.io/kubernetes/pkg/kubelet/util/sliceutils
vendor/github.com/docker/docker/daemon/logger/jsonfilelog/jsonlog
k8s.io/kubernetes/pkg/util/tail
vendor/github.com/containernetworking/cni/libcni
k8s.io/kubernetes/pkg/kubelet/kuberuntime/logs
k8s.io/kubernetes/pkg/kubelet/images
k8s.io/kubernetes/pkg/kubelet/dockershim/network/cni
k8s.io/kubernetes/pkg/kubelet/dockershim/network/kubenet
k8s.io/kubernetes/pkg/kubelet/prober/results
k8s.io/kubernetes/pkg/kubelet/cm/cpumanager
k8s.io/kubernetes/pkg/kubelet/runtimeclass
k8s.io/kubernetes/pkg/kubelet/util/cache
k8s.io/kubernetes/pkg/kubelet/util/logreduction
k8s.io/kubernetes/pkg/kubelet/leaky
k8s.io/kubernetes/pkg/kubelet/server/portforward
k8s.io/kubernetes/pkg/kubelet/server/remotecommand
k8s.io/kubernetes/pkg/kubelet/util/ioutils
k8s.io/kubernetes/pkg/kubelet/cm
k8s.io/kubernetes/pkg/kubelet/envvars
k8s.io/kubernetes/pkg/kubelet/server/streaming
k8s.io/kubernetes/pkg/kubelet/kubeletconfig/util/log
k8s.io/kubernetes/pkg/kubelet/kubeletconfig/status
k8s.io/kubernetes/pkg/kubelet/kubeletconfig/util/codec
k8s.io/kubernetes/pkg/kubelet/kubeletconfig/util/files
k8s.io/kubernetes/pkg/kubelet/kubeletconfig/configfiles
k8s.io/kubernetes/pkg/kubelet/kubeletconfig/util/panic
k8s.io/kubernetes/pkg/kubelet/logs
k8s.io/kubernetes/pkg/kubelet/mountpod
k8s.io/kubernetes/pkg/kubelet/network/dns
k8s.io/kubernetes/pkg/kubelet/kubeletconfig/checkpoint
k8s.io/kubernetes/pkg/kubelet/nodelease
k8s.io/kubernetes/pkg/kubelet/oom
k8s.io/kubernetes/pkg/kubelet/dockershim/cm
k8s.io/kubernetes/pkg/kubelet/kuberuntime
k8s.io/kubernetes/pkg/kubelet/server/stats
k8s.io/kubernetes/pkg/kubelet/nodestatus
k8s.io/kubernetes/pkg/kubelet/kubeletconfig/checkpoint/store
k8s.io/kubernetes/pkg/kubelet/eviction
k8s.io/kubernetes/pkg/kubelet/kubeletconfig
k8s.io/kubernetes/pkg/kubelet/metrics/collectors
k8s.io/kubernetes/pkg/kubelet/pleg
k8s.io/kubernetes/pkg/kubelet/dockershim
k8s.io/kubernetes/pkg/kubelet/pluginmanager/metrics
k8s.io/kubernetes/pkg/kubelet/pluginmanager/operationexecutor
k8s.io/kubernetes/pkg/kubelet/pluginmanager/pluginwatcher/example_plugin_apis/v1beta1
k8s.io/kubernetes/pkg/kubelet/pluginmanager/pluginwatcher/example_plugin_apis/v1beta2
k8s.io/kubernetes/pkg/kubelet/pluginmanager/reconciler
k8s.io/kubernetes/pkg/kubelet/preemption
k8s.io/kubernetes/pkg/probe/exec
k8s.io/kubernetes/pkg/kubelet/pluginmanager/pluginwatcher
k8s.io/kubernetes/pkg/probe/tcp
k8s.io/kubernetes/pkg/kubelet/prober
k8s.io/kubernetes/pkg/kubelet/remote
k8s.io/kubernetes/pkg/kubelet/pluginmanager
vendor/github.com/google/cadvisor/metrics
k8s.io/kubernetes/pkg/apis/core/v1/validation
k8s.io/kubernetes/pkg/kubelet/dockershim/remote
k8s.io/kubernetes/pkg/kubelet/apis/resourcemetrics/v1alpha1
k8s.io/kubernetes/pkg/kubelet/server/metrics
k8s.io/kubernetes/pkg/kubelet/stats
k8s.io/kubernetes/pkg/kubelet/sysctl
k8s.io/kubernetes/pkg/kubelet/token
k8s.io/kubernetes/pkg/kubelet/server
k8s.io/kubernetes/pkg/kubelet/util/queue
k8s.io/kubernetes/pkg/kubelet/volumemanager/cache
k8s.io/kubernetes/pkg/util/removeall
k8s.io/kubernetes/pkg/volume/util/exec
k8s.io/kubernetes/pkg/kubelet/certificate/bootstrap
k8s.io/kubernetes/pkg/util/flock
k8s.io/kubernetes/pkg/util/rlimit
k8s.io/kubernetes/pkg/volume/cephfs
k8s.io/kubernetes/pkg/volume/configmap
k8s.io/kubernetes/pkg/volume/downwardapi
k8s.io/kubernetes/pkg/kubelet/volumemanager/metrics
k8s.io/kubernetes/pkg/kubelet/volumemanager/populator
k8s.io/kubernetes/pkg/kubelet/volumemanager/reconciler
k8s.io/kubernetes/pkg/volume/emptydir
k8s.io/kubernetes/pkg/volume/git_repo
k8s.io/kubernetes/pkg/volume/secret
k8s.io/kubernetes/pkg/kubelet/volumemanager
vendor/k8s.io/cli-runtime/pkg/printers
vendor/golang.org/x/text/encoding/internal/identifier
vendor/golang.org/x/text/encoding
vendor/golang.org/x/text/encoding/internal
vendor/golang.org/x/text/internal/utf8internal
vendor/golang.org/x/text/runes
vendor/k8s.io/apimachinery/pkg/apis/meta/v1/unstructured/unstructuredscheme
vendor/golang.org/x/text/encoding/unicode
vendor/github.com/gregjones/httpcache
k8s.io/kubernetes/pkg/volume/projected
vendor/k8s.io/cli-runtime/pkg/resource
k8s.io/kubernetes/pkg/kubelet
vendor/github.com/google/btree
vendor/github.com/peterbourgon/diskv
vendor/k8s.io/kubectl/pkg/util/openapi
vendor/github.com/gregjones/httpcache/diskcache
vendor/k8s.io/kube-openapi/pkg/util/proto/validation
vendor/k8s.io/client-go/discovery/cached/disk
vendor/github.com/MakeNowJust/heredoc
vendor/github.com/russross/blackfriday
vendor/k8s.io/kubectl/pkg/util/openapi/validation
vendor/github.com/mitchellh/go-wordwrap
vendor/k8s.io/kubectl/pkg/util/interrupt
vendor/k8s.io/cli-runtime/pkg/genericclioptions
vendor/k8s.io/kubectl/pkg/util/term
vendor/github.com/exponent-io/jsonpath
vendor/k8s.io/kubectl/pkg/validation
vendor/k8s.io/kubectl/pkg/util/templates
vendor/k8s.io/kubectl/pkg/version
vendor/github.com/chai2010/gettext-go/gettext/mo
vendor/github.com/chai2010/gettext-go/gettext/plural
vendor/github.com/chai2010/gettext-go/gettext/po
vendor/k8s.io/kubectl/pkg/generated
vendor/k8s.io/kubectl/pkg/cmd/util
vendor/github.com/chai2010/gettext-go/gettext
vendor/k8s.io/kubectl/pkg/apps
vendor/github.com/fatih/camelcase
vendor/k8s.io/kubectl/pkg/util/i18n
vendor/k8s.io/kubectl/pkg/describe
vendor/k8s.io/kubectl/pkg/util/certificate
vendor/k8s.io/kubectl/pkg/util/deployment
vendor/k8s.io/kubectl/pkg/util/event
vendor/k8s.io/kubectl/pkg/util/fieldpath
vendor/k8s.io/kubectl/pkg/util/qos
vendor/k8s.io/kubectl/pkg/util/rbac
vendor/k8s.io/kubectl/pkg/util/resource
vendor/k8s.io/kubectl/pkg/util/slice
vendor/k8s.io/kubectl/pkg/util/storage
vendor/k8s.io/kubectl/pkg/util/podutils
vendor/k8s.io/kubectl/pkg/describe/versioned
vendor/k8s.io/kubectl/pkg/util/printers
vendor/github.com/jonboulle/clockwork
vendor/k8s.io/apimachinery/pkg/util/jsonmergepatch
vendor/k8s.io/kubectl/pkg/rawhttp
vendor/k8s.io/kubectl/pkg/cmd/util/editor/crlf
vendor/k8s.io/kubectl/pkg/util
vendor/k8s.io/kubectl/pkg/generate
k8s.io/kubernetes/cmd/kubelet/app
vendor/k8s.io/kubectl/pkg/util/hash
vendor/k8s.io/kubectl/pkg/generate/versioned
vendor/k8s.io/kubectl/pkg/cmd
vendor/k8s.io/kubectl/pkg/cmd/apiresources
vendor/k8s.io/kubectl/pkg/cmd/wait
vendor/k8s.io/kubectl/pkg/cmd/util/editor
vendor/k8s.io/kubectl/pkg/cmd/delete
vendor/k8s.io/kubectl/pkg/cmd/autoscale
vendor/k8s.io/kubectl/pkg/cmd/apply
vendor/k8s.io/kubectl/pkg/cmd/certificates
vendor/github.com/daviddengcn/go-colortext
vendor/k8s.io/kubectl/pkg/cmd/completion
vendor/k8s.io/kubectl/pkg/cmd/config
vendor/k8s.io/kubectl/pkg/cmd/create
vendor/k8s.io/kubectl/pkg/polymorphichelpers
vendor/k8s.io/kubectl/pkg/cmd/describe
vendor/k8s.io/kubectl/pkg/drain
vendor/k8s.io/kubectl/pkg/cmd/edit
vendor/k8s.io/kubectl/pkg/cmd/diff
vendor/k8s.io/kubectl/pkg/cmd/annotate
vendor/k8s.io/kubectl/pkg/cmd/exec
vendor/k8s.io/kubectl/pkg/cmd/clusterinfo
vendor/k8s.io/kubectl/pkg/explain
vendor/k8s.io/kubectl/pkg/cmd/explain
vendor/k8s.io/kubectl/pkg/cmd/attach
vendor/k8s.io/kubectl/pkg/cmd/expose
vendor/k8s.io/kubectl/pkg/cmd/kustomize
vendor/k8s.io/kubectl/pkg/cmd/label
vendor/k8s.io/kubectl/pkg/cmd/logs
vendor/k8s.io/kubectl/pkg/cmd/options
vendor/k8s.io/kubectl/pkg/cmd/drain
vendor/k8s.io/kubectl/pkg/cmd/patch
vendor/k8s.io/kubectl/pkg/cmd/plugin
vendor/k8s.io/client-go/tools/portforward
vendor/k8s.io/kubectl/pkg/proxy
vendor/k8s.io/kubectl/pkg/cmd/replace
vendor/k8s.io/kubectl/pkg/cmd/proxy
vendor/k8s.io/kubectl/pkg/scale
vendor/k8s.io/kubectl/pkg/cmd/portforward
vendor/k8s.io/kubectl/pkg/cmd/rollingupdate
vendor/k8s.io/kubectl/pkg/cmd/set/env
vendor/k8s.io/kubectl/pkg/cmd/run
vendor/k8s.io/kubectl/pkg/cmd/scale
vendor/k8s.io/kubectl/pkg/cmd/set
vendor/k8s.io/kubectl/pkg/cmd/taint
vendor/k8s.io/kubectl/pkg/metricsutil
vendor/k8s.io/metrics/pkg/client/clientset/versioned/typed/metrics/v1alpha1
vendor/k8s.io/kubectl/pkg/cmd/version
vendor/k8s.io/metrics/pkg/client/clientset/versioned
vendor/k8s.io/kubectl/pkg/cmd/rollout
vendor/k8s.io/kubectl/pkg/cmd/top
k8s.io/kubernetes/pkg/kubectl/cmd/auth
k8s.io/kubernetes/pkg/kubectl/cmd/convert
k8s.io/kubernetes/pkg/kubectl/cmd/cp
vendor/vbom.ml/util/sortorder
k8s.io/kubernetes/pkg/kubectl/cmd/get
k8s.io/kubernetes/pkg/kubectl/cmd
github.com/kubernetes-sigs/reference-docs/gen-compdocs/generators
github.com/kubernetes-sigs/reference-docs/gen-compdocs
rm -rf /tmp/update_docs/src/github.com/kubernetes-sigs/reference-docs/gen-compdocs/build
mkdir -p gen-compdocs/build
go run gen-compdocs/main.go gen-compdocs/build kube-apiserver
go run gen-compdocs/main.go gen-compdocs/build kube-controller-manager
go run gen-compdocs/main.go gen-compdocs/build cloud-controller-manager
go run gen-compdocs/main.go gen-compdocs/build kube-scheduler
go run gen-compdocs/main.go gen-compdocs/build kubelet
go run gen-compdocs/main.go gen-compdocs/build kube-proxy
go run gen-compdocs/main.go gen-compdocs/build kubeadm
go run gen-compdocs/main.go gen-compdocs/build kubectl
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/command-line-tools-reference/cloud-controller-manager.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/command-line-tools-reference/kube-apiserver.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/command-line-tools-reference/kube-controller-manager.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/command-line-tools-reference/kube-proxy.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/command-line-tools-reference/kube-scheduler.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/kubectl/kubectl.md
Processing kubectl links
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_control-plane_scheduler.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_kubelet-start.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_upgrade_apply.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_etcd-server.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-join_all.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_etcd-healthcheck-client.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_etcd-peer.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_upgrade.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_kubelet_config.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-prepare_download-certs.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_kubeconfig_kubelet.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_etcd_local.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_apiserver.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_kubeconfig_admin.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_addon_all.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_certificate-key.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_kubeconfig_user.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_kubeconfig.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-prepare_kubeconfig.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_version.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_kubeconfig_controller-manager.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-join_mark-control-plane.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_front-proxy-client.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_addon_kube-proxy.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_scheduler.conf.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_upload-certs.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_controller-manager.conf.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_config_print.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_addon_coredns.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_bootstrap-token.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_selfhosting_pivot.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_token_create.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-prepare_certs.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_all.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_config_images.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_preflight.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_front-proxy-ca.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_etcd-server.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_addon.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_upgrade_node_phase.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_upgrade_node_phase_control-plane.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_control-plane_all.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_upload-config_kubelet.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_config_view.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_control-plane.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_etcd.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_reset_phase_remove-etcd-member.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_front-proxy-client.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_etcd-ca.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_completion.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_token_delete.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_config_images_pull.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_reset_phase.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-prepare_control-plane.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_token_list.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_kubeconfig_scheduler.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_upload-config_kubeadm.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_admin.conf.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_check-expiration.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-join_etcd.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_kubelet.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_reset.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_apiserver-kubelet-client.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-join_update-status.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_ca.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_token_generate.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_reset_phase_cleanup-node.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_config_migrate.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-prepare_all.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_kubelet-start.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_kubelet_config_enable-dynamic.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_upgrade_node_phase_kubelet-config.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_reset_phase_update-cluster-status.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_config.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_apiserver-kubelet-client.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_config_print_init-defaults.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_sa.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-prepare.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_apiserver-etcd-client.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_upload-config_all.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_config_print_join-defaults.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_kubeconfig_all.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_upload-config.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_all.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_apiserver.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_upgrade_plan.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_certs_renew_apiserver-etcd-client.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_control-plane_apiserver.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_selfhosting.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_mark-control-plane.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_alpha_kubelet_config_download.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_etcd-healthcheck-client.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_config_images_list.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_reset_phase_preflight.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase_control-plane-join.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_preflight.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_control-plane_controller-manager.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_certs_etcd-peer.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init_phase_kubeconfig.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_init.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_upgrade_diff.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_upgrade_node.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_join_phase.md
Writing doc: /home/aimee/Dev/git/github.com/k8s-website-master/website/content/en/docs/reference/setup-tools/kubeadm/generated/kubeadm_token.md
Completed docs update. Now run the following command to commit:

 git add .
 git commit -m <comment>
 git push

(k8sUpdateImportedDocsPy27) aimee@aimee-lemur:~/Dev/git/github.com/k8s-website-master/website/update-imported-docs$ git status
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   ../content/en/docs/reference/command-line-tools-reference/kube-apiserver.md
	modified:   ../content/en/docs/reference/kubectl/kubectl.md

no changes added to commit (use "git add" and/or "git commit -a")
```



