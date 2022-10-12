## Unreleased
- Add `search issues` command
- Support test on GitHub Actions
- Add rubocop, rubocop-rake, rubocop-performance, rubocop-rspec gems

## 0.2.3
- Fix typo

## 0.2.2
- Fix a bug about pull request user

## 0.2.1
- Add `deploy pull request` command

## 0.2.0
- Change ENV from GITHUB_HOST to GITHUB_BASE_URL

## 0.1.3
- Fix bug that would not respond to issue URL

## 0.1.2
- Allow merge & issue commands to take issue's URL
- `close issue <target>` -> `close[ issue] <target>`

## 0.1.1
- Pass empty string as issue body instead of nil

## 0.1.0
- Change command: merge pull request -> merge

## 0.0.9
- Rename: Ellen -> Ruboty

## 0.0.8
- Support Github Enterprise

## 0.0.7
- Use Ruboty::Message#from_name as user identifier

## 0.0.6
- Add Create & Merge Pull Request commands

## 0.0.5
- Description support

## 0.0.4
- Add close command

## 0.0.3
- Support Ruboty v0.2.0

## 0.0.2
- Memorize access token and use it to create a new issue

## 0.0.1
- 1st Release
