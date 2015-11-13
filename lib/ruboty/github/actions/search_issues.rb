module Ruboty
  module Github
    module Actions
      class SearchIssues < Base
        def call
          if has_access_token?
            list
          else
            require_access_token
          end
        end

        private

        def list
          message.reply(search_summary, code: true)
        end

        def search_summary
          issues.map { |issue| issue_description(issue) }.join("\n")
        end

        def issue_description(issue)
          %<%s by %s %s> % [issue.title, issue.user.login, issue.html_url]
        end

        def issues
          search_result.items
        end

        def search_result
          client.search_issues(query)
        end

        def query
          message[:query]
        end
      end
    end
  end
end
