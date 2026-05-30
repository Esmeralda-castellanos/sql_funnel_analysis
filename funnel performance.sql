-- Step 0: preview raw events
SELECT *
FROM `project-0e230ae7-fb71-4b05-bba.user_events.channel_funnel_performance`
LIMIT 1000;

-- Step 1: funnel stages (counts per stage)
WITH funnel_stages AS (
  SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view'      THEN user_id END) AS stage_1_view,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart'    THEN user_id END) AS stage_2_cart,
    COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
    COUNT(DISTINCT CASE WHEN event_type = 'payment_info'   THEN user_id END) AS stage_4_payment,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase'       THEN user_id END) AS stage_5_purchase
  FROM `project-0e230ae7-fb71-4b05-bba.user_events.user_events_date`
  WHERE event_date BETWEEN DATE '2026-01-11' AND DATE '2026-02-10'
)
SELECT *
FROM funnel_stages;

-- Step 2: conversion rates through the funnel
WITH funnel_stages AS (
  SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view'      THEN user_id END) AS stage_1_view,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart'    THEN user_id END) AS stage_2_cart,
    COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
    COUNT(DISTINCT CASE WHEN event_type = 'payment_info'   THEN user_id END) AS stage_4_payment,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase'       THEN user_id END) AS stage_5_purchase
  FROM `project-0e230ae7-fb71-4b05-bba.user_events.user_events_date`
  WHERE event_date BETWEEN DATE '2026-01-11' AND DATE '2026-02-10'
)
SELECT
  stage_1_view,
  stage_2_cart,
  ROUND(SAFE_DIVIDE(stage_2_cart * 100.0, stage_1_view), 2) AS view_to_cart_rate,
  stage_3_checkout,
  ROUND(SAFE_DIVIDE(stage_3_checkout * 100.0, stage_2_cart), 2) AS cart_to_checkout_rate,
  stage_4_payment,
  ROUND(SAFE_DIVIDE(stage_4_payment * 100.0, stage_3_checkout), 2) AS checkout_to_payment_rate,
  stage_5_purchase,
  ROUND(SAFE_DIVIDE(stage_5_purchase * 100.0, stage_4_payment), 2) AS payment_to_purchase_rate,
  ROUND(SAFE_DIVIDE(stage_5_purchase * 100.0, stage_1_view), 2)     AS overall_conversion_rate
FROM funnel_stages;

-- Step 3: funnel by source; comparing marketing channels performance
WITH source_funnel AS (
  SELECT
    traffic_source,
    COUNT(DISTINCT CASE WHEN event_type = 'page_view'  THEN user_id END) AS views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS carts,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
  FROM `project-0e230ae7-fb71-4b05-bba.user_events.channel_funnel_performance`
  WHERE DATE(event_date) BETWEEN DATE '2026-01-11' AND DATE '2026-02-10'
  GROUP BY traffic_source
)
SELECT
  traffic_source,
  views,
  carts,
  purchases,
  ROUND(SAFE_DIVIDE(carts * 100.0, views), 2)      AS cart_conversion_rate,
  ROUND(SAFE_DIVIDE(purchases * 100.0, views), 2)  AS purchase_conversion_rate,
  ROUND(SAFE_DIVIDE(purchases * 100.0, carts), 2)  AS cart_to_purchase_rate
FROM source_funnel
ORDER BY purchases DESC;

-- Step 4: time to conversion analysis
WITH user_journey AS (
  SELECT
    user_id,
    MIN(CASE WHEN event_type = 'page_view'   THEN event_date END) AS view_time,
    MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
    MIN(CASE WHEN event_type = 'purchase'    THEN event_date END) AS purchase_time
  FROM `project-0e230ae7-fb71-4b05-bba.user_events.channel_funnel_performance`
  WHERE DATE(event_date) BETWEEN DATE '2026-01-11' AND DATE '2026-02-10'
  GROUP BY user_id
  HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL
)
SELECT 
  COUNT(*) AS converted_users,
  ROUND(AVG(TIMESTAMP_DIFF(cart_time,     view_time,     MINUTE))) AS avg_view_to_cart_minutes,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, cart_time,     MINUTE))) AS avg_cart_to_purchase_minutes,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, view_time,     MINUTE))) AS avg_total_journey_minutes
FROM user_journey;

-- Step 5: revenue funnel analysis
WITH funnel_revenue AS (
  SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase'  THEN user_id END) AS total_buyers,
    SUM(CASE WHEN event_type = 'purchase' THEN amount END)            AS total_revenue,
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 END)               AS total_orders
  FROM `project-0e230ae7-fb71-4b05-bba.user_events.channel_funnel_performance`
  WHERE DATE(event_date) BETWEEN DATE '2026-01-11' AND DATE '2026-02-10'
)
SELECT 
  total_visitors,
  total_buyers,
  total_orders,
  total_revenue,
  SAFE_DIVIDE(total_revenue, total_orders)   AS avg_order_value,
  SAFE_DIVIDE(total_revenue, total_buyers)   AS revenue_per_buyer,
  SAFE_DIVIDE(total_revenue, total_visitors) AS revenue_per_visitor
FROM funnel_revenue;