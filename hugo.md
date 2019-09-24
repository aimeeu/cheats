# My laptop 
- Ubuntu 18 desktop
- go version go1.13 linux/amd64

# Installation

- download extended .deb from https://github.com/gohugoio/hugo/releases
- install with GDEBI
- requires go 1.11 or greater

# Testing: Hugo with kubernetes/website master 1.16 cloned 9/23/2019
This is in response to Slack thread https://kubernetes.slack.com/archives/C1J0BPD2M/p1569270828063400

## 0.53
Default version; compiles and runs without issue

## 0.58.3 extended (latest)

```
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo version
Hugo Static Site Generator v0.58.3-4AAC02D4/extended linux/amd64 BuildDate: 2019-09-19T15:34:54Z

aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo serve
Building sites … WARN 2019/09/24 12:14:14 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/09/24 12:14:14 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/09/24 12:14:14 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
Total in 2137 ms
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/tutorials/clusters/apparmor.md:126:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/layouts/shortcodes/code.html:14:16": execute of template failed: template: shortcodes/code.html:14:16: executing "shortcodes/code.html" at <readFile $filename>: error calling readFile: runtime error: invalid memory address or nil pointer dereference
```

