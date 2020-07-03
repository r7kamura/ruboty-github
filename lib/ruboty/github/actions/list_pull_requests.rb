module Ruboty
  module Github
    module Actions
      class ListPullRequests < Base
        def call
          if has_access_token?
            list
          else
            require_access_token
          end
        end

        private

        def list
          message.reply("#{text}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}")
        end

        def text
          [
            '```',
            pull_request_links,
            '```',
          ].join("\n")
        end

        def pull_request_links
          pull_requests.map do |pull_request|
            "[#{pull_request.url}] #{pull_request.title}"
          end
        end

        def pull_requests
          client.pull_requests(repository, state: 'open')
        end
      end
    end
  end
end
