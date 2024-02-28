### How to set up a [Centralized Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows) extended to [Feature Breaching](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)

Accept the invitation (from GitHub or through the link) and clone the central repository:

`git clone https://<YourToken>@github.com/<YourUsername>/LabMAPD_A`

* Note that this operation must be done only once.

Each time before starting the work session you must update your local main branch with respect to origin main (i.e. the remote branch on GitHub) to make sure you have everyone else's changes:

`git checkout main`

`git fetch origin`

`git merge origin/main`

Now there can be three different scenarios:

#### 1) Create a new project

When you want to work on a new project you must create a new branch, usually referred to as the development branch, because you want to work on a different timeline from the main branch which should simply be a copy of the remote one (origin main). For example, suppose you want create the "hello_world" project. Then you create a new branch (you should use a standar notation like <ProjectName>):

`git checkout -b <hello_world>`

* Note that the parameter -b is only needed the first time you create the branch.

If you are working on Linux, you should open vivado using commands from terminal:

`source /tools/Xilinx/Vivado/2018.3/settings64.sh`

`vivado`

After making some changes to one or more files you can see the state of your repository:

`git status`

Fisrt of all stage your file:

`git add <FileName>`

* Note that you can stage all the files you edited at once with:

  `git add .`

Then commit your files:

`git commit -m "SomeDescription"`

Finally you must push your changes up to the remote branch on GitHub:

`git push origin <hello_world>`

* Note that the first time you use this command you create an homonymous remote branch on GitHub
  
 Finally you have to set the tracking information for the new branch in order to eliminate bugs during push/pull:
  
 `git branch --set-upstream-to=origin/<hello_world> <hello_world>`

#### 2) Modify an existing project (initiated by another member)

If you want to work on the same project "hello_world" created by another member of the team, you must create a local development branch that explicitly tracks the remote branch created by the member who first initiated the project:

`git checkout -b <hello_world> origin/<hello_world>`

* Note that this operation must be done only once.

If you have already created the local development branch, each time before starting the work session you must get the updates from the remote branch to make sure you have everyone else's changes:

`git checkout <hello_world>`

`git fetch origin`

`git merge origin/<hello_world>`

You also must get updates from the local main branch (previously updated with the origin main):

`git checkout <hello_world>`
  
`git merge main`
  
If you are working on Linux, you should open vivado using commands from terminal:

`source /tools/Xilinx/Vivado/2018.3/settings64.sh`

`vivado`

After making some changes to one or more files you can see the state of your repository:

`git status`

Fisrt of all stage your file:

`git add <FileName>`

* Note that you can stage all the files you edited at once with:

  `git add .`

Then commit your files:

`git commit -m "SomeDescription"`

Finally you must push your changes up to the tracked remote branch on GitHub:

`git push`

#### 3) Modify an existing project (initiated by you)
  
You just need to follow the steps in scenario 2 except for the first one (i.e. `git checkout -b <hello_world> origin/<hello_world>`, because you already created the local development branch when you initiated the project).
  
#### Pull Request

When the team members are done with the project, one of them must send a *pull request* from the remote <hello_world> branch on GitHub to origin main. Team members will be notified automatically and if everything is ok someone has to merge the changes into the stable project.

After the project is completed, each team member can delete the <ProjectName> branch locally:

`git branch -d <hello_world>`

And just one of them can also delete the remote one:

`git push origin --delete <hello_world>`
