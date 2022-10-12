# frozen_string_literal: true

module Ruboty
  module Github
    module Actions
      class SearchIssues < Base
        def call
          if has_access_token?
            search
          else
            require_access_token
          end
        end

        private

        def search
          results = search_issues.items.each_with_object(["Searched: '#{query}'"]) do |item, object|
            repository_url = item[:repository_url].delete_prefix('https://api.github.com/repos/')

            object << "[#{repository_url}##{item[:number]}] #{item[:title]} (#{item[:user][:login]})\n#{item[:html_url]}"
          end

          message.reply(results.join("\n"))
        rescue Octokit::Unauthorized
          message.reply('Failed in authentication (401)')
        rescue Octokit::NotFound
          message.reply('Could not find that repository')
        rescue StandardError => e
          message.reply("Failed by #{e.class}")
        end

        def query
          message[:query]
        end

        def search_issues
          client.search_issues(query)
        end
      end
    end
  end
end
