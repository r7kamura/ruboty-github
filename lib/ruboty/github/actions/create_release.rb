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
          message.reply("#{create_release}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}")
        end

        def create_release
          if valid_release_name?
            @response ||= client.create_release(repository, version, options)
            "Created #{@response.html_url}"
          else
            "Invalid release name was passed"
          end
        end

        def options
          {
            name: version,
          }
        end

        def valid_release_name?
          release_name_regexp.match?(version)
        end

        def release_name_regexp
          /#{release_name_prefix}(\d+\.)?(\d+\.)?(\d+)$/
        end

        def release_name_prefix
          @release_name_prefix ||= ENV["RELEASE_NAME_PREFIX"] || ""
        end

        def version
          @version ||= message[:version]
        end
      end
    end
  end
end
