# TL;DR
need to cherry pick English-language files from PR 16531 to 1.16 - 1.12
Korean language file content/ko/docs/tutorials/clusters/apparmor.md was added in 1.14


# Clone single branches 1.12-master


```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.12$ git glone --single-branch --branch release-1.12 https://github.com/kubernetes/website.git
git: 'glone' is not a git command. See 'git --help'.

The most similar command is
	clone
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.12$ git clone --single-branch --branch release-1.12 https://github.com/kubernetes/website.git
Cloning into 'website'...
remote: Enumerating objects: 32, done.
remote: Counting objects: 100% (32/32), done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 91098 (delta 13), reused 30 (delta 13), pack-reused 91066
Receiving objects: 100% (91098/91098), 130.40 MiB | 24.87 MiB/s, done.
Resolving deltas: 100% (58485/58485), done.
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.12$ cd ../1.13
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.13$ git clone --single-branch --branch release-1.13 https://github.com/kubernetes/website.git
Cloning into 'website'...
remote: Enumerating objects: 36, done.
remote: Counting objects: 100% (36/36), done.
remote: Compressing objects: 100% (36/36), done.
remote: Total 92045 (delta 1), reused 18 (delta 0), pack-reused 92009
Receiving objects: 100% (92045/92045), 184.32 MiB | 27.04 MiB/s, done.
Resolving deltas: 100% (58883/58883), done.
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.13$ cd ../1.14
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.14$ git clone --single-branch --branch release-1.14 https://github.com/kubernetes/website.git
fatal: destination path 'website' already exists and is not an empty directory.
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.14$ git clone --single-branch --branch release-1.14 https://github.com/kubernetes/website.git
Cloning into 'website'...
remote: Enumerating objects: 24, done.
remote: Counting objects: 100% (24/24), done.
remote: Compressing objects: 100% (24/24), done.
remote: Total 100451 (delta 0), reused 21 (delta 0), pack-reused 100427
Receiving objects: 100% (100451/100451), 212.31 MiB | 26.78 MiB/s, done.
Resolving deltas: 100% (64312/64312), done.
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.14$ cd ../1.15
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.15$ git clone --single-branch --branch release-1.15 https://github.com/kubernetes/website.git
Cloning into 'website'...
remote: Enumerating objects: 36, done.
remote: Counting objects: 100% (36/36), done.
remote: Compressing objects: 100% (33/33), done.
remote: Total 103876 (delta 7), reused 25 (delta 3), pack-reused 103840
Receiving objects: 100% (103876/103876), 215.92 MiB | 27.47 MiB/s, done.
Resolving deltas: 100% (66991/66991), done.
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.15$ cd ../1.16
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.16$ git clone --single-branch --branch release-1.16 https://github.com/kubernetes/website.git
Cloning into 'website'...
remote: Enumerating objects: 24, done.
remote: Counting objects: 100% (24/24), done.
remote: Compressing objects: 100% (24/24), done.
remote: Total 104690 (delta 0), reused 24 (delta 0), pack-reused 104666
Receiving objects: 100% (104690/104690), 230.83 MiB | 27.84 MiB/s, done.
Resolving deltas: 100% (67682/67682), done.
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.16$ cd ../master
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/master$ git clone --single-branch --branch master https://github.com/kubernetes/website.git
Cloning into 'website'...
remote: Enumerating objects: 24, done.
remote: Counting objects: 100% (24/24), done.
remote: Compressing objects: 100% (24/24), done.
remote: Total 105518 (delta 0), reused 24 (delta 0), pack-reused 105494
Receiving objects: 100% (105518/105518), 231.76 MiB | 27.87 MiB/s, done.
Resolving deltas: 100% (68298/68298), done.
```

# 1.12

```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.12/website$ hugo serve
Building sites … WARN 2019/10/01 11:25:43 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.12/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 11:25:43 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.12/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
Total in 1309 ms
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.12/website/content/zh/docs/reference/setup-tools/kubeadm/generated/README.md:2:1": invalid YAML delimiter

```

