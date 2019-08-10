#standardSQL
# 07_12: Percentiles of largest image
SELECT
  client,
  ROUND(APPROX_QUANTILES(largestImage, 1000)[OFFSET(100)] / 1000, 2) AS p10,
  ROUND(APPROX_QUANTILES(largestImage, 1000)[OFFSET(250)] / 1000, 2) AS p25,
  ROUND(APPROX_QUANTILES(largestImage, 1000)[OFFSET(500)] / 1000, 2) AS p50,
  ROUND(APPROX_QUANTILES(largestImage, 1000)[OFFSET(750)] / 1000, 2) AS p75,
  ROUND(APPROX_QUANTILES(largestImage, 1000)[OFFSET(900)] / 1000, 2) AS p90
FROM 
( 
  SELECT
  _TABLE_SUFFIX AS client,
   CAST(JSON_EXTRACT(payload, "$['_heroElementTimes.Image']") AS INT64) AS largestImage
  FROM
  `httparchive.pages.2019_07_01_*`
)
GROUP BY
  client



  





  
