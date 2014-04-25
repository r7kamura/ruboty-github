require "spec_helper"
require "json"

describe Ellen::Handlers::Github do
  before do
    ENV["GITHUB_ACCESS_TOKEN"] = github_access_token
  end

  after do
    ENV["GITHUB_ACCESS_TOKEN"] = nil
  end

  let(:robot) do
    Ellen::Robot.new
  end

  let(:github_access_token) do
    "dummy"
  end

  describe "#initialize" do
    context "without GITHUB_ACCESS_TOKEN" do
      let(:github_access_token) do
        nil
      end

      it "dies" do
        Ellen.should_receive(:die)
        described_class.new(robot)
      end
    end

    context "with GITHUB_ACCESS_TOKEN" do
      it "does not die" do
        Ellen.should_not_receive(:die)
        described_class.new(robot)
      end
    end
  end

  describe "#create_issue" do
    before do
      stub_request(:post, "https://api.github.com/repos/#{user}/#{repository}/issues").
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

    let(:user) do
      "alice"
    end

    let(:repository) do
      "test"
    end

    let(:title) do
      "This is a test issue"
    end

    it "creates a new issue with given title on given repository" do
      robot.receive(body: %<ellen create issue "#{title}" on #{user}/#{repository}>)
    end
  end
end
