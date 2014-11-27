module Ruboty
  module Github
    module Actions
      class Deploy < Base
        def prepare_sandbox
          return require_access_token unless has_access_token?
          create_branch('heads/sandbox_master', 'master')
          update_branch('heads/deployment/sandbox', 'master')

          message.reply 'sandbox branch is created'
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}")
        end

        def deploy_sandbox
          return require_access_token unless has_access_token?
          pr = pull_request('deployment/sandbox', 'sandbox_master', 'Deploy to sandbox', '')

          message.reply("Created #{pr.html_url}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}")
        end

        private
        def pull_request(base, head, title, description)
          client.create_pull_request(repository, base, head, title, description)
        end

        def create_branch(name, branch)
          client.create_ref(repository, name, sha1(branch))
        end

        def update_branch(name, branch)
          client.update_ref(repository, name, sha1(branch), true)
        end

        def sha1(branch)
          client.branch(repository, branch).commit.sha
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

        # e.g. bob/foo
        def repository
          message[:repo]
        end
      end
    end
  end
end
