-- depends on {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select date_day as period, ad_group_id, ad_group_name,
(case when sum(spend) is not null and sum(spend) != 0 then cast((sum(conversions_value)/sum(spend)) as float) else null end) as roas_by_ad_group
from {{ ref('google_ads_main') }}
group by date_day, ad_group_id, ad_group_name
