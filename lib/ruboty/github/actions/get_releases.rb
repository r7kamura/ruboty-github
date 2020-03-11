module Ruboty
  module Github
    module Actions
      class GetReleases < Base
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
            releases_tag_name,
            '```',
          ].join("\n")
        end

        def releases_tag_name
          releases.map do |elm|
            elm.tag_name
          end
        end

        def releases
          client.releases(repository)
        end
      end
    end
  end
end
