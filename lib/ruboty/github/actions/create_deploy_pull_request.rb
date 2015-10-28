module Ruboty
  module Github
    module Actions
      class CreateDeployPullRequest < CreatePullRequest
        private

        # e.g. master
        def to_branch
          to.split(":").last
        end

        def body
           body = "## Pull Request to deloy\n\n"
           pull_requests_to_deploy(repository, to_branch, from_branch).each do |pr|
             body = body + [
               "-",
               "[##{pr[:number]}](#{pr[:html_url]}):",
               pr[:title],
               "by",
               "@#{pr[:head][:user][:login]}\n",
             ].join(' ')
           end
           body
        end

        def pull_requests_to_deploy(repository, to_branch, from_branch)
          numbers = compare(repository, to_branch, from_branch).commits.map do |commit|
            /^Merge pull request #(\d+) from/ =~ commit[:commit][:message]
            $1
          end
          numbers.compact.map { |n| client.pull_request(repository, n.to_i) }
        end

        def compare(repository, to_branch, from_branch)
          start = client.branch(repository, to_branch)[:commit][:sha]
          endd  = client.branch(repository, from_branch)[:commit][:sha]
          client.compare(repository, start, endd)
        end
      end
    end
  end
end
