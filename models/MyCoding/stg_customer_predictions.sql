{{ config(
    materialized='table'
) }}

with original_features as (
    select * from {{ source('my_ml_tables', 'ml_features_tb') }}
),

predicted_clusters as (
    select
        user_id,
        country,
        total_spend,
        -- ml.predict creates a column named 'CENTROID_ID' for KMeans
        centroid_id as predicted_cluster_id
    from ml.predict(
         model {{ source('my_ml_tables', 'ml_kmeans') }},
        (select * from original_features)
    )
)

select
    user_id,
    country,
    total_spend,
    predicted_cluster_id,
    case predicted_cluster_id
        when 1 then 'High Spend / High Recency (VIP)'
        when 2 then 'Low Spend / High Recency (Sleeper)'
        when 3 then 'New / Low Spend Active'
        when 4 then 'At Risk / Churning'
        else 'Unknown Cluster'
    end as customer_segment_name
from predicted_clusters