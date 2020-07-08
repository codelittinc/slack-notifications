require './controllers/application_controller'
require 'slack-ruby-client'

class DirectMessagesController < ApplicationController
  def create!
    response = client.chat_postMessage(channel: formatted_username, text: message)

    respond!(response)
  end

  def formatted_username
    "@#{@params[:username]}"
  end
end