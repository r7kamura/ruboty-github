# Ruboty::Github
[![Gem Version](https://badge.fury.io/rb/ruboty-qiita-github.svg)](https://badge.fury.io/rb/ruboty-qiita-github) [![Test](https://github.com/increments/ruboty-qiita-github/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/increments/ruboty-qiita-github/actions/workflows/test.yml) [![Maintainability](https://api.codeclimate.com/v1/badges/764bf9dc5796f0d3bef3/maintainability)](https://codeclimate.com/github/increments/ruboty-qiita-github/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/764bf9dc5796f0d3bef3/test_coverage)](https://codeclimate.com/github/increments/ruboty-qiita-github/test_coverage)

Manage GitHub via Ruboty.
This gem adds `deploy pull request` command to original ruboty-github plugin.

## Install
```ruby
# Gemfile
gem "ruboty-github"
```

## Usage
```
@ruboty close <URL>                                       - Close an Issue
@ruboty create issue "<title>" on <repo>[\n<description>] - Create a new Issue
@ruboty merge <URL>                                       - Merge a Pull Request
@ruboty pull request "<title>" from <from> to <to>        - Create a new Pull Request
@ruboty deploy pull request "<title>" from <from> to <to> - Create a new Pull Request for Deploy
@ruboty remember my github token <token>                  - Remember sender's GitHub access token
@ruboty search issues "<query>"                           - Search an Issues/Pull Requests
```

## ENV
```
GITHUB_BASE_URL - Pass GitHub base URL if needed (e.g. https://github.example.com)
```

## Image
![](https://raw.githubusercontent.com/r7kamura/ruboty-github/master/images/screenshot.png)
