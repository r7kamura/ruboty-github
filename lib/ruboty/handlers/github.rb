module Ruboty
  module Handlers
    class Github < Base
      ISSUE_PATTERN = %r<(?:https?://[^/]+/)?(?<repo>.+)(?:#|/pull/|/issues/)(?<number>\d+) ?>

      env :GITHUB_BASE_URL, "Pass GitHub URL if needed (e.g. https://github.example.com)", optional: true
      env :RELEASE_NAME_PREFIX, "Pass Github release name prefix if needed (e.g. v)", optional: true

      on(
        /create issue "(?<title>.+)" on (?<repo>.+)(?:\n(?<description>[\s\S]+))?\z/,
        name: "create_issue",
        description: "Create a new issue",
      )

      on(
        /remember my github token (?<token>.+)\z/,
        name: "remember",
        description: "Remember sender's GitHub access token",
      )

      on(
        /close(?: issue)? #{ISSUE_PATTERN}\z/,
        name: "close_issue",
        description: "Close an issue",
      )

      on(
        /pull request "(?<title>.+)" from (?<from>.+) to (?<to>.+)(?:\n(?<description>[\s\S]+))?\z/,
        name: "create_pull_request",
        description: "Create a pull request",
      )

      on(
        /merge #{ISSUE_PATTERN}\z/,
        name: "merge_pull_request",
        description: "Merge pull request",
      )

      on(
        /search issues (?<query>.+)/,
        name: "search_issues",
        description: "Search issues",
      )

      on(
        /create branch (?<to_branch>.+) from (?<from>.+)\z/,
        name: "create_branch",
        description: "Create a branch",
      )

      on(
        /create release (?<repo>.+) (?<version>.+)/,
        name: "create_release",
        description: "Create a release",
      )

      on(
        /get releases (?<repo>.+)/,
        name: "get_releases",
        description: "Get releases",
      )

      on(
        /get latest release (?<repo>.+)/,
        name: "get_latest_release",
        description: "Get latest release",
      )

      def create_issue(message)
        Ruboty::Github::Actions::CreateIssue.new(message).call
      end

      def close_issue(message)
        Ruboty::Github::Actions::CloseIssue.new(message).call
      end

      def remember(message)
        Ruboty::Github::Actions::Remember.new(message).call
      end

      def create_pull_request(message)
        Ruboty::Github::Actions::CreatePullRequest.new(message).call
      end

      def merge_pull_request(message)
        Ruboty::Github::Actions::MergePullRequest.new(message).call
      end

      def search_issues(message)
        Ruboty::Github::Actions::SearchIssues.new(message).call
      end

      def create_branch(message)
        Ruboty::Github::Actions::CreateBranch.new(message).call
      end

      def create_release(message)
        Ruboty::Github::Actions::CreateRelease.new(message).call
      end

      def get_releases(message)
        Ruboty::Github::Actions::GetReleases.new(message).call
      end

      def get_latest_release(message)
        Ruboty::Github::Actions::GetLatestRelease.new(message).call
      end
    end
  end
end
