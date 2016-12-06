# [msbu-tech.github.io](https://msbu-tech.github.io/)

[![](https://img.shields.io/badge/powered%20by-jekyll-red.svg)](https://jekyllrb.com)
[![](https://api.travis-ci.org/msbu-tech/msbu-tech.github.io.svg)](https://travis-ci.org/msbu-tech/msbu-tech.github.io)
![](https://stars-badge.herokuapp.com/msbu-tech/msbu-tech.github.io/stars.svg)

MSBU Tech 团队 GitHub 官方首页。

## 我想提交周刊

[欢迎提交到最新的内容收集 Issue 中](https://github.com/msbu-tech/weekly/issues?q=is%3Aissue+is%3Aopen+label%3A%E6%94%B6%E9%9B%86%E4%B8%AD)。

## 安装

1. Clone

    ```
    $ git clone https://github.com/msbu-tech/msbu-tech.github.io.git
    ```

2. 初始化 Bundler

    ```
    $ bundle install
    ```

3. 本地运行

    ```
    $ rake serve
    ```

    在 `http://localhost:4000` 进行预览。

## 对于编辑人员

### 目录结构

```
_posts/
    2016-09-08-msbu-tech-website.md
    ...
_weekly/
    2016-09-06-weekly.md
    ...
_newsletter/
    2016-09-06-weekly-email.md
    ...
```

* 博客：`_posts/`
* 周刊：周刊主体放在 `_weekly/`，`_newsletter/` 用于生成推广邮件

### 创建周刊

编辑可以自行根据格式创建博客或者周刊。为了方便编辑的工作，我们提供了 `rake` 来快速创建新周刊。只需要运行：

```
$ rake weekly
```

就会根据当前时间创建如下周刊所需的文件：

```
_weekly/2016-10-09-weekly.md
_newsletter/2016-10-09-weekly-email.md
```

如果需要指定时间，可以使用参数：

```
$ rake weekly[2016-10-09]
```

对于 `zsh` 用户，需要转义：

```
$ rake weekly\[2016-10-09\]
```

### 导入 GitHub Issues 中的周刊

如果已经在 [msbu-tech/weekly](https://github.com/msbu-tech/weekly) 中创建好 Issue，可以直接创建并导入周刊文章：

```
$ ACCESS_TOKEN=your-access-token-here rake weekly[2016-10-09,true]
```

### 编辑周刊

周刊中的文章在 `_weekly/` 文件夹中的 `.md` 文件头部的 Front Matter 中以 `yaml` 格式存放。`_newsletter` 中的文章不需要任何编辑，会自动根据 `_weekly` 中的内容生成。

一般情况下，我们都是编辑最新一期周刊的内容。为了方便，我们提供了一个指令用默认编辑器打开最新一期周刊：

```
$ rake edit-latest
```

它会自动调用环境变量中的 `$EDITOR`，如果不想用环境变量中的编辑器，可以手动传入：

```
$ EDITOR=atom rake edit-latest
```

周刊 yaml 格式约定如下：

| 字段 | 作用 | 类型 | 限制 |
|------|-----|-----|-----|
| title | 文章标题 | String | 支持 inline html |
| original | 是否为原创 | Boolean | 可省略，默认 false |
| link | 文章链接 | String |  |
| comment | 文章推荐语 | String | 支持 inline html |
| referrer | 文章推荐人 | String | 可省略 |
| tags | 文章标签 | String Array |  |

### 测试

为了防止在添加文章时出现低级错误，我们提供了自动化检测。在添加文章发布之前，请运行：

```
$ rake test-weekly
```

默认是全量扫描，如果只想扫描某期周刊，可以带日期参数运行：

```
$ rake test-weekly[2016-11-15]
```

对于最新一期，可以使用 `latest` 参数：

```
$ rake test-weekly[latest]
```

如果发现错误，会提示所在文件、文章、出错字段和原因：

```
[ERROR] Duplicated name within a weekly found:
    Filename: 2016-11-22-weekly.md
        Item: 1
     >> Name: Google 是如何做到从不宕机的
```

如果返回“Success.”，则证明检测通过，可以发布。

## 对于设计者

模版和样式分别位于 `_layouts/` 和 `css/` 中。

## 部署

网站基于 GitHub Pages，只需要 `git push` 到 `master` 就可以完成部署。

## License

* 网站程序相关部分使用 [MIT License](/LICENSE)
* 网站内容部分使用 [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/legalcode.txt)
