require 'uri'
require 'net/http'

class SlackOauth
  SLACK_AUTHENTICATE_URL = 'https://slack.com/api/oauth.v2.access'

  def initialize(code)
    @code = code
  end

  def authenticate!
    data =  {
      :code => @code,
      :client_id   => ENV['SLACK_CLIENT_ID'],
      :client_secret => ENV['SLACK_CLIENT_SECRET'],
    }

    encoded_data = URI.encode_www_form(data)

    url = URI.parse("#{SLACK_AUTHENTICATE_URL}?#{encoded_data}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(url.request_uri)
    JSON.parse(http.request(req).body)
  end
end