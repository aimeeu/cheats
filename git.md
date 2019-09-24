
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
# Clone
 - ``git clone --single-branch --branch <branchname> <remote-repo>``
# Branch
- ```git checkout <branch_name>``` switches to that branch, pulling it down from origin if needed
- ```git checkout -b <branch_name>``` creates and checks out a new branch
- ```git branch``` lists names of local branches

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
