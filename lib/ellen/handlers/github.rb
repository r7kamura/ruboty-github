module Ellen
  module Handlers
    class Github < Base
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
        /close issue (?<repo>.+)#(?<number>\d+)\z/,
        name: "close_issue",
        description: "Close an issue",
      )

      on(
        /pull request "(?<title>.+)" from (?<from>.+) to (?<to>.+)(?:\n(?<description>[\s\S]+))?\z/,
        name: "create_pull_request",
        description: "Create a pull request",
      )

      on(
        /merge pull request (?<repo>.+)#(?<number>\d+)\z/,
        name: "merge_pull_request",
        description: "Merge pull request",
      )

      def create_issue(message)
        Ellen::Github::Actions::CreateIssue.new(message).call
      end

      def close_issue(message)
        Ellen::Github::Actions::CloseIssue.new(message).call
      end

      def remember(message)
        Ellen::Github::Actions::Remember.new(message).call
      end

      def create_pull_request(message)
        Ellen::Github::Actions::CreatePullRequest.new(message).call
      end

      def merge_pull_request(message)
        Ellen::Github::Actions::MergePullRequest.new(message).call
      end
    end
  end
end
