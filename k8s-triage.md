# Triage cheats

https://kubernetes.io/docs/contribute/intermediate/#triage-and-categorize-issues
https://github.com/kubernetes/community/blob/master/contributors/guide/issue-triage.md
https://prow.k8s.io/command-help

## Searching through code
```
jaypipes@udb42383a8e5155:~/src/k8s.io/website/content/en$ ack -l frontend | wc -l
70
jaypipes@udb42383a8e5155:~/src/k8s.io/website/content/en$ ack -l "front[ -]end" | wc -l
15
```

## Labels
### Add
/triage needs-information
/priority backlog
/kind feature

### Remove
/remove-triage needs-informtion


## Support issues

Would you be willing to put the changes in as a pull request? If you're not 100% confident about the technical accuracy of changes, mention it in the PR description, and possibly ask for tech review.
Thanks for your feedback!

Support:
```
This issue sounds more like a request for support and less
like an issue specifically for docs. I encourage you to bring
your question to the `#kubernetes-users` channel in
[Kubernetes slack](http://slack.k8s.io/). You can also search
resources like
[Stack Overflow](http://stackoverflow.com/questions/tagged/kubernetes)
for answers to similar questions.

You can also open issues for Kubernetes functionality in
 https://github.com/kubernetes/kubernetes.

If this is a documentation issue, please re-open this issue.
```

Bug:
```
This sounds more like an issue with the code than an issue with
the documentation. Please open an issue at
https://github.com/kubernetes/kubernetes/issues.

If this is a documentation issue, please re-open this issue.
```
