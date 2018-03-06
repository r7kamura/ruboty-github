module Ruboty
  module Github
    module Actions
      class ShowPullRequest < Base
        def call
          case
          when !has_access_token?
            require_access_token
          else
            show
          end
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that issue")
        rescue => exception
          raise exception
          message.reply("Failed by #{exception.class}")
        end

        private

        def show
          message.reply ":#{name}: [#{state}]#{title}"
        end

        def title
          request.title
        end

        def state
          request.state
        end

        def url
          request.html_url
        end

        def request
          @request ||= client.pull_request(repo, number)
        end

        def name
          File.basename(repo)
        end

        def repo
          message[:repo]
        end

        def number
          message[:number]
        end
      end
    end
  end
end
