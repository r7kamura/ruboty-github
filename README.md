# Ruboty::Github
Manage GitHub via Ruboty.

## Install
```ruby
# Gemfile
gem "ruboty-github"
```

## Usage
```
@ruboty close issue <repo>#<number>                       - Close an Issue
@ruboty create issue "<title>" on <repo>[\n<description>] - Create a new Issue
@ruboty merge <repo>#<number>                             - Merge a Pull Request
@ruboty pull request "<title>" from <from> to <to>        - Create a new Pull Request
@ruboty remember my github token <token>                  - Remember sender's GitHub access token
```

## ENV
```
GITHUB_HOST - Pass GitHub Host if needed (e.g. github.example.com)
```

## Image
![](https://raw.githubusercontent.com/r7kamura/ruboty-github/master/images/screenshot.png)
