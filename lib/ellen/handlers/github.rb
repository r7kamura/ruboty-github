require "octokit"

module Ellen
  module Handlers
    class Github < Base
      on(/create issue "(?<title>.+)" on (?<repo>.+)\z/, name: "create_issue", description: "Create a new issue")

      env :GITHUB_ACCESS_TOKEN, "Github Access Token"

      def create_issue(message)
        client.create_issue(message[:repo], message[:title], nil)
      end

      private

      def client
        @client ||= Octokit::Client.new(access_token: access_token)
      end

      def access_token
        ENV["GITHUB_ACCESS_TOKEN"]
      end
    end
  end
end
