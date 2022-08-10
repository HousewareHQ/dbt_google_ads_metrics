-- depends of {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select *
from {{ metrics.metric(
  metric_name = 'google_ads__monthly_click_through_rate_by_ad',
  grain = 'month',
  dimensions = ['ad_name'],
  secondary_calculations = []
) }}
