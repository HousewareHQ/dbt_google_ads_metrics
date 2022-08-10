-- depends on {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select date_day as period, account_id, account_name,
(case when sum(spend) is not null then cast((sum(conversion_value)/sum(spend)) as float) else null end) as roas_by_account
from {{ ref('google_ads_main') }}
group by date_day, account_id, account_name