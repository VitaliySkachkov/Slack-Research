
SELECT word
     --  , MessageMinute
       , MsgRate
       , event_time
       ,CASE WHEN MAX_MsgRate / MsgRate < 2 then '  !  ' else '' end as Comments
       FROM (
    SELECT word
         , MessageMinute
         , MsgRate
         , AVG(MsgRate) OVER (PARTITION by word) as AVG_MsgRate
         , MAX(MsgRate) OVER (PARTITION by word) as MAX_MsgRate
         , MAX(MsgRate) OVER (PARTITION by word)
           / AVG(MsgRate) OVER (PARTITION by word) as RateDiff
         , event_time
      FROM (
        SELECT word
         , MessageMinute
         , event_time
         , SUM(cnt) OVER (PARTITION by word ORDER by unix_time range between 60 preceding and current row ) as MsgRate
        FROM (
         SELECT word
              , unix_timestamp(event_time) as unix_time
              , event_time
              , SUBSTRING(event_time, 15, 2) as MessageMinute
              , 1 AS cnt
           FROM $viewName
           WHERE LENGTH(word) > 2
           and word = 'Jordan'
           )
    )
)
WHERE RateDiff > 2
ORDER BY word ASC, event_time ASC