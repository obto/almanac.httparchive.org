#standardSQL
# 08_06: Most common lengths of alt text (-1 for none. 2000+ grouped together)
SELECT
  client,
  alt_length_clipped AS alt_length,
  COUNT(0) AS occurances
FROM (
  SELECT
    client,
    IF(alt_length >= 2000, 2000, alt_length) AS alt_length_clipped
  FROM (
    SELECT
      "desktop" AS client,
      CAST(alt_length_string as INT64) AS alt_length
    FROM
      `httparchive.almanac.pages_desktop_1k`,
      UNNEST(
        JSON_EXTRACT_ARRAY(JSON_EXTRACT_SCALAR(payload, '$._almanac'), "$.images.alt_lengths")
      ) AS alt_length_string
  )
)
GROUP BY
  client,
  alt_length
ORDER BY
  alt_length ASC
