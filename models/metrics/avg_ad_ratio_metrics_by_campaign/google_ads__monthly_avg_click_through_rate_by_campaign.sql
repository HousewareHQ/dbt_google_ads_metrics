-- depends of {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select *
from {{ metrics.calculate(
  metric('google_ads__monthly_avg_click_through_rate_by_campaign'),
  grain = 'month',
  dimensions = ['campaign_name'],
  secondary_calculations = []
) }}
