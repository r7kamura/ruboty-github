module Ellen
  module Github
    module Actions
      class CreatePullRequest < Base
        def call
          if has_access_token?
            create
          else
            require_access_token
          end
        end

        private

        def create
          message.reply("Created #{pull_request.html_url}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class}")
        end

        def pull_request
          client.create_pull_request(repository, base, title, body)
        end

        def title
          message[:title]
        end

        def description
          message[:description]
        end

        # e.g. alice/foo:test
        def from
          message[:from]
        end

        # e.g. alice
        def from_user
          from.split("/").first
        end

        # e.g. test
        def from_branch
          from.split("/").last
        end

        # e.g. bob/foo:master
        def to
          message[:to]
        end

        # e.g. bob/foo
        def repository
          to.split(":").first
        end

        # e.g. alice:test
        def head
          "#{from_user}:#{from_branch}"
        end

        # e.g. master
        def base
          to.split(":").last
        end
      end
    end
  end
end
