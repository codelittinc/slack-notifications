require 'mongo'
require 'singleton'

class Database
  include Singleton

  def client
    @client ||= client = Mongo::Client.new(ENV['DATABASE_URL'])
  end
end