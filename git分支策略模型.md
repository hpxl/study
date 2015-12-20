http://openwares.net/linux/git_brantch_model.html
荷兰程序员Vincent Driessen的A successful Git branching model[1]对于集中式的中小型项目是一个相当不错的分支模型。他还制作了一副pdf大图Git-branching-model。

分支模型

有两个常设分支,master和devel(或叫develop,or whatever)。master分支用于最终产品发布,而devel分支用于日常开发。

其他临时性分支包括特性分支feature或叫topic分支,预发布分支release,热补丁分支hotfix。

feature用于新功能开发,分支自devel,新功能开发完毕必须merge回devel分支,或者不再需要此特性,直接丢弃分支。命名方式一般为feature-特性名或者特性编号。

release用于产品正式发布前的预发布,分支自devel。命名方式一般为release-(即将发布的版本号),比如release-1.2。release分支功能上不应该再发生变化,只是一些小的完善或者bug的修复还有实施版本策略。确认版本可以发布后,将release合并到master,并在master上打版本tag。release同时要合并回devel分支,之后可以删除release分支。

hotfix用于正式发布产品的紧急bug修复,分支自master。命名方式一般为hotfix-bug编号,比如hotfix-1312,bug编号来自bug tracking系统,比如Trac。bug修复完毕后,将hotfix分支合并回master分支,并更新产品号以及打新的tag。如果当前存在release分支,则应将hotfix合并到release分支而不是master分支。hotfix还需要合并回devel分支。之后可以将hotfix分支删除。

合并分支时使用- -no-ff选项,不让分支fast forwarding以保持完整清晰的版本历史。

个人分支

除了常设分支和临时分支外,每个开发人员还可以设立自己的个人分支(personal branch)。个人分支以自己的名字命名,分支自devel。个人分支方便开发人员保存和在不同机器间同步未最终完成的工作成果,代码重构,并且可以减少devel分支的commit,保持devel分支的整洁。个人分支上的工作告一段落后,更新本地代码库,将个人分支上的工作成果合并到devel分支,然后推送devel分支到中央仓库。

代码审核

master分支只有项目管理员可以touch,其他开发人员无法向master推送更新。而开发人员向devel分支推送的更新必须经过gerrit代码审核服务器,在通过其他开发人员的code review和CI服务器的自动verify后,才可以正式merge到devel分支。

其他临时分支和个人分支不经过gerrit,直接进入中央仓库。

持续集成

每当开发人员向devel推送更新,这在gerrit叫做change,CI服务器会自动对新提交的change进行编译和运行单元测试,根据结果给于适当的verify值。

当代码通过审核merge到devel后,自动触发CI服务器,拉取devel分支,然后编译部署到测试环境进行自动化测试和人工测试。

而master分支发布产品时也可以通过触发CI进行自动编译和部署到产品环境。

References:
[1]A successful Git branching model
[2]Git分支管理策略
[3]实用 Git 工作流
[4]一个成功的Git分支模型

===
Anything that can go wrong will go wrong. ---Murphy's Law
