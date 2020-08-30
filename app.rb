require 'dotenv/load' if ENV["RACK_ENV"] != "production"

require 'sinatra'
require 'gelf'
require './controllers/channel_messages_controller'
require './controllers/direct_messages_controller'
require './controllers/direct_ephemeral_messages_controller'
require './controllers/reactions_controller'
require './controllers/users_controller'
require './models/access_tokens'
require './services/slack_oauth'

configure do
  set :show_exceptions, false
end

def authenticate!
  key = env['HTTP_AUTHORIZATION']
  clean_key = key&.gsub(/Bearer /, '')

  if clean_key != ENV['AUTHENTICATION_KEY']
    halt 401
  end
end

before do
  content_type :json
  body = request.body.read

  @body = JSON.parse body if !body.empty?

  if (@body && @body["team"])
    @slack_team_key = AccessTokens.new.by_team_id(@body["team"])[:value]
  end
end

def render_json json
  response.body = JSON.dump(json)
end

get '/' do
  render_json({status: 200})
end

post '/channel-messages' do
  authenticate!
  ChannelMessagesController.new(@body, response, @slack_team_key).create!
end

patch '/channel-messages' do
  authenticate!
  ChannelMessagesController.new(@body, response, @slack_team_key).update!
end

post '/direct-messages' do
  authenticate!
  DirectMessagesController.new(@body, response, @slack_team_key).create!
end

post '/direct-ephemeral-messages' do
  authenticate!
  DirecEphemeraltMessagesController.new(@body, response, @slack_team_key).create!
end

post '/reactions' do
  authenticate!
  ReactionsController.new(@body, response, @slack_team_key).create!
end

get '/users' do
  authenticate!
  UsersController.new(@body, response, @slack_key).index
end

get '/oauth' do
  code = params[:code]
  data = SlackOauth.new(code).authenticate!
  access_token = data.with_indifferent_access[:access_token]
  team_id = data.with_indifferent_access[:team][:id]

  AccessTokens.new.create!(access_token, team_id)

  response.body = JSON.dump({
    status: 'success'
  })
end

error do
  err =  env['sinatra.error']
  # log errors
  log = GELF::Logger.new("logs.codelitt.dev", 12201, "WAN", { host: ENV['LOG_HOST'], environment: ENV['LOG_ENV'] })
  log.error ["ERROR: #{err.to_s}", @body.to_s, err.backtrace].flatten.join("\n")

  # render error summary
  status 400
  render_json({ error: err.to_s })
end