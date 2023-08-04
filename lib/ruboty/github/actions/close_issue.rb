# frozen_string_literal: true

module Ruboty
  module Github
    module Actions
      class CloseIssue < Base
        def call
          if !has_access_token?
            require_access_token
          elsif has_closed_issue_number?
            reply_already_closed
          else
            close
          end
        rescue Octokit::Unauthorized
          message.reply('Failed in authentication (401)')
        rescue Octokit::NotFound
          message.reply('Could not find that issue')
        rescue StandardError => e
          message.reply("Failed by #{e.class}")
          raise e
        end

        private

        def close
          request
          message.reply("Closed #{issue.html_url}")
        end

        def request
          client.close_issue(repository, issue_number)
        end

        def has_closed_issue_number?
          issue.state == 'closed'
        end

        def reply_already_closed
          message.reply("Already closed #{issue.html_url}")
        end

        def issue
          @issue ||= client.issue(repository, issue_number)
        end

        def issue_number
          message[:number]
        end
      end
    end
  end
end
