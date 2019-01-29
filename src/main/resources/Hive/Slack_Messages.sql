
CREATE EXTERNAL TABLE Slack_Messages(channel STRING
    , channel_type STRING
    , type STRING
    , slack_user STRING
    , event_time STRING
    , text STRING) partitioned by (event_date string)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '/f'
    STORED AS TEXTFILE LOCATION '/user/vskachkov/events/';

    alter table Slack_Messages add partition (event_date = '2019-01-16’) location '/user/vskachkov/events/2019/01/16’;
    alter table Slack_Messages add partition (event_date = '2019-01-18’) location '/user/vskachkov/events/2019/01/18’;