-- depends on {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select date_day as period, ad_group_id, ad_group_name,
(case when sum(spend) is not null and sum(spend) != 0 then cast((sum(clicks)/sum(spend)) as float) else null end) as click_through_rate_by_ad_group
from {{ ref('google_ads_main') }}
group by date_day, ad_group_id, ad_group_name
