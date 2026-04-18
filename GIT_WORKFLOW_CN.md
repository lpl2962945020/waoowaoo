# Waoowaoo 二开与同步官方详细指南

适用对象：
- 你想自己给 `waoowaoo` 加功能
- 以后还想继续拿到官方作者发布的新版本
- 你现在对 `git` 不熟，想按步骤照着做

当前情况说明：
- 你现在这个目录是：`F:\waoowaoo-0.4.1`
- 这个目录目前不是一个 Git 仓库
- 我已经确认：本机已安装 Git，版本是 `2.53.0.windows.1`
- 我也确认：当前目录没有 `.git` 目录

这意味着：
- 你现在这个目录更像是“下载包 / 解压目录”
- 可以运行项目
- 但不适合长期做“二次开发 + 跟进官方更新”

所以最推荐的做法是：
- 保留当前目录当备份
- 新建一个“正式 Git 开发目录”
- 以后所有代码开发都在新的 Git 仓库里做

---

## 1. 你最终要达到的效果

目标是建立下面这套结构：

- 官方仓库：`saturndec/waoowaoo`
- 你自己的 Fork：`你的 GitHub 用户名/waoowaoo`
- 你本地正式开发目录：例如 `F:\waoowaoo-dev`

以后工作方式是：

1. 官方更新了新版本
2. 你把官方更新同步到你自己的仓库
3. 再把你自己的功能继续合并在上面
4. 最终实现“官方新功能 + 你自己的功能”共存

---

## 2. 最推荐的 Git 方案

我推荐你用这一套，最稳，也最适合长期维护：

- `origin`：指向你自己的 Fork
- `upstream`：指向官方原仓库
- `main`：你自己的稳定主分支
- `feature/...`：你每个新功能单独开的分支

简单理解：

- `origin` = 你自己的远程仓库
- `upstream` = 官方作者的仓库
- `main` = 你自己最终要长期保留的版本
- `feature/xxx` = 你某一个具体功能的开发分支

---

## 3. 先记住几个最重要的概念

如果你完全不懂 Git，先记住这几个词：

### 3.1 仓库

仓库就是 Git 管理的项目目录。

只要目录里有 `.git`，这个目录通常就是 Git 仓库。

### 3.2 提交 commit

提交就是“保存一次代码历史快照”。

你可以理解成：
- Word 的“保存版本”
- 游戏存档点

### 3.3 分支 branch

分支就是“单独开一条开发线”。

例如：
- `main`：稳定版本
- `feature/login-redesign`：你正在开发登录页重构

### 3.4 clone

`clone` 是把远程仓库完整下载到本地，并且保留 Git 历史。

### 3.5 fork

`fork` 是在 GitHub 上先复制一份官方仓库到你自己的账号下。

这样你就有了自己的远程仓库，可以安全地长期维护。

### 3.6 remote

`remote` 是远程仓库地址。

你后面会有两个：
- `origin`：你自己的 Fork
- `upstream`：官方仓库

---

## 4. 你现在最应该怎么做

不要直接把当前目录硬改成 Git 主开发目录。

最稳方案：

1. 保留当前目录 `F:\waoowaoo-0.4.1` 不动
2. 去 GitHub Fork 官方仓库
3. 在本地重新 clone 一份正式开发目录
4. 把你现在有用的本地文件复制过去
5. 以后都在新的目录开发

推荐的新目录名：

- `F:\waoowaoo-dev`

这样最清晰：
- `F:\waoowaoo-0.4.1` = 当前备份目录
- `F:\waoowaoo-dev` = 以后正式开发目录

---

## 5. 第一次正式搭建 Git 开发环境

下面按顺序做。

### 5.1 先注册或登录 GitHub

如果你已经有 GitHub 账号，直接登录即可。

如果没有：
- 打开 `https://github.com/`
- 注册账号

### 5.2 在 GitHub 上 Fork 官方仓库

