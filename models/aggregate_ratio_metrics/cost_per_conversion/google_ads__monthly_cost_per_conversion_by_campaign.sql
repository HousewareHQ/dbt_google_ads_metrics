-- depends on {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select date_day as period, campaign_id, campaign_name,
(case when sum(conversions) is not null and sum(conversions) != 0 then cast((sum(spend)/sum(conversions)) as float) else null end) as cost_per_conversion_by_campaign
from {{ ref('google_ads_main') }}
group by date_day, campaign_id, campaign_name
