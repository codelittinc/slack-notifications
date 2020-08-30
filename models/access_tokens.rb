require './models/base_model'

class AccessTokens < BaseModel
  # @TODO: do not create a new one if there is a team id in the database already
  def create!(access_token, team_id)
    collection = @client[:access_tokens]
    doc = {
      value: access_token,
      team_id: team_id
    }
    collection.insert_one(doc)
  end

  def by_team_id(team_id)
    collection = @client[:access_tokens]
    collection.find("team_id": team_id ).first
  end
end