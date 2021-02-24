class ApplicationController
  def initialize(params, response)
    Slack.configure do |config|
      config.token = ENV['SLACK_API_KEY']
    end
    @params = JSON.parse(params.to_json, symbolize_name: true)
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