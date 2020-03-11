module Ruboty
  module Github
    module Actions
      class GetLatestRelease < Base
        def call
          if has_access_token?
            get
          else
            require_access_token
          end
        end

        private

        def get
          message.reply("#{repository}:#{latest_release.tag_name}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}")
        end

        def latest_release
          client.latest_release(repository)
        end
      end
    end
  end
end
