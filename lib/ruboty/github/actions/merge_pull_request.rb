# frozen_string_literal: true

module Ruboty
  module Github
    module Actions
      class MergePullRequest < CloseIssue
        private

        def close
          request
          after_merge_message
        end

        def request
          client.merge_pull_request(repository, issue_number)
        end

        def after_merge_message
          message.reply("Merged #{issue.html_url}")

          custom_message = ENV.fetch('AFTER_MERGE_MESSAGE', nil)
          target_repository = ENV.fetch('AFTER_MERGE_MESSAGE_TARGET_REPOSITORY', '')

          return true unless (repository == target_repository) && custom_message

          message.reply(custom_message)
        end
      end
    end
  end
end
