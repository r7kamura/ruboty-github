require 'pp'

module Ruboty
  module Github
    module Actions
      class ShowUndeployedPullRequests < Base
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
          if merge_pull_requests.empty?
            message.reply 'No pull requests have been merged since the last deployment.'
          else
            r = Regexp.union(
              /\AMerge pull request (?<number>\#\d+).*\n\n(?<title>.+)/,
              /\A(?<title>.+) \((?<number>#\d+)\)/)
            merge_pull_requests.each do |text|
              m = text.match(r) { |t| "#{t[:number]} #{t[:title]}" }
              message.reply m
            end
          end
        end

        def merge_pull_requests
          @merge_pull_requests ||= commits[:commits].map {|commit|
            commit[:commit][:message]
          }.grep(/(\A.+ \(#\d+\)|\AMerge pull request)/)
        end

        def commits
          @commits ||= client.compare(repo, latest_deploy, 'master')
        end

        def latest_deploy
          'release/main'
        end

        def repo
          message[:repo]
        end
      end
    end
  end
end
