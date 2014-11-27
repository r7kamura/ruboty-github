module Ruboty
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

        def body
          message[:description] || ""
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
          @access_token ||= (access_tokens[sender_name] || default_access_token)
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
          "#{github_base_url}/" if github_base_url
        end

        def api_endpoint
          "#{github_base_url}/api/v3" if github_base_url
        end

        # @note GITHUB_HOST will be deprecated on the next major version
        def github_base_url
          case
          when ENV["GITHUB_BASE_URL"]
            ENV["GITHUB_BASE_URL"]
          when ENV["GITHUB_HOST"]
            "https://#{ENV['GITHUB_HOST']}"
          end
        end

        def default_access_token
          ENV["GITHUB_ACCESS_TOKEN"]
        end
      end
    end
  end
end
