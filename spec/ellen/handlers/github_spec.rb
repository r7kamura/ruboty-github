require "spec_helper"
require "json"

describe Ellen::Handlers::Github do
  let(:robot) do
    Ellen::Robot.new
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

  let(:access_tokens) do
    robot.brain.data[Ellen::Github::Actions::Base::NAMESPACE] ||= {}
  end

  describe "#create_issue" do
    before do
      Ellen.logger.stub(:info)
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

    let(:body) do
      %<ellen create issue "#{title}" on #{user}/#{repository}>
    end

    context "when access token for the sender is remembered" do
      before do
        access_tokens.merge!(sender => github_access_token)
      end

      it "creates a new issue with given title on given repository" do
        robot.receive(
          body: body,
          from: sender,
          to: channel,
        )
        a_request(:any, //).should have_been_made
      end
    end

    context "when access token for the sender is not remembered" do
      it "does not create a new issue" do
        robot.receive(
          body: body,
          from: sender,
          to: channel,
        )
        a_request(:any, //).should_not have_been_made
      end
    end
  end

  describe "#remember" do
    let(:body) do
      "@ellen remember my github token #{github_access_token}"
    end

    it "remembers sender's access token in its brain" do
      Ellen.logger.should_receive(:info).with("Remembered #{sender}'s github access token")
      robot.receive(
        body: body,
        from: sender,
        to: channel,
      )
      access_tokens[sender].should == github_access_token
    end
  end
end
