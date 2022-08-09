-- depends on {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select date_day as period, account_id, account_name,
(case when sum(conversions) is not null then cast((sum(spend)/sum(conversions)) as float) else null end) as cost_per_conversion_by_account
from {{ ref('google_ads_main') }}
group by date_day, account_id, account_name
