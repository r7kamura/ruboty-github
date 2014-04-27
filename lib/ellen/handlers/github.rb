module Ellen
  module Handlers
    class Github < Base
      on(/create issue "(?<title>.+)" on (?<repo>.+)\z/, name: "create_issue", description: "Create a new issue")

      on(/remember my github token (?<token>.+)\z/, name: "remember", description: "Remember sender's GitHub access token")

      def create_issue(message)
        Ellen::Github::Actions::CreateIssue.new(message).call
      end

      def remember(message)
        Ellen::Github::Actions::Remember.new(message).call
      end
    end
  end
end
