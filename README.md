![Deploy to Heroku](https://github.com/codelittinc/slack-notifications/workflows/Deploy%20to%20Heroku/badge.svg)

Slack Notifications API
=================

![](slack.png)

The goal of this applications is to make create a simple interface to connect your applications with Slack without having to go through all the Slack integration API.

## How to run the application

1. git clone https://github.com/codelittinc/slack-notifications
2. bundle install
4. cp .env.example .env
3. set your `SLACK_API_KEY` on .env with your Slack app authorizarion key on
4. set your `AUTHENTICATION_KEY` on .env with any value you would like to receive in the `Authorization` header
5. bundle exec rerun "ruby app.rb -p 4000"

Note: the `rerun` will start an auto reload, meaning that every time you change a line of code it will automatically restart the server

### Trying it out:

**Listing the Slack users:**

curl --location --request GET 'http://localhost:4000/users' --header 'Authorization: <AUTHENTICATION_KEY>'

**Sending messages:**

curl --location --request POST 'http://localhost:4000/channel-messages' \
--header 'Content-Type: application/json' \
--header 'Authorization: <AUTHENTICATION_KEY>' \
--data-raw '{
	"channel": "feed-test-automations",
	"message": ":roadrunner: I'\''m working!"
}'
