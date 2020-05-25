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
            body: changelog,
          }
        end

        def version
          [
            release_name_prefix,
            incremented_version,
          ].join
        end

        def incremented_version
          [
            latest_version.segments[0],
            latest_version.segments[1],
            latest_version.segments[2] + 1,
          ].join('.')
        end

        def latest_version
          Gem::Version.new(
            latest_release_version_number,
          )
        end

        def latest_release_version_number
          range_start = latest_release_tag_name_matched_to_prefix? ? release_name_prefix_length : 0
          latest_release_tag_name.slice(
            Range.new(
              range_start,
              -1,
            )
          )
        end

        def latest_release_tag_name_matched_to_prefix?
          release_name_regexp.match?(latest_release_tag_name)
        end

        def latest_release_tag_name
          latest_release.tag_name
        end

        def latest_release
          client.latest_release(repository)
        end

        def valid_release_name?
          release_name_regexp.match?(version)
        end

        def release_name_regexp
          /#{release_name_prefix}(\d+\.)?(\d+\.)?(\d+)$/
        end

        def release_name_prefix_length
          @release_name_prefix_length ||= release_name_prefix.length
        end

        def release_name_prefix
          @release_name_prefix ||= ENV["RELEASE_NAME_PREFIX"] || ""
        end

        def changelog
          return "No diffs found" if commit_diffs.commits.length.zero?

          commit_diffs.commits.map do |elm|
            if elm.commit.committer.name == "GitHub"
              num = elm.commit.message[/Merge pull request #(\d+) from/, 1]

              next unless num

              "[##{num}](#{pull_request_link(num)}) #{pull_request_title(num)}"
            else
              nil
            end
          end.compact.reverse.join("\n")
        end

        def pull_request_title(number)
          pull_request(number).title
        end

        def pull_request(number)
          client.pull_request(repository, number)
        end

        def pull_request_link(number)
          "https://github.com/#{repository}/pull/#{number}"
        end

        def commit_diffs
          client.compare(repository, latest_release_tag_name, 'master')
        end

        def latest_release_tag_name
          latest_release.tag_name
        end

        def latest_release
          client.latest_release(repository)
        end
      end
    end
  end
end
