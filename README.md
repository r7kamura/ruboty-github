# Ruboty::Github
Manage GitHub via Ruboty.

## Install
```ruby
# Gemfile
gem "ruboty-github"
```

## Usage
```
@ruboty close <URL>                                       - Close an Issue
@ruboty create branch <to_branch> from <from>             - Create a new Branch
@ruboty create issue "<title>" on <repo>[\n<description>] - Create a new Issue
@ruboty search issues <query>                             - Search issues
@ruboty merge <URL>                                       - Merge a Pull Request
@ruboty pull request "<title>" from <from> to <to>        - Create a new Pull Request
@ruboty remember my github token <token>                  - Remember sender's GitHub access token
```

## ENV
```
GITHUB_BASE_URL - Pass GitHub base URL if needed (e.g. https://github.example.com)
```

## Image
![](https://raw.githubusercontent.com/r7kamura/ruboty-github/master/images/screenshot.png)
