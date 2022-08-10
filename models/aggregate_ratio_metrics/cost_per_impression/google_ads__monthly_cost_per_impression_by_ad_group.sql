-- depends on {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select date_day as period, ad_group_id, ad_group_name,
(case when sum(impressions) is not null then cast((sum(spend)/sum(impressions)) as float) else null end) as cost_per_impressions_by_ad_group
from {{ ref('google_ads_main') }}
group by date_day, ad_group_id, ad_group_name
