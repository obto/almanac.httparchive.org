#standardSQL
# 08_08: How often the title attribute is used with an alt attribute, and how often they are the same values
SELECT
  client,
  SUM(total_alt) AS total_alts,
  SUM(total_title) AS total_titles,
  SUM(total_both) AS total_both,
  SUM(total_alt_same_as_title) AS total_alt_same_as_title,
  ROUND((SUM(total_both) / SUM(total_alt)) * 100, 2) AS pct_title_used_with_alt,
  ROUND((SUM(total_alt_same_as_title) / SUM(total_both) * 100), 2) AS pct_same_when_both_used,
  ROUND((SUM(total_alt_same_as_title) / SUM(total_alt)) * 100, 2) AS pct_same_of_all_alts
FROM (
  SELECT
    "desktop" AS client,
    CAST(JSON_EXTRACT_SCALAR(JSON_EXTRACT_SCALAR(payload, "$._a11y"), "$.title_and_alt.total_alt") AS INT64) AS total_alt,
    CAST(JSON_EXTRACT_SCALAR(JSON_EXTRACT_SCALAR(payload, "$._a11y"), "$.title_and_alt.total_title") AS INT64) AS total_title,
    CAST(JSON_EXTRACT_SCALAR(JSON_EXTRACT_SCALAR(payload, "$._a11y"), "$.title_and_alt.total_both") AS INT64) AS total_both,
    CAST(JSON_EXTRACT_SCALAR(JSON_EXTRACT_SCALAR(payload, "$._a11y"), "$.title_and_alt.total_alt_same_as_title") AS INT64) AS total_alt_same_as_title
  FROM
    `httparchive.almanac.pages_desktop_1k`
)
GROUP BY
  client
