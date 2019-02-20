module Ruboty
  module Github
    module Actions
      class PushBranch < Base
        def initialize(message, force: false)
          super(message)

          @force = force
        end

        def call
          if has_access_token?
            push
          else
            require_access_token
          end
        end

        private

        def push
          update_branch
          message.reply("Updated #{ref} with #{commit_link}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}")
        end

        def commit_link
          # branch._links.html ではブランチ名のtree viewになり、ブランチが更新されるとあとから追えない
          # このためsha1を使ったリンクを生成する
          "https://github.com/#{repository}/commits/#{sha1}"
        end

        def update_branch
          client.update_branch(repository, ref, sha1, @force)
        end

        def ref
          message[:name]
        end

        def sha1
          @sha1 ||= client.branch(repository, from_branch).commit.sha
        end

        # e.g. alice/foo:test
        def from_branch
          message[:from]
        end

        # e.g. bob/foo
        def repository
          message[:repo]
        end
      end
    end
  end
end
