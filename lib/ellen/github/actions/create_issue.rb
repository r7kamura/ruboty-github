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

        def title
          message[:title]
        end

        def body
          message[:description]
        end
      end
    end
  end
end
