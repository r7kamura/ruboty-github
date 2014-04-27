module Ellen
  module Github
    module Actions
      class Remember < Base
        def call
          remember
          report
        end

        private

        def report
          message.reply("Remembered #{sender_name}'s github access token")
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
