require "octokit"

module Ellen
  module Github
    module Actions
      class Base
        NAMESPACE = "github"

        attr_reader :message, :robot

        def initialize(options)
          @message = options[:message]
          @robot = options[:robot]
        end

        private

        def access_tokens
          robot.brain.data[NAMESPACE] ||= {}
        end

        def sender_name
          message.from
        end
      end
    end
  end
end
