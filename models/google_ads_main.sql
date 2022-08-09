-- Depends on source tables from Fivetran's dbt package and the AD_STATS table from Fivetran raw data
--

{{ config(materialized='table') }}

with account_history as (
  -- it should be configurable to have the most recent record or not
  select * from {{ var('account_history') }} where is_most_recent_record = '{{ var("see_most_recent_record", "TRUE") }}'
), campaign_history as (
  select * from {{ var('campaign_history') }} where is_most_recent_record = '{{ var("see_most_recent_record", "TRUE") }}'
), ad_group_history as (
  select * from {{ var('ad_group_history') }} where is_most_recent_record = '{{ var("see_most_recent_record", "TRUE") }}'
), ad_history as (
  select * from {{ var('ad_history') }} where is_most_recent_record = '{{ var("see_most_recent_record", "TRUE") }}'
), ad_stats as (
  select * from {{ var('ad_stats') }}
), base_ad_stats as (
  select * from {{ source('google_ads', 'AD_STATS') }}
), base_ad_history as (
  select *,
  row_number() over (partition by id order by updated_at desc) = 1 as is_most_recent_record
  from {{ source('google_ads', 'AD_HISTORY') }}
), recent_ad_history as (
  select * from base_ad_history where is_most_recent_record = '{{ var("see_most_recent_record", "TRUE") }}'
), source as (
  select ad_stats.*, account_history.account_name, campaign_history.campaign_name, ad_group_history.ad_group_name,
  ad_history.ad_type, ad_history.ad_status, ad_history.source_final_urls, ad_history.final_url, ad_history.base_url, ad_history.url_host, ad_history.url_path, ad_history.utm_source, ad_history.utm_medium, ad_history.utm_campaign, ad_history.utm_content, ad_history.utm_term,
  recent_ad_history.name as ad_name,

  ( select sum(conversions) from base_ad_stats where base_ad_stats.ad_id = ad_stats.ad_id ) as conversions,
  ( select sum(conversion_value) from base_ad_stats where base_ad_stats.ad_id = ad_stats.ad_id ) as conversion_value,
  ( select sum(view_through_conversions) from base_ad_stats where base_ad_stats.ad_id = ad_stats.ad_id ) as view_through_conversions

  from ad_stats

  left join account_history
  on ad_stats.account_id = account_history.account_id
  left join campaign_history
  on ad_stats.campaign_id = campaign_history.campaign_id
  left join ad_group_history
  on ad_stats.ad_group_id = ad_group_history.ad_group_id
  left join ad_history
  on ad_stats.ad_id = ad_history.ad_id
  left join recent_ad_history
  on ad_stats.ad_id = recent_ad_history.id
)

select *,
(case when impressions is not null then cast((spend/impressions) as float) else null end) as cost_per_impression_per_ad,
(case when impressions is not null then cast ((clicks/impressions) as float) else null end) as click_through_rate_per_ad,
(case when clicks is not null then cast ((spend/clicks) as float) else null end) as cost_per_click_per_ad,
(case when spend is not null then cast((conversions/spend) as float) else null end) as cost_per_conversion_per_ad,
(case when spend is not null then cast((conversion_value/spend) as float) else null end) as roas_per_ad

from source
