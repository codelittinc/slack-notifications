class ApplicationController
  def initialize(params, response, slack_team_key = nil)
    Slack.configure do |config|
      config.token = slack_team_key || ENV['SLACK_API_KEY']
    end

    @params = params&.with_indifferent_access
    @response = response
  end

  def respond!(json)
    @response.body = JSON.dump(json)
  end
  def message
    @params[:message]
  end

  def client
    return @client if @client

    @client = Slack::Web::Client.new
  end
end