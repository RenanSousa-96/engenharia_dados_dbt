SELECT action_day
FROM {{ ref('d_time') }}
WHERE action_day < 1
   or action_day > 31 
