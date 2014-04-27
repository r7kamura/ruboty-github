require "octokit"

module Ellen
  module Github
    module Actions
      class Base
        NAMESPACE = "github"

        attr_reader :message

        def initialize(message)
          @message = message
        end

        private

        def access_tokens
          message.robot.brain.data[NAMESPACE] ||= {}
        end

        def sender_name
          message.from
        end

        def require_access_token
          message.reply("I don't know your github access token")
        end

        def has_access_token?
          !!access_token
        end

        def access_token
          @access_token ||= access_tokens[sender_name]
        end

        def client
          Octokit::Client.new(access_token: access_token)
        end

        def repository
          message[:repo]
        end
      end
    end
  end
end
