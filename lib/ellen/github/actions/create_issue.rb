require "octokit"

module Ellen
  module Github
    module Actions
      class CreateIssue < Base
        def call
          if has_access_token?
            create
          else
            require_access_token
          end
        end

        private

        def require_access_token
          message.reply("I don't know your github access token")
        end

        def created
          message.reply("Created a new Issue")
        end

        def create
          message.reply("Created #{issue.html_url}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class}")
        end

        def issue
          client.create_issue(repository, title, body)
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

        def title
          message[:title]
        end

        def body
          nil
        end
      end
    end
  end
end
