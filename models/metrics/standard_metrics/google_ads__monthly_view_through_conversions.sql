-- depends of {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select *
from {{ metrics.metric(
  metric_name = 'google_ads__monthly_view_through_conversions',
  grain = 'month',
  dimensions = [],
  secondary_calculations = []
) }}
