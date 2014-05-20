# Ellen::Github
Manage GitHub via Ellen.

## Install
```ruby
# Gemfile
gem "ellen-github"
```

## Usage
```
@ellen close issue <repo>#<number>                       - Close an Issue
@ellen create issue "<title>" on <repo>[\n<description>] - Create a new Issue
@ellen merge pull request<repo>#<number>                 - Merge a Pull Request
@ellen pull request "<title>" from <from> to <to>        - Create a new Pull Request
@ellen remember my github token <token>                  - Remember sender's GitHub access token
```

## ENV
```
GITHUB_HOST - Pass GitHub Host if needed (e.g. github.example.com)
```

## Image
![](https://raw.githubusercontent.com/r7kamura/ellen-github/master/images/screenshot.png)
