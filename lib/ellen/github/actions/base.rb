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
      end
    end
  end
end
