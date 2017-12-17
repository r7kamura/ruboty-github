module Ruboty
  module Github
    module Actions
      class CreateBranch < Base
        def call
          if has_access_token?
            create
          else
            require_access_token
          end
        end

        private

        def create
          message.reply("Created #{create_branch._links.html}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}")
        end

        def create_branch
          sha = client.branch(from_repo, from_branch).commit.sha
          client.create_ref(from_repo, "heads/#{to_branch}", sha)
          client.branch(from_repo, to_branch)
        end

        # e.g. new-branch-name
        def to_branch
          message[:to_branch]
        end

        # e.g. alice/foo:test
        def from
          message[:from]
        end

        # e.g. alice/foo
        def from_repo
          from.split(":").first
        end

        # e.g. test
        def from_branch
          from.split(":").last
        end
      end
    end
  end
end
