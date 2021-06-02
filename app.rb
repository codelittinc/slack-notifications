require 'dotenv/load' if ENV["RACK_ENV"] != "production"
require 'sinatra'
require 'gelf'
require './controllers/channel_messages_controller'
require './controllers/direct_messages_controller'
require './controllers/direct_ephemeral_messages_controller'
require './controllers/reactions_controller'
require './controllers/users_controller'

configure do
  set :show_exceptions, false
end

before do
  content_type :json
  return if request.path == '/'

  body = request.body.read

  key = env['HTTP_AUTHORIZATION']
  clean_key = key&.gsub(/Bearer /, '')

  if clean_key != ENV['AUTHENTICATION_KEY']
    halt 401
  end

  @body = JSON.parse body if !body.empty?
end

def render_json json
  response.body = JSON.dump(json)
end

get '/' do
  render_json({status: 200})
end

post '/channel-messages' do
  ChannelMessagesController.new(@body, response).create!
end

patch '/channel-messages' do
  ChannelMessagesController.new(@body, response).update!
end

post '/direct-messages' do
  DirectMessagesController.new(@body, response).create!
end

post '/direct-ephemeral-messages' do
  DirecEphemeraltMessagesController.new(@body, response).create!
end

post '/reactions' do
  ReactionsController.new(@body, response).create!
end

get '/users' do
  UsersController.new(@body, response).index
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