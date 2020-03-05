module Ruboty
  module Github
    module Actions
      class CreateRelease < Base
        def call
          if has_access_token?
            create
          else
            require_access_token
          end
        end

        private

        def create
          message.reply("Created #{create_release.html_url}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}")
        end

        def create_release
          @create_release ||= client.create_release(repository, version, options)
        end

        def version
          message[:version]
        end

        def options
          {
            name: version,
          }
        end
      end
    end
  end
end
