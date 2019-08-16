
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
# Branch
- ```git checkout <branch_name>``` switches to that branch, pulling it down from origin if needed
- ```git checkout -b <branch_name>``` creates and checks out a new branch
- ```git branch``` lists names of local branches

## Delete
- ```git branch -d <branch_name>``` The -d option is an alias for --delete, which only deletes the branch if it has already been fully merged in its upstream branch
- ``` git branch -D <branch_name>``` You could also use -D, which is an alias for --delete --force, which deletes the branch "irrespective of its merged status."
```git push <remote_name> --delete <branch_name>``` to delete a remote branch

# Log
- ```git log --pretty=format:"%h - %an, %ar : %s"```  ca82a6d - Scott Chacon, 6 years ago : changed the version number
