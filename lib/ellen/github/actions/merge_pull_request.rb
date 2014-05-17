module Ellen
  module Github
    module Actions
      class MergePullRequest < CloseIssue
        private

        def close
          request
          message.reply("Merged #{issue.html_url}")
        end

        def request
          client.merge_pull_request(repository, issue_number)
        end
      end
    end
  end
end
