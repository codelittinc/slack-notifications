require './controllers/application_controller'
require 'slack-ruby-client'

class DirecEphemeraltMessagesController < ApplicationController
  def create!
    response = client.chat_postEphemeral(
      user: formatted_username,
      channel: formatted_username,
      text: message,
      blocks: blocks
    )

    respond!(response)
  end

  private

  def formatted_username
    "@#{@params[:username]}"
  end

  def blocks
    @params[:blocks]
  end
end