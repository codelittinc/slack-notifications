require './controllers/application_controller'
require 'slack-ruby-client'

class ChannelMessagesController < ApplicationController
  def create!
    response = {}
    begin
      response = client.chat_postMessage(channel: formatted_channel, text: message, thread_ts: ts, link_names: true)
    rescue Slack::Web::Api::Errors::TooManyRequestsError
      response = {error: 'Too many messages'}
    end
    respond!(response)
  end

  def update!
    response = client.chat_update(channel: formatted_channel, text: message, ts: ts, link_names: true)

    respond!(response)
  end

  private

  def formatted_channel
    "\##{@params[:channel]}"
  end

  def ts
    @params[:ts]
  end
end