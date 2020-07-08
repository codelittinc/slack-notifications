require './controllers/application_controller'
require 'slack-ruby-client'
require 'pry'

class UsersController < ApplicationController
  def index
    response = client.users_list
    members = response["members"]
    names = members.map do |member|
      member["name"]
    end
  
    respond!(names)
  end
end