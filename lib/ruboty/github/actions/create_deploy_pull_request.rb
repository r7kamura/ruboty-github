module Ruboty
  module Github
    module Actions
      class CreateDeployPullRequest < CreatePullRequest
        private

        def create
          super

          if database_schema_changed?
            message.reply("@here :warning: This deployment includes some database migrations")
          end
        end

        # e.g. master
        def to_branch
          to.split(":").last
        end

        def body
           lines = included_pull_requests.map do |pr|
             "- [##{pr[:number]}](#{pr[:html_url]}): #{pr[:title]} by @#{pr[:user][:login]}"
           end
           lines.unshift('## Pull Requests to deploy', '')
           lines.join("\n")
        end

        def included_pull_requests
          numbers = comparison.commits.map do |commit|
            /^Merge pull request #(\d+) from/ =~ commit[:commit][:message]
            $1
          end
          numbers.compact.map { |number| client.pull_request(repository, number.to_i) }
        end

        def database_schema_changed?
          comparison.files.any? { |file| file.filename == 'db/schema.rb' }
        end

        def comparison
          @comparison ||= begin
            start = client.branch(repository, to_branch)[:commit][:sha]
            endd  = client.branch(repository, from_branch)[:commit][:sha]
            client.compare(repository, start, endd)
          end
        end
      end
    end
  end
end
