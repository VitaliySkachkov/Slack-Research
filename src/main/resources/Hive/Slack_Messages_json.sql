
CREATE EXTERNAL TABLE Slack_Messages_JSON (token STRING
                    , api_app_id STRING
                    , event struct<type:string
                                 , subtype:string
                                 , text:string
                                 , ts:string
                                 , username:string
                                 , bot_id:string
                                 , channel:string
                                 , event_ts:string
                                 , channel_type:string>
                    , type STRING
                    , event_id STRING
                    , event_time STRING
                    , authed_users STRING)
                   COMMENT 'Slack_Messages Table by Vitaliy Skachkov into JSON format'
                   ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
                   LOCATION '/events_json';
