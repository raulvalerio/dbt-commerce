{{ config(
    materialized='table',
    labels={'domain': 'ml_feature_store'}
) }}

with raw_users as (
    select 
        id as user_id,
        created_at as signup_timestamp,
        country
    from {{ source('thelook_raw', 'users') }}
),

raw_orders as (
    select 
        user_id,
        order_id,
        created_at as order_timestamp
    from {{ source('thelook_raw', 'orders') }}
),

raw_items as (
    select 
        order_id,
        sale_price
    from {{ source('thelook_raw', 'order_items') }}
),

-- 1. Base Aggregations: Flatten items into order values, then aggregate per customer
customer_metrics as (
    select
        u.user_id,
        u.country,
        timestamp_diff(max(o.order_timestamp), u.signup_timestamp, day) as lifetime_days,
        count(distinct o.order_id) as total_orders,
        sum(i.sale_price) as total_spend,
        safe_divide(sum(i.sale_price), count(distinct o.order_id)) as avg_order_value,
        -- Days since their last transaction
        date_diff(current_date(), date(max(o.order_timestamp)), day) as recency_days
    from raw_users u
    left join raw_orders o on u.user_id = o.user_id
    left join raw_items i on o.order_id = i.order_id
    group by 1, 2, u.signup_timestamp
),

-- 2. Statistical Aggregations: Compute Global Mean and Deviation for Feature Scaling
global_stats as (
    select
        avg(total_spend) as mean_spend,
        stddev(total_spend) as stddev_spend,
        min(recency_days) as min_recency,
        max(recency_days) as max_recency
    from customer_metrics
),

-- 3. Advanced Transformation: Applying ML scaling rules natively in SQL
ml_features as (
    select
        c.user_id,
        c.country,
        c.lifetime_days,
        c.total_orders,
        c.total_spend,
        c.recency_days,
        
        -- ML Transformation A: Z-Score Standardization (Brings Mean to 0, StdDev to 1)
        safe_divide((c.total_spend - g.mean_spend), g.stddev_spend) as total_spend_z_score,
        
        -- ML Transformation B: Min-Max Scaling (Compresses value cleanly between 0.0 and 1.0)
        safe_divide((c.recency_days - g.min_recency), (g.max_recency - g.min_recency)) as recency_min_max_scaled,
        
        -- ML Transformation C: Log Transformation (Handles heavily right-skewed data like revenue)
        ln(c.total_spend + 1) as log_total_spend

    from customer_metrics c
    cross join global_stats g
)

select * from ml_features
