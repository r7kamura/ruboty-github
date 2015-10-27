module Ruboty
  module Github
    module Actions
      class CreateDeployPullRequest < Base
        def call
          if has_access_token?
            create
          else
            require_access_token
          end
        end

        private

        def create
          message.reply("Created #{pull_request.html_url}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}")
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
          from.split("/").first
        end

        # e.g. test
        def from_branch
          from.split(":").last
        end

        # e.g. bob/foo:master
        def to
          message[:to]
        end

        # e.g. master
        def to_branch
          to.split(":").last
        end

        # e.g. bob/foo
        def repository
          to.split(":").first
        end

        # e.g. alice:test
        def head
          "#{from_user}:#{from_branch}"
        end

        # e.g. master
        def base
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
          pull_requests = client.pull_requests(repository, :state => 'closed')

          numbers = compare(repository, to_branch, from_branch).commits.map do |commit|
            /^Merge pull request #(\d+) from/ =~ commit[:commit][:message]
            $1
          end
          numbers = numbers.compact.map {|n| n.to_i }
          numbers.map do |n|
            pull_requests.find {|pr| pr[:number] == n }
          end
        end

        def compare(repository, to_branch, from_branch)
          start = ""
          endd  = ""
          client.branches(repository).each do |branch|
            start = branch[:commit][:sha] if branch[:name] == to_branch
            endd  = branch[:commit][:sha] if branch[:name] == from_branch
          end
          client.compare(repository, start, endd)
        end
      end
    end
  end
end
