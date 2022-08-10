-- depends of {{ ref('google_ads_main') }}

{{ config(materialized = 'table') }}

select *
from {{ metrics.metric(
  metric_name = 'google_ads__monthly_number_of_ad_groups_by_campaign',
  grain = 'month',
  dimensions = ['campaign_name'],
  secondary_calculations = []
) }}
