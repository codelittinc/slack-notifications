require './services/database'

class BaseModel
  def initialize
    @client = Database.instance.client
  end
end