-- depends on {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select date_day as period, campaign_id, campaign_name,
(case when sum(impressions) is not null then cast((sum(spend)/sum(impressions)) as float) else null end) as cost_per_impression_by_account
from {{ ref('google_ads_main') }}
group by date_day, campaign_id, campaign_name
