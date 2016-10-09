# Official Github Pages of MSBU Tech Team

[![](https://img.shields.io/badge/powered%20by-jekyll-red.svg)](https://jekyllrb.com)

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
    $ rake
    ```

    Preview page at `http://localhost:4000`

## How to create a new weekly?

Use `rake` to create with scaffold:

```
rake weekly
```

It would generate files as follows, with the current date.

```
_data/2016-10-09-weekly.yml
_weekly/2016-10-09-weekly.md
_weekly_email/2016-10-09-weekly-email.md
```

To specific date, use `rake weekly[:date]`

```
rake weekly[2016-10-09]
```

## Deploy

As the website is powered by GitHub Pages, just push to deploy to GitHub.