#standardSQL
# 08_29: Groupings of "x-content-type-options" parsed values by percentage
#    
#   `httparchive.almanac.summary_response_bodies` archive = 71.5GB 
#   `httparchive.summary_requests.2019_07_01_*` = 118.3 GB

SELECT
  client,
  SUM(COUNT(0)) OVER (PARTITION BY client) AS client_tot,
  policy,
  count(0) as policy_freq,
  ROUND(COUNT(0)*100/SUM(COUNT(0)) OVER (PARTITION BY client),2) as policy_pct
FROM
  `httparchive.almanac.summary_response_bodies`,
  UNNEST(REGEXP_EXTRACT_ALL(LOWER(respOtherHeaders),r'x-content-type-options = ([^,\r\n]+)')) AS value,
  UNNEST(SPLIT(value, ';')) AS policy
WHERE
  firstHtml
GROUP BY
  client, policy
ORDER BY
  client, policy_freq DESC