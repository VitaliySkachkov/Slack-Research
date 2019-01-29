from slackeventsapi import SlackEventAdapter
from slackclient import SlackClient
import os
import time
import socket               # Import socket module
import json
import pprint
import urllib
import requests

# Our app's Slack Event Adapter for receiving actions via the Events API
slack_signing_secret = os.environ["SLACK_SIGNING_SECRET"]
slack_events_adapter = SlackEventAdapter(slack_signing_secret, "/slack/events")

# Create a SlackClient for your bot to use for Web API requests
slack_bot_token = os.environ["SLACK_BOT_TOKEN"]
slack_client = SlackClient(slack_bot_token)

# Example responder to greetings
@slack_events_adapter.on("message")
def handle_message(event_data):
    event_data_ = event_data
    message = event_data["event"]
    event_time = event_data["event_time"]

    # needed fields
    channel = message.get("channel")
    channel_type = message.get("channel_type")
    type = message.get("type")
    text = message.get("text")
    user = message.get("user")
    event_time_str = time.strftime("%d%m%Y %H:%M:%S", time.localtime(event_time))


    if(str(channel) == "None"):
        channel = ''
    if(str(channel_type) == "None"):
        channel_type = ''
    if(str(type) == "None"):
        type = ''
    if(str(user) == "None"):
        user = ''
    if(str(event_time_str) == "None"):
        event_time_str = ''
    if(str(text) == "None"):
        text = ''

    delimiter = "/f"
    out_msg = channel + delimiter + channel_type + delimiter + type + delimiter + user + delimiter + event_time_str + delimiter+ text
    # print(out_msg)

    # send json data
    def sendHTTP (event_data):

        gatewayHost = "http://127.0.0.1:6667"

        json_dump = json.dumps(event_data)
        json_data = json.loads(json_dump)
        t = str(int(time.time()))
        json_msg = [{
            "headers": {
                "timestamp": t,
                "host": "http://127.0.0.1:6667"
            },
            "body": json_dump
        }]

        pprint.pprint(json_msg)

        r = requests.post(gatewayHost, json=json_msg)
        print(r.status_code)


    # send to socket
    def sentNetCat (event_data):

        s = socket.socket()         # Create a socket object
        host = '127.0.0.1'
        port = 6666              # Reserve a port for your service.

        json_dump = json.dumps(event_data)
        s.connect((host, port))
        s.send(json_dump)

    # execute sending
    sendHTTP (event_data_)


    #  s.close
    #  print ( "event_time:" + event_time_str)
    #  print ( " - message:" + text)
    #  print (message)
    #  pprint.pprint(json_data)

    # If the incoming message contains "hi", then respond with a "Hello" message
    if message.get("subtype") is None and "hi" in message.get('text'):
        channel = message["channel"]
        message = "Hello <@%s>! :tada:" % message["user"]
        slack_client.api_call("chat.postMessage", channel=channel, text=message)


# Example reaction emoji echo
@slack_events_adapter.on("reaction_added")
def reaction_added(event_data):
    event = event_data["event"]
    emoji = event["reaction"]
    channel = event["item"]["channel"]
    text = ":%s:" % emoji
    slack_client.api_call("chat.postMessage", channel=channel, text=text)

# Error events
@slack_events_adapter.on("error")
def error_handler(err):
    print("ERROR: " + str(err))

# Once we have our event listeners configured, we can start the
# Flask server with the default `/events` endpoint on port 3000
slack_events_adapter.start(port=3000)



