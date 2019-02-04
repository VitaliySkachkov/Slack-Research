
SELECT word
       , event_time
       , MsgRate
       FROM (
    SELECT word
         , event_time
         , MsgRate
         , MAX(MsgRate) OVER (partition by word) as Max_MsgRate
      FROM (
        SELECT word
         , event_time
         , SUM(cnt) over (partition by word order by unix_time range between 60 preceding and current row ) /
            SUM(cnt) over (partition by word order by unix_time range between 120 preceding and 61 preceding ) as MsgRate
        FROM (
         SELECT word
              , unix_timestamp(event_time) as unix_time
              , event_time
              , SUBSTRING(event_time, 10, 2) as MessageMinute
              , 1 AS cnt
           FROM $viewName
           WHERE LENGTH(word) > 2
           )
           order by word ASC
         , event_time ASC
    )
)
WHERE nvl(Max_MsgRate, 0) > 2