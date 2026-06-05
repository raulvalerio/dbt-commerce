# Data Transformation & Machine Learning Pipeline with dbt & BigQuery

This repository showcases an end-to-end data engineering and data science pipeline. It leverages **dbt (Data Build Tool)** and **Google BigQuery** to ingest raw data, orchestrate enterprise-level transformations, and build advanced Machine Learning models directly inside the cloud data warehouse.

## 🚀 Project Overview

The objective of this project is to turn raw transactional data into actionable business intelligence and predictive insights through two core tracks:
1. **Customer Segmentation:** Grouping customers based on behavioral and financial attributes to optimize targeting.
2. **Order Prediction:** Forecasting future order volumes and revenue using both statistical and tree-based machine learning approaches.

---

## 🛠️ Tech Stack & Architecture

* **Data Warehouse:** Google BigQuery (Serverless, Highly Scalable Data Compute)
* **Data Transformation:** dbt Core (Lineage management, testing, and documentation)
* **Machine Learning:** BigQuery ML (BQML) & Python
* **Analytics Layer:** Prepped for Looker visualization

---

## 🤖 Machine Learning Models Implemented

### 1. Customer Segmentation (Unsupervised)
* **Algorithm:** K-Means Clustering (`kmeans`)
* **Objective:** Group profiles using metrics like total spend, purchase frequency, and recency.
* **Configuration:** Built natively using custom DDL statements and dbt configurations to define cluster criteria, Euclidean distance boundaries, and feature standardization.

### 2. Order Prediction (Supervised Regression)
To predict order counts and revenue, we compare and evaluate multiple regression methodologies:
* **Linear Regression:** Establishing baseline statistical relationships.
* **Tree-Based Models:** Deploying Boosted Trees (XGBoost/Random Forest frameworks) within BigQuery and Python to capture non-linear interactions and complex customer behavioral patterns.

---

## 📁 Repository Structure

The project is structured to maintain a clean separation between data transformations, configurations, and data science assets:

```text
├── models/
│   ├── staging/                 # Raw source data cleanup and type casting
│   ├── marts/                   # Business logic and reporting layers
│   └── MyCoding/                # Core ML model definitions and logic
│       ├── mdl_customer_segment.sql      # K-Means model orchestration
│       ├── stg_customer_predictions.sql  # K-Means model predictions
│       ├── ml_features_tb.sql   # Data transformation to create finances attributes before kmeans 
│       └── sources.yml          # Documentation and test assertions for models
│       └── ecomm.yml            # Documentation and test for ecommerce data from big query
├── python/                      # Python scripts for deep analysis and modeling
├── dbt_project.yml              # Global dbt configuration & variable scopes
├── profiles.yml                 # Connection routing to the BigQuery target schema
└── README.md                    # Project documentation
```

---

## ⚙️ How It Works & Deployment

### 1. Prerequisites
Ensure you have access to Google Cloud Platform (GCP) and your dbt profile is linked to your project schema (e.g., `looker-portfolio`).

### 2. Run Data Transformations
To compile the lineage and materialize the staging and analytics tables:
```bash
dbt run
```

### 3. Testing the Models
To run data quality assertions and schema tests:
```bash
dbt test
```

---

## 📈 Key Deliverables Shared
* **dbt Data Models:** Clean, modular SQL statements defining the analytical tables and machine learning feature stores.
* **BigQuery ML Configs:** Optimized configuration bindings (`model_options`) and raw DDL configurations used to spin up models directly via SQL compute.
* **YAML Definitions:** Configuration and schema documentation mapping data types, custom meta tags, and project paths.
* **Python Integrations:** Accompanying scripts demonstrating external analytical evaluations and modeling comparisons.
