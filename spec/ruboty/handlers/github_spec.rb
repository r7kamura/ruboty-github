require "spec_helper"
require "json"

describe Ruboty::Handlers::Github do
  before do
    access_tokens.merge!(sender => stored_access_token)
  end

  let(:robot) do
    Ruboty::Robot.new
  end

  let(:stored_access_token) do
    github_access_token
  end

  let(:github_access_token) do
    "dummy"
  end

  let(:sender) do
    "bob"
  end

  let(:channel) do
    "#general"
  end

  let(:user) do
    "alice"
  end

  let(:repository) do
    "test"
  end

  let(:access_tokens) do
    robot.brain.data[Ruboty::Github::Actions::Base::NAMESPACE] ||= {}
  end

  let(:call) do
    robot.receive(body: body, from: sender, to: channel)
  end

  shared_examples_for "requires access token without access token" do
    context "without access token" do
      let(:stored_access_token) do
        nil
      end

      it "requires access token" do
        Ruboty::Message.any_instance.should_receive(:reply).with("I don't know your github access token")
        call
        a_request(:any, //).should_not have_been_made
      end
    end
  end

  describe "#create_issue" do
    before do
      stub_request(:post, "https://api.github.com/repos/#{user}/#{repository}/issues").
        with(
          body: {
            labels: [],
            title: title,
            body: "",
          }.to_json,
          headers: {
            Authorization: "token #{github_access_token}"
          },
        )
    end

    let(:title) do
      "This is a test issue"
    end

    let(:body) do
      %<ruboty create issue "#{title}" on #{user}/#{repository}>
    end

    include_examples "requires access token without access token"

    context "with access token" do
      it "creates a new issue with given title on given repository" do
        call
        a_request(:any, //).should have_been_made
      end
    end
  end

  describe "#close_issue" do
    before do
      stub_request(:get, "https://api.github.com/repos/#{user}/#{repository}/issues/#{issue_number}").
        with(
          headers: {
            Authorization: "token #{github_access_token}"
          },
        ).
        to_return(
          body: {
            state: issue_status,
            html_url: html_url,
          }.to_json,
          headers: {
            "Content-Type" => "application/json",
          },
        )
      stub_request(:patch, "https://api.github.com/repos/#{user}/#{repository}/issues/#{issue_number}").
        with(
          body: {
            state: "closed",
          }.to_json,
          headers: {
            Authorization: "token #{github_access_token}"
          },
        )
    end

    let(:html_url) do
      "http://example.com/#{user}/#{repository}/issues/#{issue_number}"
    end

    let(:issue_status) do
      "open"
    end

    let(:body) do
      "@ruboty close issue #{user}/#{repository}##{issue_number}"
    end

    let(:issue_number) do
      1
    end

    include_examples "requires access token without access token"

    context "with closed issue" do
      it "replies so" do
        Ruboty::Message.any_instance.should_receive(:reply).with("Closed #{html_url}")
        call
      end
    end

    context "with access token" do
      it "closes specified issue" do
        call
      end
    end
  end

  describe "#remember" do
    let(:body) do
      "@ruboty remember my github token #{github_access_token}"
    end

    it "remembers sender's access token in its brain" do
      Ruboty::Message.any_instance.should_receive(:reply).with("Remembered #{sender}'s github access token")
      call
      access_tokens[sender].should == github_access_token
    end
  end

  describe "#create_branch" do
    let(:from_branch) do
      "master"
    end

    let(:to_branch) do
      "hotfix"
    end

    let(:sha) do
      "8d265b39db79a2871427563ca51c28ca197ce0ff"
    end

    before do
      stub_request(:get, "https://api.github.com/repos/#{user}/#{repository}/branches/#{from_branch}").
        with(
          headers: {
            Authorization: "token #{github_access_token}"
          },
        ).
        to_return(
          body: {
            commit: {
              sha: sha,
            },
          }.to_json,
          headers: {
            "Content-Type" => "application/json",
          },
        )

      stub_request(:post, "https://api.github.com/repos/#{user}/#{repository}/git/refs").
        with(
          body: {
            ref: "refs/heads/#{to_branch}",
            sha: sha,
          }.to_json,
          headers: {
            Authorization: "token #{github_access_token}"
          },
        )

      stub_request(:get, "https://api.github.com/repos/#{user}/#{repository}/branches/#{to_branch}").
        with(
          headers: {
            Authorization: "token #{github_access_token}"
          },
        ).
        to_return(
          body: {
            _links: {
              html: "https://github.com/#{user}/#{repository}/tree/#{to_branch}",
            },
          }.to_json,
          headers: {
            "Content-Type" => "application/json",
          }
        )
    end

    let(:body) do
      %<ruboty create branch #{to_branch} from #{user}/#{repository}:#{from_branch}>
    end

    include_examples "requires access token without access token"

    context "with access token" do
      it "creates a new branch" do
        Ruboty::Message.any_instance.should_receive(:reply).with("Created https://github.com/#{user}/#{repository}/tree/#{to_branch}")
        call
        a_request(:any, //).should have_been_made.times(3)
      end
    end
  end

  describe "#create_release" do
    before do
      stub_request(:post, "https://api.github.com/repos/#{user}/#{repository}/releases").
        with(
          body: {
            name: version,
            tag_name: version,
          }.to_json,
          headers: {
            Authorization: "token #{github_access_token}",
          },
        ).
        to_return(
          status: 200,
          body: {
            html_url: html_url,
          }.to_json,
          headers: {
            'Content-Type': 'application/json',
          },
        )
    end

    let(:html_url) do
      "https://github.com/#{user}/#{repository}/releases/#{version}"
    end

    let(:version) do
      "1.2.3"
    end

    let(:body) do
      %<ruboty create release #{user}/#{repository} #{version}>
    end

    include_examples "requires access token without access token"

    context "with access token" do
      it "creates a new release with given versin name on given repository" do
        Ruboty::Message.any_instance.should_receive(:reply).with("Created #{html_url}")
        call
        a_request(:any, //).should have_been_made
      end
    end

    context "with valid release name prefix" do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('RELEASE_NAME_PREFIX').and_return('v')
      end

      let!(:version) do
        "v1.2.3"
      end

      it "creates a new release with given versin name on given repository" do
        Ruboty::Message.any_instance.should_receive(:reply).with("Created #{html_url}")
        call
        a_request(:any, //).should have_been_made
      end
    end
  end

  describe "#list_pull_requests" do
    before do
      stub_request(:get, "https://api.github.com/repos/#{user}/#{repository}/pulls?state=open").
        with(
          headers: {
            Authorization: "token #{github_access_token}"
          },
        ).
        to_return(
          status: 200,
          headers: {
            'Content-Type': 'application/json',
          },
          body: [
            {
              url: pr_url,
              title: pr_title,
            },
          ].to_json,
        )
    end

    let(:body) do
      %<ruboty list pull request #{user}/#{repository}>
    end

    let(:pr_url) do
      "https://github.com/#{user}/#{repository}/pulls/1"
    end

    let(:pr_title) do
      "Dummy Pull Request"
    end

    include_examples "requires access token without access token"

    context 'with access token' do
      it 'list pull requires in specified repository' do
        Ruboty::Message.any_instance.should_receive(:reply).with("```\n[#{pr_url}] #{pr_title}\n```")
        call
        a_request(:any, //).should have_been_made
      end
    end
  end
end
