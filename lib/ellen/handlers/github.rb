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

      def create_issue(message)
        Ellen::Github::Actions::CreateIssue.new(message).call
      end

      def close_issue(message)
        Ellen::Github::Actions::CloseIssue.new(message).call
      end

      def remember(message)
        Ellen::Github::Actions::Remember.new(message).call
      end
    end
  end
end
