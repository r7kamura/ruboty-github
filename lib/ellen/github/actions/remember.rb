module Ellen
  module Github
    module Actions
      class Remember < Base
        attr_reader :message, :robot

        def initialize(options)
          @message = options[:message]
          @robot = options[:robot]
        end

        def call
          remember
          report
        end

        private

        def report
          robot.say("Remembered #{robot.name}'s github access token")
        end

        def remember
          access_tokens[sender_name] = given_access_token
        end

        def given_access_token
          message[:token]
        end
      end
    end
  end
end
