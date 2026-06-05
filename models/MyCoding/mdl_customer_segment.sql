/*not working in dbt thus creating the model in bigquery instead
## check file txt about it: kmeansinbigquery.txt
*/

{{ config(
    materialized='model',
    meta={
        'model_type': 'kmeans',
        'num_clusters': 4,
        'init_method': 'KMEANS++',
        'distance_type': 'EUCLIDEAN',
        'standardize_features': false
    }
) }}

SELECT 
    total_spend_z_score,
    recency_min_max_scaled,
    log_total_spend
FROM {{ source('my_ml_tables', 'ml_features_tb') }}
