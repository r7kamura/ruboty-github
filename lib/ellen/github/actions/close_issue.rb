module Ellen
  module Github
    module Actions
      class CloseIssue < Base
        def call
          case
          when !has_access_token?
            require_access_token
          when has_closed_issue_number?
            reply_already_closed
          else
            close
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

        def close
          request
          message.reply("Closed #{issue.html_url}")
        end

        def request
          client.close_issue(repository, issue_number)
        end

        def has_closed_issue_number?
          issue.state == "closed"
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
