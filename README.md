# [msbu-tech.github.io](https://msbu-tech.github.io/)

[![](https://img.shields.io/badge/powered%20by-jekyll-red.svg)](https://jekyllrb.com)

Official Github Pages of MSBU Tech Team.

## 我想提交周刊

[欢迎提交到最新的内容收集 Issue 中](https://github.com/msbu-tech/weekly/issues?q=is%3Aissue+is%3Aopen+label%3A%E6%94%B6%E9%9B%86%E4%B8%AD)。

## Installation

1. Clone the repo

    ```
    $ git clone https://github.com/msbu-tech/msbu-tech.github.io.git
    ```

2. Init with bundler

    ```
    $ bundle install
    ```

3. Serve

    ```
    $ rake serve
    ```

    Preview page at `http://localhost:4000`

## For Editor

### Directory Structure

```
_posts/
    2016-09-08-msbu-tech-website.md
    ...
_weekly/
    2016-09-06-weekly.md
    ...
_weekly_email/
    2016-09-06-weekly.md
    ...
```

* Blog: `_posts/`.
* Weekly: `_weekly/` as a post, `_newsletter/` for sending promoting email.

Editors should create post or weekly in that folders. To make weekly even simpler, `rake` is available for creating a new weekly.

### Create a new weekly with `rake`

Use `rake` to create with scaffold:

```
rake weekly
```

It would generate files as follows, with the current date.

```
_data/2016-10-09-weekly.yml
_weekly/2016-10-09-weekly.md
_newsletter/2016-10-09-weekly-email.md
```

To specify date, use `rake weekly[:date]`.

```
rake weekly[2016-10-09]
```

## For Designer

Edit templates files and stylesheet in `_layouts/` and `css/`.

## Deploy

As the website is powered by GitHub Pages, just simply make a `git push` to deploy to GitHub.

## License

The program is licensed under [MIT License](/LICENSE). All the content is licensed under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/legalcode.txt).
