{{ config(materialized='view') }}

select * 
from {{ source('my_gcp_churn', 'Churn_Tabla') }}
limit 100
