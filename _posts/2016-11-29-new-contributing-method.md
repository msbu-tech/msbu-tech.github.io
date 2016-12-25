---
layout: blog
title: MSBU 业内技术周刊新投稿方式
type: blog
highlight: true
author: crispgm
---

MSBU 业内技术周刊自2016年9月6日创刊之后，已经发布了12期。之前的投稿采用 Issue 留言或直接联系编辑人员方式，内容采用人工编辑。为了降低编辑成本，我们推出了全新的自动化投稿方式。

## 投稿流程

MSBU Weekly 目前启用纯自动化方式投稿，投稿人需要在周二发版前在本 [msbu-tech/weekly Issues](https://github.com/msbu-tech/weekly/issues) 中回复文章收集贴，收集贴应该处于“收集中”状态。如果文章收集贴尚未创建，请自行创建或通知管理员创建。    

投稿时直接回复当前收集贴，格式如下：

* 回复内容第一行必须是 `/post`
* 回复内容第二行到第五行是内容需要以减号 `-` 开头（GitHub 会渲染成列表）
* 回复内容第二行是标题
* 回复内容第三行是链接
* 回复内容第四行是介绍语
* 回复内容第五行是标签，以英文半角逗号分隔 `,`
* 投稿人会自动根据回复者 ID 抓取

示例：

```
/post
- 疯狂的JSONP
- http://www.cnblogs.com/twobin/p/3395086.html
- 何为跨域？何为JSONP？JSONP技术能实现什么？是否有必要使用JSONP技术？
- javascript, jsonp, 跨域
```

请继续关注我们的周刊！