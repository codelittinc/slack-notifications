require './controllers/application_controller'
require 'slack-ruby-client'
require 'pry'

class ReactionsController < ApplicationController
  def index
    response = list
    respond!(response)
  end

  def create!
    #@TODO: remove this cleaning from this method
    clean_reactions!

    response = client.reactions_add(
      channel: formatted_channel,
      name: reaction,
      timestamp: ts
    )

    respond!(response)
  end

  private

  def reaction 
    @params[:reaction]
  end

  def formatted_channel
    "\##{@params[:channel]}"
  end

  def ts
    @params[:ts]
  end

  def clean_reactions!
    reactions = list_reactions
    reactions.each do |reaction|
      remove_reaction!(reaction["name"])
    end
  end

  def list_reactions
    response = client.reactions_get(
      channel: formatted_channel,
      timestamp: ts
    )
    response["message"]["reactions"]
  end

  def remove_reaction!(name)
    client.reactions_remove(
      name: name,
      timestamp: ts,
      channel: formatted_channel
    )
  end
end