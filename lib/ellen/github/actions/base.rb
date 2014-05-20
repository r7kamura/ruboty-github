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
          message.from_name
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
          Octokit::Client.new(client_options)
        end

        def repository
          message[:repo]
        end

        def client_options
          client_options_with_nil_value.reject {|key, value| value.nil? }
        end

        def client_options_with_nil_value
          {
            access_token: access_token,
            api_endpoint: api_endpoint,
            web_endpoint: web_endpoint,
          }
        end

        def web_endpoint
          "https://#{github_host}/" if github_host
        end

        def api_endpoint
          "https://#{github_host}/api/v3" if github_host
        end

        def github_host
          ENV["GITHUB_HOST"]
        end
      end
    end
  end
end
