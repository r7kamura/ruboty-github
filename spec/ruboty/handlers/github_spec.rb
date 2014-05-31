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
        Ruboty.logger.should_receive(:info).with("I don't know your github access token")
        call
        a_request(:any, //).should_not have_been_made
      end
    end
  end

  describe "#create_issue" do
    before do
      stub_request(:post, "https://github.com/api/v3/repos/#{user}/#{repository}/issues").
        with(
          body: {
            labels: nil,
            title: title,
            body: nil,
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
      stub_request(:get, "https://github.com/api/v3/repos/#{user}/#{repository}/issues/#{issue_number}").
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
      stub_request(:patch, "https://github.com/api/v3/repos/#{user}/#{repository}/issues/#{issue_number}").
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
        Ruboty.logger.should_receive(:info).with("Closed #{html_url}")
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
      Ruboty.logger.should_receive(:info).with("Remembered #{sender}'s github access token")
      call
      access_tokens[sender].should == github_access_token
    end
  end
end
