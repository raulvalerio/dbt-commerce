## not possible to run in dbt due to compute_region issues thus model created in big query instead
## check file txt about it: kmeansinbigquery.txt

import pandas as pd
from sklearn.cluster import KMeans

def model(dbt, session):
    # 1. dbt automatically fetches the table we built in the previous step
    dbt.config(
        materialized="table",
        packages=["scikit-learn", "mlflow"] # Must be a structured array
    )
    
    df = dbt.source("my_ml_tables", "ml_features_tb").to_dataframe().to_pandas()
    #df= dbt.ref("ml_features_tb").to_pandas()
    
    # 2. Run standard Python machine learning code
    features = df[['total_spend_z_score', 'recency_min_max_scaled']]
    kmeans = KMeans(n_clusters=3, random_state=42).fit(features)
    
    # 3. Append the predictions back to the dataset
    df['customer_segment_cluster'] = kmeans.labels_
    
    # dbt writes this dataframe back out as a physical BigQuery table
    return df
