require 'dotenv/load'
require 'sinatra'
require './controllers/channel_messages_controller'
require './controllers/direct_messages_controller'
require './controllers/direct_ephemeral_messages_controller'
require './controllers/reactions_controller'
require './controllers/users_controller'

before do
  content_type :json
  body = request.body.read

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