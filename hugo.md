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

## 0.54.0 extended

```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo version
Hugo Static Site Generator v0.54.0-B1A82C61A/extended linux/amd64 BuildDate: 2019-02-01T10:04:38Z
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo serve

                   |  EN  |  ZH  |  KO  |  JA  |  FR  |  DE  |  ES  |  PT  |  ID   
+------------------+------+------+------+------+------+------+------+------+------+
  Pages            | 4267 |  342 | 2064 |  526 | 1688 |  389 |  924 |   26 |  317  
  Paginator pages  |  296 |    7 |    0 |    0 |    0 |    0 |    0 |    0 |    0  
  Non-page files   |  829 |  679 |  770 |  627 |  736 |  719 |  736 |  609 |  630  
  Static files     | 1012 | 1012 | 1012 | 1012 | 1012 | 1012 | 1012 | 1012 | 1012  
  Processed images |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0  
  Aliases          |    5 |    2 |    1 |    1 |    2 |    2 |    2 |    2 |    1  
  Sitemaps         |    2 |    1 |    1 |    1 |    1 |    1 |    1 |    1 |    1  
  Cleaned          |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0  

Total in 9900 ms
Watching for changes in /home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/{assets,content,data,i18n,layouts,static}
Watching for config changes in /home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

## 0.55.6 extended

```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo version
Hugo Static Site Generator v0.55.6-A5D4C82D2/extended linux/amd64 BuildDate: 2019-05-18T08:08:34Z
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo serve

                   |  EN  |  ZH  |  KO  |  JA  |  FR  |  DE  |  ES  |  PT  |  ID   
+------------------+------+------+------+------+------+------+------+------+------+
  Pages            | 1069 |  212 |  270 |  136 |  206 |  103 |  144 |   26 |   83  
  Paginator pages  |  296 |    7 |    0 |    0 |    0 |    0 |    0 |    0 |    0  
  Non-page files   |  510 |  116 |  209 |  221 |  172 |  124 |  143 |   12 |   52  
  Static files     | 1012 | 1012 | 1012 | 1012 | 1012 | 1012 | 1012 | 1012 | 1012  
  Processed images |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0  
  Aliases          |    5 |    1 |    0 |    0 |    1 |    1 |    1 |    1 |    0  
  Sitemaps         |    2 |    1 |    1 |    1 |    1 |    1 |    1 |    1 |    1  
  Cleaned          |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0  

Total in 8398 ms
Watching for changes in /home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/{assets,content,data,i18n,layouts,static}
Watching for config changes in /home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

## 0.56.0+ extended

```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo version
Hugo Static Site Generator v0.56.3-F637A1EA/extended linux/amd64 BuildDate: 2019-07-31T12:54:46Z
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo serve
Building sites … WARN 2019/09/24 12:37:26 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/09/24 12:37:26 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/09/24 12:37:26 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
Total in 2710 ms
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/tutorials/clusters/apparmor.md:126:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/layouts/shortcodes/code.html:14:16": execute of template failed: template: shortcodes/code.html:14:16: executing "shortcodes/code.html" at <readFile $filename>: error calling readFile: runtime error: invalid memory address or nil pointer dereference
```

Changed apparmor.md line 181 to use ```codenew``` shortcode instead of ```code``` -> new error:
```shell
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/tutorials/clusters/apparmor.md:126:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/layouts/shortcodes/codenew.html:14:16": execute of template failed: template: shortcodes/codenew.html:14:16: executing "shortcodes/codenew.html" at <readFile $filename>: error calling readFile: file "content/en/examples/deny-write.profile" does not exist
```

deny-write.profile is not in this path:```content/en/examples/```
deny-write.profile is in content/en/tutorials/clusters
codenew.html shortcode explicitly explicitly changes the filename: ```{{ $filename := printf "/content/%s/examples/%s" .Page.Lang $file | safeURL }}```

Using code.html, put path with file in apparmor.md line 181: ```{{< code language="text" file="en/docs/tutorials/clusters/deny-write.profile" >}}```
error calling readFile: file "docs/tutorials/clusters/en/docs/tutorials/clusters/deny-write.profile" does not exist