打开官方仓库：

`https://github.com/saturndec/waoowaoo`

然后：

1. 点击右上角 `Fork`
2. 选择你的 GitHub 账号
3. 等 GitHub 创建你的副本

创建成功后，你会得到自己的仓库地址，形如：

`https://github.com/你的用户名/waoowaoo`

这个仓库以后就是你的长期远程仓库。

### 5.3 配置 Git 用户信息

第一次用 Git，先在 PowerShell 里运行：

```powershell
git config --global user.name "你的GitHub用户名或你的名字"
git config --global user.email "你的GitHub邮箱"
```

查看是否成功：

```powershell
git config --global --list
```

### 5.4 把你自己的 Fork 克隆到本地

推荐在 `F:\` 下新建正式开发目录。

PowerShell 执行：

```powershell
cd F:\
git clone https://github.com/你的用户名/waoowaoo.git waoowaoo-dev
```

完成后进入目录：

```powershell
cd F:\waoowaoo-dev
```

### 5.5 给本地仓库增加官方 upstream

现在你本地这个新目录已经是 Git 仓库了。

接着把官方仓库加成 `upstream`：

```powershell
git remote add upstream https://github.com/saturndec/waoowaoo.git
```

检查远程仓库是否配置成功：

```powershell
git remote -v
```

正常会看到类似结果：

```text
origin    https://github.com/你的用户名/waoowaoo.git (fetch)
origin    https://github.com/你的用户名/waoowaoo.git (push)
upstream  https://github.com/saturndec/waoowaoo.git (fetch)
upstream  https://github.com/saturndec/waoowaoo.git (push)
```

### 5.6 拉取一次官方信息

```powershell
git fetch upstream
```

### 5.7 检查你当前所在分支

```powershell
git branch
```

如果看到的是 `main`，就可以继续。

---

## 6. 把你当前目录里有用的本地文件迁移到新仓库

你现在这个目录里已经有一些本地开发文件，这些通常不需要提交到 GitHub，但本地开发会用到。

建议迁移这些文件：

- `.env`
- `.npmrc`
- `Start-Waoowaoo-Dev.bat`
- `Stop-Waoowaoo-Dev.bat`

如果你有本地数据，也可按需迁移：

- `data\`

不建议迁移这些：

- `node_modules\`
- `logs\`
- `.next\`

因为这些都可以重新生成。

### 6.1 复制文件示例

假设你已经在新目录 `F:\waoowaoo-dev`。

可以手动复制，也可以在 PowerShell 执行：

```powershell
Copy-Item F:\waoowaoo-0.4.1\.env F:\waoowaoo-dev\.env
Copy-Item F:\waoowaoo-0.4.1\.npmrc F:\waoowaoo-dev\.npmrc
Copy-Item F:\waoowaoo-0.4.1\Start-Waoowaoo-Dev.bat F:\waoowaoo-dev\Start-Waoowaoo-Dev.bat
Copy-Item F:\waoowaoo-0.4.1\Stop-Waoowaoo-Dev.bat F:\waoowaoo-dev\Stop-Waoowaoo-Dev.bat
```

如果要迁移本地数据目录：

```powershell
Copy-Item F:\waoowaoo-0.4.1\data F:\waoowaoo-dev\data -Recurse
```

### 6.2 为什么这些文件一般不会进 Git

因为项目的 `.gitignore` 通常已经忽略了这些内容：

- `.env`
- `data`
- `node_modules`
- `logs`

这样做是对的：

- `.env` 里有你的密钥
- `data` 是本地运行数据
- `node_modules` 太大，不应该进 Git

---

## 7. 在新 Git 仓库里重新跑起项目

进入你的新目录：

```powershell
cd F:\waoowaoo-dev
```

如果你复制了我之前给你做的 BAT，直接双击也可以。

如果手工启动，命令如下：

```powershell
docker compose up mysql redis -d
npm.cmd install
npx.cmd prisma db push
npm.cmd run dev
```

如果已经有 BAT：

- 双击 `Start-Waoowaoo-Dev.bat`
- 停止时双击 `Stop-Waoowaoo-Dev.bat`

---

## 8. 以后你每天开发的标准流程

以后每次开发，尽量按下面顺序走。

### 8.1 先回到主分支

```powershell
git checkout main
```

### 8.2 拉一下你自己仓库的最新代码

```powershell
git pull origin main
```

### 8.3 新建一个功能分支

例如你要加“用户积分”功能：

```powershell
git checkout -b feature/user-credit
```

例如你要加“批量下载视频”：

```powershell
git checkout -b feature/batch-download-video
```

### 8.4 开发功能

你就在这个分支上改代码、调试、测试。

### 8.5 查看改了哪些文件

```powershell
git status
```

### 8.6 提交你的代码

```powershell
git add .
git commit -m "feat: add user credit system"
```

说明：
- `git add .` = 把当前改动加入暂存区
- `git commit -m "..."` = 形成一次正式提交

### 8.7 把你的功能分支推到 GitHub

第一次推这个新分支：

```powershell
git push -u origin feature/user-credit
```

后面继续推：

```powershell
git push
```

### 8.8 功能完成后合并回 main

先切回主分支：

```powershell
git checkout main
```

合并你的功能分支：

```powershell
git merge feature/user-credit
```

再推到你自己的 GitHub：

```powershell
git push origin main
```

### 8.9 功能分支可以删除

合并完后，本地可以删掉功能分支：

```powershell
git branch -d feature/user-credit
```

如果远程也要删：

```powershell
git push origin --delete feature/user-credit
```

---

## 9. 以后怎么同步官方新版本

这是最关键的部分。

假设官方作者更新了新功能，你想拿过来。

### 9.1 先确保你当前没有未提交改动

```powershell
git status
```

如果看到很多修改，先：

- 提交 commit
- 或者先备份

不要在“半改不改”的状态下直接合并官方更新。

### 9.2 拉取官方最新代码

```powershell
git fetch upstream
```

### 9.3 回到你的主分支

```powershell
git checkout main
```

### 9.4 合并官方主分支

```powershell
git merge upstream/main
```

如果没有冲突，就会直接合并成功。

### 9.5 推送到你的 GitHub

```powershell
git push origin main
```

这样你自己的 `main` 就同时拥有：

- 官方最新代码
- 你之前已经保留在 `main` 的功能

---

## 10. 如果合并官方时出现冲突，怎么办

冲突很正常，不用怕。

冲突通常说明：
- 官方也改了同一段代码
- 你也改了同一段代码

### 10.1 先看状态

```powershell
git status
```

Git 会告诉你哪些文件冲突。

### 10.2 打开冲突文件

你会看到这种标记：

```text
<<<<<<< HEAD
这是你自己的代码
=======
这是官方最新代码
>>>>>>> upstream/main
```

你需要手工决定最后保留什么。

处理原则：

1. 不要把这些标记留在文件里
2. 选保留你的，还是保留官方的，还是两边合并
3. 改完保存

### 10.3 标记冲突已解决

```powershell
git add 冲突文件路径
```

全部解决后提交：

```powershell
git commit -m "merge upstream main and resolve conflicts"
```

最后推送：

```powershell
git push origin main
```

---

## 11. 最适合你的数据库改动方式

既然你会自己加功能，数据库最好不要一直只用 `db push`。

正式开发时，推荐这样：

### 11.1 修改 Prisma schema

你改：

`prisma/schema.prisma`

### 11.2 生成 migration

例如你新增一个字段：

```powershell
npx.cmd prisma migrate dev --name add_user_credit_field
```

这样会生成 migration 文件夹。

### 11.3 提交这些内容

要提交：

- `prisma/schema.prisma`
- `prisma/migrations/...`

### 11.4 为什么推荐 migration

因为以后你同步官方版本时：
- 数据结构变更会更清楚
- 你自己加过哪些字段一目了然
- 更容易在新环境重建数据库

### 11.5 什么时候还能用 db push

`db push` 仍然可以用，但更适合：
- 本地快速试验
- 临时验证模型

如果是你真正想保留的功能，尽量改用 `migrate dev`。

---

## 12. 怎样减少未来和官方冲突

这是长期维护最重要的经验。

尽量做到：

1. 多新增文件，少魔改官方核心文件
2. 你的功能尽量集中在自己的目录或模块
3. 数据库字段尽量“新增”，不要轻易删除官方字段
4. 公共逻辑改动前先想清楚以后会不会和官方撞车
5. 每个功能分支尽量小，不要一次改太多系统层代码

特别推荐：

- 新增自己的组件
- 新增自己的 hooks
- 新增自己的 service
- 用配置开关控制新功能

尽量少做：

- 直接重写官方整条主流程
- 大面积改很多官方核心基础文件
- 改已有字段的原始含义

---

## 13. 你最常用的 Git 命令速查表

### 看当前状态

```powershell
git status
```

### 看当前分支

```powershell
git branch
```

### 切换到主分支

```powershell
git checkout main
```

### 新建功能分支

```powershell
git checkout -b feature/你的功能名
```

### 暂存修改

```powershell
git add .
```

### 提交

```powershell
git commit -m "你的提交说明"
```

### 推送到你自己的 GitHub

```powershell
git push
```

### 第一次推新分支

```powershell
git push -u origin 分支名
```

### 拉你自己主分支最新代码

```powershell
git pull origin main
```

### 拉官方最新代码

```powershell
git fetch upstream
```

### 合并官方主分支

```powershell
git merge upstream/main
```

### 看远程仓库

```powershell
git remote -v
```

---

## 14. 最适合你的实际工作流

建议你以后固定这么做：

### 平时开发新功能

1. `git checkout main`
2. `git pull origin main`
3. `git checkout -b feature/xxx`
4. 开发
5. `git add .`
6. `git commit -m "feat: xxx"`
7. `git push -u origin feature/xxx`
8. 测试完成后合并回 `main`

### 每次官方发布新版本后

1. 先备份或提交你自己的未完成改动
2. `git fetch upstream`
3. `git checkout main`
4. `git merge upstream/main`
5. 解决冲突
6. 运行项目测试
7. `git push origin main`

---

## 15. 对你当前项目最实用的迁移建议

你现在最适合按这个顺序做：

1. 保留 `F:\waoowaoo-0.4.1` 当备份
2. 在 GitHub 上 Fork 官方仓库
3. 新建 `F:\waoowaoo-dev`
4. `git clone` 你的 Fork 到 `F:\waoowaoo-dev`
5. 增加 `upstream`
6. 复制这几个本地文件过去：
   - `.env`
   - `.npmrc`
   - `Start-Waoowaoo-Dev.bat`
   - `Stop-Waoowaoo-Dev.bat`
7. 在新目录里重新启动项目
8. 以后只在新目录里开发

---

## 16. 什么时候可以请我继续帮你

你做完上面的任意一步后，都可以继续找我。

我下一步最适合帮你的事情有这些：

1. 你 Fork 完后，我带你一步一步执行 `clone` 和 `remote add upstream`
2. 我帮你检查新仓库的远程配置是否正确
3. 我帮你把当前目录里的本地开发文件迁移到新 Git 仓库
4. 我帮你建立第一条功能分支并做第一次 commit
5. 以后官方更新时，我带你做第一次 `merge upstream/main`

---

## 17. 一句最重要的话

你以后想长期做“官方持续更新 + 你自己持续二开”，关键不是技巧多复杂，而是这条原则：

**尽快从当前下载目录迁移到一个正式的 Git Fork 开发仓库。**

只要这一步做对，后面就会顺很多。
