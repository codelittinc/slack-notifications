require './controllers/application_controller'
require 'slack-ruby-client'

class DirecEphemeraltMessagesController < ApplicationController

  DEFAULT_PRIVATE_MESSAGE_CHANNEL = 'directmessage'.freeze

  def create!
    response = client.chat_postEphemeral(
      user: formatted_username,
      channel: channel,
      text: message,
      blocks: blocks
    )

    respond!(response)
  end

  private

  def formatted_username
    "@#{@params[:username]}"
  end

  def channel
    channel_param.to_s.strip.empty? || channel_param == DEFAULT_PRIVATE_MESSAGE_CHANNEL ? formatted_username : channel_param
  end

  def channel_param
    @params[:channel]
  end

  def blocks
    @params[:blocks]
  end
end