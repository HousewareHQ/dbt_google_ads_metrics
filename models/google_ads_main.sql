-- Depends on source tables from Fivetran's dbt package and the AD_STATS table from Fivetran raw data
--
 {{ config(materialized='table') }}

 WITH account_history AS
  (SELECT *
   FROM {{ var('account_history') }}
   WHERE is_most_recent_record = '{{ var("filter_latest_records", "TRUE") }}'

  ), campaign_history AS
  (SELECT *
   FROM {{ var('campaign_history') }}
   WHERE is_most_recent_record = '{{ var("filter_latest_records", "TRUE") }}'

  ), ad_group_history AS
  (SELECT *
   FROM {{ var('ad_group_history') }}
   WHERE is_most_recent_record = '{{ var("filter_latest_records", "TRUE") }}'

  ), ad_history AS
  (SELECT *
   FROM {{ var('ad_history') }}
   WHERE is_most_recent_record = '{{ var("filter_latest_records", "TRUE") }}'

  ), ad_stats AS
  (SELECT *
   FROM {{ var('ad_stats') }}

  ), base_ad_stats AS
  (SELECT *
   FROM {{ source('google_ads', 'AD_STATS') }}

  ), base_ad_history AS
  (SELECT *,
          row_number() OVER (PARTITION BY id
                             ORDER BY updated_at DESC) = 1 AS is_most_recent_record
   FROM {{ source('google_ads', 'AD_HISTORY') }}

  ), recent_ad_history AS
  (SELECT *
   FROM base_ad_history
   WHERE is_most_recent_record = '{{ var("filter_latest_records", "TRUE") }}'

  ), SOURCE AS
  (SELECT ad_stats.*,
          account_history.account_name,
          campaign_history.campaign_name,
          ad_group_history.ad_group_name,
          ad_history.ad_type,
          ad_history.ad_status,
          ad_history.source_final_urls,
          ad_history.final_url,
          ad_history.base_url,
          ad_history.url_host,
          ad_history.url_path,
          ad_history.utm_source,
          ad_history.utm_medium,
          ad_history.utm_campaign,
          ad_history.utm_content,
          ad_history.utm_term,
          recent_ad_history.name AS ad_name,

     (SELECT sum(conversions)
      FROM base_ad_stats
      WHERE base_ad_stats.ad_id = ad_stats.ad_id ) AS conversions,

     (SELECT sum(conversions_value)
      FROM base_ad_stats
      WHERE base_ad_stats.ad_id = ad_stats.ad_id ) AS conversions_value,

     (SELECT sum(view_through_conversions)
      FROM base_ad_stats
      WHERE base_ad_stats.ad_id = ad_stats.ad_id ) AS view_through_conversions
   FROM ad_stats
   LEFT JOIN account_history ON ad_stats.account_id = account_history.account_id
   LEFT JOIN campaign_history ON ad_stats.campaign_id = campaign_history.campaign_id
   LEFT JOIN ad_group_history ON ad_stats.ad_group_id = ad_group_history.ad_group_id
   LEFT JOIN ad_history ON ad_stats.ad_id = ad_history.ad_id
   LEFT JOIN recent_ad_history ON ad_stats.ad_id = recent_ad_history.id)

SELECT *,
       (CASE
            WHEN impressions IS NOT NULL THEN cast((spend/impressions) AS float)
            ELSE NULL
        END) AS cost_per_impression_per_ad,
       (CASE
            WHEN impressions IS NOT NULL THEN CAST ((clicks/impressions) AS float)
            ELSE NULL
        END) AS click_through_rate_per_ad,
       (CASE
            WHEN clicks IS NOT NULL THEN CAST ((spend/clicks) AS float)
            ELSE NULL
        END) AS cost_per_click_per_ad,
       (CASE
            WHEN spend IS NOT NULL THEN cast((conversions/spend) AS float)
            ELSE NULL
        END) AS cost_per_conversion_per_ad,
       (CASE
            WHEN spend IS NOT NULL THEN cast((conversions_value/spend) AS float)
            ELSE NULL
        END) AS roas_per_ad
FROM SOURCE
