-- 1
select * from slack_messages limit 10;

-- 2
SELECT slack_user, event_date, Count(*) as Message_Cnt FROM Slack_Messages GROUP BY slack_user, event_date;

-- 3
CREATE TABLE Messages_Stat ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' AS SELECT slack_user, event_date, Count(*) as Message_Cnt FROM Slack_Messages GROUP BY slack_user, event_date;

-- 4
 select avg(length(text)) from slack_messages where event_date = '2019-01-15';
 select max(length(text)) from slack_messages where event_date = '2019-01-15'

-- 5
 SELECT ChannelName
      , event_date
      , Count(*) as message_cnt
   FROM Slack_Messages s
   INNER JOIN Channels ch on s.channel = ch.channelID
   GROUP BY ChannelName, event_date;
