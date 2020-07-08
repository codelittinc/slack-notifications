require './controllers/application_controller'
require 'slack-ruby-client'

class ChannelMessagesController < ApplicationController
  def create!
    response = client.chat_postMessage(channel: formatted_channel, text: message)

    respond!(response)
  end

  def update!
    response = client.chat_update(channel: formatted_channel, text: message, ts: @params[:ts])

    respond!(response)
  end

  private

  def formatted_channel
    "\##{@params[:channel]}"
  end
end