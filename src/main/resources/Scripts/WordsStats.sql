SELECT MessageMinute as MessageHour
     , word
     , MessageCount
  FROM (
    SELECT  MessageMinute, word, MessageCount, MAX(MsgRate) OVER (PARTITION BY word) as MaxRate
      FROM (
          SELECT MessageMinute, word, MessageCount, MessageCount/ AVG(MessageCount) OVER (PARTITION BY word) as MsgRate
            FROM (
                SELECT SUBSTRING(event_time, 10, 2) as MessageMinute, word as word, count(1) as MessageCount
                  FROM $viewName
                  WHERE LENGTH(word) > 2
                  GROUP BY SUBSTRING(event_time, 10, 2), word
                )
      )
    )
    WHERE MaxRate >= 2