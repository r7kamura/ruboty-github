module Ruboty
  module Github
    module Actions
      class GetCommitDiff < Base
        def call
          if has_access_token?
            get
          else
            require_access_token
          end
        end

        private

        def get
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
            commit_diff_messages.to_s,
            '```',
          ].join("\n")
        end

        def commit_diff_messages
          commit_diffs.commits.map do |elm|
            {
              message: elm.commit.message,
              committer: elm.commit.committer.name,
            }
          end.join("\n")
        end

        def commit_diffs
          client.compare(repository, message[:base], message[:head])
        end
      end
    end
  end
end
