-- depends on {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select date_day as period, campaign_id, campaign_name,
(case when sum(spend) is not null then cast((sum(conversions_value)/sum(spend)) as float) else null end) as roas_by_campaign
from {{ ref('google_ads_main') }}
group by date_day, campaign_id, campaign_name
