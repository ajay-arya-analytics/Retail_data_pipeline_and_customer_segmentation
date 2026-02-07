# 📊 Retail_data_pipeline_and_customer_segmentation (Brazilian-E-Commerce Dataset)

## 📌 Project Overview
This project focuses on building a robust data pipeline to analyze **100,000+ Brazilian e-commerce transactions**. By integrating **Python** for ETL (Extract, Transform, Load) and **MySQL** for relational modeling, I transformed raw, fragmented CSV files into a structured database ready for business intelligence.

## 🛠️ Tech Stack
- **Language:** Python 3.13
- **Libraries:** Pandas, NumPy, SQLAlchemy, MySQL-Connector
- **Database:** MySQL (Relational Modeling & CTEs)
- **Dataset:** [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## ⚙️ Data Engineering Pipeline (Python)
Raw data from Olist is highly relational (9 separate files). My Python pipeline performed the following:
- **Relational Merging:** Joined `orders`, `payments`, `items`, and `products` using complex left joins to preserve transaction history.
- **Date Normalization:** Handled inconsistent timestamps by normalizing `order_purchase_timestamp` to a standard Date format, resolving cardinality issues.
- **Missing Value Imputation:** Applied category-specific median imputation for missing ratings and "Unknown" labeling for untranslated product categories.
- **Automated Loading:** Built a `SQLAlchemy` engine to automatically push the cleaned 100k+ rows into a local MySQL instance.

## 🗄️ Business Logic & SQL Analysis
I developed a suite of SQL queries and views to answer critical business questions:
1. **RFM Segmentation:** Classified customers into 'VIP', 'Regular', and 'Churn Risk' based on spending and frequency.
2. **Logistics Bottlenecks:** Identified product categories with average delivery delays exceeding 15 days using `DATEDIFF`.
3. **MoM Revenue Growth:** Implemented Window Functions (`LAG`) and CTEs to calculate Month-over-Month revenue trends, identifying a 2017 Black Friday peak.
4. **Pareto Analysis:** Calculated that the top 20% of product categories generate ~80% of total revenue.

## 📈 Key Insights
- **Shipping Impact:** Delivery delays in Northern regions correlate with a 22% drop in review scores.
- **Customer Loyalty:** VIP customers (spend > $500) contribute to 15% of revenue but make up only 3% of the customer base.
