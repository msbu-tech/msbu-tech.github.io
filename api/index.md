---
layout: page
title: API | MSBU Tech
permalink: /api/
highlight: true
inline_doc: |
  ## Weekly API

  接口

  * <https://msbu-tech.github.io/api/weekly.json>

  描述

  * 获取技术列表和详细信息。

  HTTP Method

  * GET

  Input

  * None

  Output

  ```json
  {
    "api_version": 1,
    "count": 1,
    "weekly": [
      {
        "id": "1",
        "date": "2016-11-15",
        "count": "2",
        "articles": [
          {
            "id": "1",
            "title": "魅族云 Docker 实践",
            "link": "http://dockone.io/article/1806",
            "comment": "article comments",
            "tags": ["Objective-C", "Runtime"]
          },
          {
            "id": "2",
            "title": "苏宁11.11:苏宁易购移动端的架构优化实践",
            "link": "http://your-article.url",
            "comment": "article comments",
            "tags": ["移动", "架构"]
          }
        ]
      }
    ]
  }
  ```
---

<div class="page-title">
  开放 API
</div>
<div class="article info">
  在你的应用中使用 MSBU Tech 开放 API，利用 API 快速构建 Web、移动或桌面应用。
</div>
<div class="article">
  {{ page.inline_doc | markdownify }}
</div>