```{{< code language="text" file="/tutorials/clusters/deny-write.profile" >}}```
error calling readFile: file "docs/tutorials/clusters/tutorials/clusters/deny-write.profile" does not exist

```{{< code language="text" file="/deny-write.profile" >}}```
shortcodes/code.html:14:16: executing "shortcodes/code.html" at <readFile $filename>: error calling readFile: runtime error: invalid memory address or nil pointer dereference

--------------------
In examples directory, create tutorials/clusters; copy deny-write.profile to new directory.

Change apparmor.md L181 to: ```{{< codenew language="text" file="deny-write.profile" >}}```

```
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/tutorials/clusters/apparmor.md:126:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/layouts/shortcodes/codenew.html:14:16": execute of template failed: template: shortcodes/codenew.html:14:16: executing "shortcodes/codenew.html" at <readFile $filename>: error calling readFile: file "content/en/examples/deny-write.profile" does not exist
```

```{{< codenew file="/tutorials/clusters/deny-write.profile" >}}```
```shell
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/ko/docs/tutorials/clusters/apparmor.md:125:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/layouts/shortcodes/code.html:14:16": execute of template failed: template: shortcodes/code.html:14:16: executing "shortcodes/code.html" at <readFile $filename>: error calling readFile: runtime error: invalid memory address or nil pointer dereference
```

{{< codenew file="tutorials/clusters/deny-write.txt" >}}


Removed all shortcodes from apparmor.md and still the error!
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/ko/docs/tutorials/clusters/apparmor.md:125:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/layouts/shortcodes/code.html:14:16": execute of template failed: template: shortcodes/code.html:14:16: executing "shortcodes/code.html" at <readFile $filename>: error calling readFile: runtime error: invalid memory address or nil pointer dereference

***************************************************************************************************
This compile error appears starting with Hugo v0.56.0, which had a lot of changes to the codebase.

In the Kubernetes website code, neither the _code_ nor _codenew_ shortcodes could find _deny-write.profile_, which was in the same directory as apparmor.md (I tried several different things). To compile without error in Hugo v0.56+, I created a new directory:
 ```content/en/examples/tutorials/clusters```

Then moved _deny-write.profile_ from  ```content/en/docs/tutorials/clusters``` to the new directory since _codenew_ looks for files in _examples_. 

Finally I changed _content/en/docs/tutorials/clusters/apparmor.md_ line 181 to use the _codenew_ shortcode:  
```{{< codenew language="text" file="tutorials/clusters/deny-write.profile" >}}```
*******************************************************************************************************


## 0.57.2 extended

```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo version
Hugo Static Site Generator v0.57.2-A849CB2D/extended linux/amd64 BuildDate: 2019-08-17T17:57:54Z
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo serve
Building sites … WARN 2019/09/24 12:21:46 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/09/24 12:21:46 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/09/24 12:21:46 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
Total in 3043 ms
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/tutorials/clusters/apparmor.md:126:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/layouts/shortcodes/code.html:14:16": execute of template failed: template: shortcodes/code.html:14:16: executing "shortcodes/code.html" at <readFile $filename>: error calling readFile: runtime error: invalid memory address or nil pointer dereference
```

## 0.58.3 extended (latest)

```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo version
Hugo Static Site Generator v0.58.3-4AAC02D4/extended linux/amd64 BuildDate: 2019-09-19T15:34:54Z

aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/sigdocs/website$ hugo serve
Building sites … WARN 2019/09/24 12:14:14 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/09/24 12:14:14 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/09/24 12:14:14 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
Total in 2137 ms
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/content/en/docs/tutorials/clusters/apparmor.md:126:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/sigdocs/website/layouts/shortcodes/code.html:14:16": execute of template failed: template: shortcodes/code.html:14:16: executing "shortcodes/code.html" at <readFile $filename>: error calling readFile: runtime error: invalid memory address or nil pointer dereference
```

docs/tutorials/clusters/apparmor.md: replace 
