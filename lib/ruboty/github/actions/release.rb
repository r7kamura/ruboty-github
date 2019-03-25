module Ruboty
  module Github
    module Actions
      class Release < Base
        def initialize(message, prefix, from_env)
          super(message)

          @prefix = prefix
          @from_env = from_env
        end

        def call
          return require_access_token unless has_access_token?

          c = create_empty_commit('master', 'Open PR')
          create_branch("heads/env/#{@from_env}", c.sha)
          pr = pull_request("#{prefix}/#{name}",
                            "env/#{@from_env}",
                            "#{Time.now.strftime('%Y-%m-%d')} Deploy to #{name} by #{message.from_name}",
                            description)
          message.reply("Created #{pr.html_url}")
        rescue Octokit::UnprocessableEntity => e
          raise e unless /Reference already exists/.match?(e.message)
          message.reply("Oops! A branch named 'env/#{@from_env}' already exists.")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}\n#{exception.backtrace}")
        end

        private

        attr_reader :prefix

        def pull_request(base, head, title, description)
          client.create_pull_request(repository, base, head, title, description)
        end

        def create_branch(name, sha1)
          client.create_ref(repository, name, sha1)
        end

        def update_branch_with_empty_commit(name, branch)
          # We add an empty commit so that the webhook push event caused by update_ref has `forced: true` status
          # even if this action is called twice without merging a deployment PR.
          new_commit = create_empty_commit(branch, 'Deployment')
          client.update_ref(repository, name, new_commit.sha, true)
        end

        def create_empty_commit(branch, message)
          current = client.branch(repository, branch)
          client.create_commit(repository, message,
                               current.commit.commit.tree.sha,
                               current.commit.sha)
        end

        def branch
          message[:branch]
        end

        # e.g. sandbox
        def name
          message[:name]
        end

        # e.g. alice
        def from_user
          from.split("/").first
        end

        # e.g. bob/foo
        def repository
          message[:repo]
        end

        def format(str)
          str.to_s.gsub('\n',"\n")
        end

        def description
          format(ENV["GITHUB_PR_DESCRIPTION_RELEASE"] || ENV['GITHUB_PR_DESCRIPTION'] || '')
        end
      end
    end
  end
end