# 1.13
the error is at timeout trying to access a tweet; if I increase the timeout, the error goes away; most likely no error on server
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.13/website$ hugo serve
Building sites … WARN 2019/10/01 11:35:54 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.13/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 11:35:54 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.13/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 11:35:55 Page's .Dir is deprecated and will be removed in a future release. Use .File.Dir.
Total in 6768 ms
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.13/website/content/en/blog/_posts/2018-10-18-tips-for-first-kubecon-presentation-part-1.md:1:1": timed out initializing value. This is most likely a circular loop in a shortcode
```

# 1.14
need to cherry pick tengqm's PR
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.14/website$ hugo serve
Building sites … WARN 2019/10/01 11:37:13 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.14/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 11:37:13 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.14/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 11:37:13 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.14/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
Total in 2516 ms
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.14/website/content/en/docs/tutorials/clusters/apparmor.md:126:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.14/website/layouts/shortcodes/code.html:14:16": execute of template failed: template: shortcodes/code.html:14:16: executing "shortcodes/code.html" at <readFile $filename>: error calling readFile: runtime error: invalid memory address or nil pointer dereference
```

# 1.15
need to cherry pick tengqm's PR
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.15/website$ hugo serve
Building sites … WARN 2019/10/01 11:39:14 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.15/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 11:39:14 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.15/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
Total in 2931 ms
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.15/website/content/en/docs/tutorials/clusters/apparmor.md:126:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.15/website/layouts/shortcodes/code.html:14:16": execute of template failed: template: shortcodes/code.html:14:16: executing "shortcodes/code.html" at <readFile $filename>: error calling readFile: runtime error: invalid memory address or nil pointer dereference
```

# 1.16
need to cherry pick tengqm's PR
```shell
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/1.16/website$ hugo serve
Building sites … WARN 2019/10/01 11:40:54 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.16/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 11:40:54 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.16/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 11:40:54 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.16/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
Total in 2781 ms
Error: Error building site: "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.16/website/content/en/docs/tutorials/clusters/apparmor.md:126:1": failed to render shortcode "capture": failed to process shortcode: "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/1.16/website/layouts/shortcodes/code.html:14:16": execute of template failed: template: shortcodes/code.html:14:16: executing "shortcodes/code.html" at <readFile $filename>: error calling readFile: runtime error: invalid memory address or nil pointer dereference
```

# master
aimee@aimee-lemur:~/Dev/git/github.com/aimeeu/k8s/old-versions/master/website$ hugo serve
Building sites … WARN 2019/10/01 11:24:52 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/master/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 11:24:52 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/master/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.
WARN 2019/10/01 11:24:52 Content directory "/home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/master/website/content/en/docs/reference/kubernetes-api" have both index.* and _index.* files, pick one.

                   |  EN  |  ZH  |  KO  |  JA  |  FR  |  DE  |  ES  |  PT  |  ID   
+------------------+------+------+------+------+------+------+------+------+------+
  Pages            | 1071 |  241 |  274 |  137 |  212 |  103 |  144 |   25 |   91  
  Paginator pages  |  297 |    7 |    0 |    0 |    0 |    0 |    0 |    0 |    0  
  Non-page files   |  444 |  201 |  156 |  215 |  113 |   72 |   82 |   12 |   48  
  Static files     | 1013 | 1013 | 1013 | 1013 | 1013 | 1013 | 1013 | 1013 | 1013  
  Processed images |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0  
  Aliases          |    5 |    1 |    0 |    0 |    1 |    1 |    1 |    1 |    0  
  Sitemaps         |    2 |    1 |    1 |    1 |    1 |    1 |    1 |    1 |    1  
  Cleaned          |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0 |    0  

Total in 8658 ms
Watching for changes in /home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/master/website/{archetypes,assets,content,data,i18n,layouts,static}
Watching for config changes in /home/aimee/Dev/git/github.com/aimeeu/k8s/old-versions/master/website/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```
