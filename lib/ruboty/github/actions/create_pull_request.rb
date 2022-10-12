# frozen_string_literal: true

module Ruboty
  module Github
    module Actions
      class CreatePullRequest < Base
        def call
          if has_access_token?
            create_with_error_handling
          else
            require_access_token
          end
          # Action handlers should return truthy value to tell ruboty that the given message has been handled.
          # Otherwise, ruboty tries to execute other handlers.
          true
        end

        private

        def create_with_error_handling
          create
        rescue Octokit::Unauthorized
          message.reply('Failed in authentication (401)')
        rescue Octokit::NotFound
          message.reply('Could not find that repository')
        rescue StandardError => e
          message.reply("Failed by #{e.class} #{e}")
        end

        def create
          message.reply("Created #{pull_request.html_url}")
        end

        def pull_request
          client.create_pull_request(repository, base, head, title, body)
        end

        def title
          message[:title]
        end

        # e.g. alice/foo:test
        def from
          message[:from]
        end

        # e.g. alice
        def from_user
          from.split('/').first
        end

        # e.g. test
        def from_branch
          from.split(':').last
        end

        # e.g. bob/foo:master
        def to
          message[:to]
        end

        # e.g. bob/foo
        def repository
          to.split(':').first
        end

        # e.g. alice:test
        def head
          "#{from_user}:#{from_branch}"
        end

        # e.g. master
        def base
          to.split(':').last
        end
      end
    end
  end
end
