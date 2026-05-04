# Adidas US Sales Analytics 

## 📌 Project Overview

This project simulates a real-world retail analytics engagement for Adidas US operations. The raw transactional sales data spanning January 2020 to December 2021 — covering 6 retail partners, 6 product lines, 3 sales channels, and all 5 US geographic regions — contained critical data integrity issues that made it unreliable for financial reporting or strategic planning.

A complete end-to-end ETL pipeline was designed and implemented using Python and MySQL, followed by a 3-page interactive Power BI Business Intelligence Dashboard that enables Adidas US sales leadership to make data-driven decisions on retailer strategy, product profitability, channel optimization, and regional investment planning.

## ❗ Problem Statement

Adidas US aggregates transaction-level sales data across 6 retail partners, through three sales channels (In-store, Outlet, Online). Analysis of the raw dataset revealed that 3,886 of 9,648 records (40.3%) had **total_sales** values exactly 10× higher than **price_per_unit × units_sold**, a wholesale pricing anomaly that inflated reported revenue by a factor of 10 for affected records. 

Additionally, 4 records had zero **units_sold**, making them invalid for any per-unit or revenue analysis. Without correcting these issues, any revenue aggregation, margin calculation or channel performance analysis would produce materially incorrect figures — leading to misguided budget allocation, inaccurate retailer performance rankings and flawed pricing strategy decisions.

## 🎯 Objective

To build a production-ready data analytics pipeline that:

- Extracts raw Adidas US sales data from an zip source (Kaggle)
- Detects, documents and corrects all data quality issues systematically
- Loads the validated, corrected dataset into MySQL for persistent storage
- Enables SQL-based business analysis across retailer, product, region, and channel dimensions
- Delivers an interactive 3-page Power BI dashboard for executive and operational reporting

## 🔄 Pipeline Architecture 

```text
Kaggle (Raw Excel)
        │
        ▼
Jupyter Notebook (Python + Pandas)
  ├── Data Extraction (header=4, usecols=B:N)
  ├── Exploratory Data Analysis
  ├── Schema Standardisation (snake_case rename)
  ├── Data Type Correction
  ├── Zero-unit row removal (4 rows)
  ├── 10x wholesale pricing anomaly detection & correction (3,886 rows)
  ├── Operating margin decimal → percentage conversion
  └── profit_per_unit feature engineering
        │
        ▼
MySQL Database (adidas_data → adidas table)
        │
        ▼
SQL Analysis (Adidas_Sales_Insights.sql)
  └── 7 business insight queries
        │
        ▼
Power BI Desktop
  └── Adidas US Sales Performance Dashboard — (2020–2021)
```

## 🛠 Tech Stack

- **Data Source:** Kaggle  
- **Development Environment:** Jupyter Notebook  
- **Data Processing:** Python, Pandas, NumPy, Excel  
- **Database & Connectivity:** MySQL, SQLAlchemy, PyMySQL
- **SQL Analysis:** MySQL Workbench
- **Visualization:** Microsoft Power BI

 ## 📂 Dataset Overview

**Source:** Kaggle — Adidas US Sales Datasets

**Raw dataset:** 9,648 rows × 13 columns | January 2020 — December 2021

| Column            | Description                              | Issues Found                                      |
|------------------|------------------------------------------|--------------------------------------------------|
| Retailer         | Retail partner name                      | None                                             |
| Retailer ID      | Retailer identifier                      | All records have same ID (1185732)               |
| Invoice Date     | Transaction date                         | None                                             |
| Region           | US geographic region                     | None                                             |
| State            | US state                                 | None                                             |
| City             | US city                                  | None                                             |
| Product          | Product name (gender + category)         | None                                             |
| Price per Unit   | Unit selling price                       | None                                             |
| Units Sold       | Quantity sold                            | 4 rows with value 0                              |
| Total Sales      | Recorded transaction revenue             | 3,886 rows inflated 10× (wholesale anomaly)      |
| Operating Profit | Profit per transaction                   | 3,886 rows affected by Total Sales error         |
| Operating Margin | Margin as decimal fraction               | All rows stored as 0.30 instead of 30.0          |
| Sales Method     | In-store / Outlet / Online               | None                                             |

## 🧹 Data Cleaning Summary

All transformations documented and executed in End-to-End_ETL_Pipeline_Python_&_MySQL.ipynb

| Issue                                                      | Rows Affected | Action Taken                                                                 |
|-----------------------------------------------------------|--------------|------------------------------------------------------------------------------|
| Column names with spaces and mixed case                   | All          | Renamed to snake_case using lambda rename                                   |
| Incorrect data types                                      | All          | retailer/retailer_id → string; categoricals → category; dates → datetime    |
| units_sold = 0                                            | 4            | Dropped — division-by-zero risk and invalid transactions                    |
| total_sales 10× higher than price_per_unit × units_sold   | 3,886        | Corrected using recalculated values                                         |
| operating_profit inconsistent with corrected sales        | 3,886        | Recalculated from corrected total_sales using margin                        |
| operating_margin stored as decimal (0.30)                 | All          | Converted to percentage (30.0) after all arithmetic                         |
| Float columns precision                                   | All          | Rounded to 2 decimal places                                                 |

**Final cleaned dataset:** cleaned_adidas_US_sales_dataset.xlsx with 9,644 rows × 14 columns

**Records dropped:** 4 rows (0.04% of total)

**New column added:** `profit_per_unit (operating_profit ÷ units_sold)`

## 🔍 Key Data Finding — Wholesale Pricing Anomaly

The most significant data integrity issue discovered during this project was a systematic 10× inflation in **total_sales** values affecting 3,886 records (40.3% of the dataset). These records were wholesale transactions where the invoiced total reflected bulk pricing at 10× the listed unit price, rather than **price_per_unit × units_sold**.

Without correcting this anomaly, total revenue aggregations would have been overstated by hundreds of millions of dollars, making retailer performance rankings and regional revenue comparisons completely unreliable. The correction process:

1. Computed recalculated_total_sales = price_per_unit × units_sold
2. Identified 3,886 mismatches between total_sales and recalculated_total_sales
3. Replaced total_sales with recalculated_total_sales for all affected rows
4. Recalculated operating_profit = total_sales × operating_margin using corrected values

## 🧪✅ Testing & QA Checks

The following data quality checks are performed within the notebook before the MySQL load:

- Zero units_sold check — confirmed 0 remaining after removal
- Revenue anomaly detection — 3,886 mismatches identified and corrected
- Operating margin conversion — confirmed all values converted from decimal to percentage
- Null check — confirmed 0 nulls across all columns in final dataset
- Final shape assertion — 9,644 rows × 14 columns confirmed before load
- MySQL row count verification — load confirmed by reading back row count post-insert


## 📊 SQL Business Insights

All 7 queries are available in Adidas_Sales_Insights.sql, each annotated with a business question and business use context.

**Query 1 - Retailer revenue performance**  
Identifies which retailer generates the highest total revenue, helping evaluate top-performing partners and guide strategic collaborations.

**Query 2 - Year-over-year revenue trend by region**  
Analyzes which regions are experiencing growth versus decline over time, supporting regional expansion and resource allocation decisions.

**Query 3 - Product profitability analysis**  
Determines which products deliver the highest operating margin, enabling focus on high-profit items and pricing optimization.

**Query 4 - Revenue split by sales method**  
Shows how revenue is distributed across In-store, Online, and Outlet channels, informing channel investment and operational priorities.

**Query 5 - Top 5 states by revenue**  
Highlights the highest revenue-generating states, useful for targeting key markets and planning regional strategies.

**Query 6 - Monthly revenue trend**  
Reveals seasonal patterns, peaks, and slow periods across 2020–2021, supporting forecasting, staffing, and inventory planning.

**Query 7 - Retailer × sales method cross-analysis**  
Examines which retailers perform best across different sales channels, helping optimize channel-specific partnerships and strategies.

## 📈 Power BI Dashboard

**Dashboard Title:** Adidas US Sales Performance Dashboard (2020–2021)

All dashboards are available in `Adidas US Sales Performance Dashboard.pbix`. The dashboard is structured across three analytical pages, each answering a distinct business question:

**Page 1 - Executive Summary**
High-level KPIs: Total Revenue, Total Operating Profit, Average Operating Margin %, Total Units Sold, and YoY Revenue Growth %. Monthly revenue trend with 2020 vs 2021 comparison, revenue split by sales method, and revenue by region.

**Page 2 - Product & Retailer Performance** 
Operating margin by product, revenue and profit by retailer side-by-side, retailer × sales method matrix heatmap, and product revenue tier treemap.

**Page 3 — Regional & Geographic Insights**
US state-level filled map coloured by revenue, regional revenue breakdown by retailer, MoM growth trend line, and bottom-performing markets table.

**Key Features:**
- Year, Region, Product, Sales Method slicers across all pages
- DAX measures for YoY growth, MoM growth, revenue share % and profit margin %
- Conditional formatting on margin columns
- Dynamic titles that update based on slicer selection
- Tooltips showing additional context on hover

## 🔑 Key Business Findings

Based on SQL analysis and Power BI dashboard results:

- **West Gear and Foot Locker** lead in total revenue, with West Gear commanding a notably higher operating margin — indicating it is the most profitable retail partnership for Adidas US.

- **Men's Street Footwear** generates the highest total revenue and operating profit across all product lines, making it the core revenue driver for the business.
Online is the fastest-growing sales channel by revenue share from 2020 to 2021, while In-store retains the highest average operating margin — a classic channel strategy tension for management.

- **The South and Southeast regions** show the highest revenue concentration, while the Midwest lags significantly — flagging an underperforming geographic market that warrants investigation.

- Revenue exhibits clear Q3 and Q4 seasonality, with consistent peaks in July - August and November - December across both years — directly actionable for inventory and campaign planning.

## 💡 Real-World Value

This project is directly relevant to any retail or sportswear business managing multi-channel sales across regional partners, because it answers the operational and strategic questions that leadership teams ask every quarter:

- Which retail partner deserves increased trade spend and co-marketing investment?
- Which product lines should be prioritised in seasonal inventory planning?
- Is the growth of online sales growing the overall market or cannibalising in-store?
- Which US regions are underperforming and need targeted sales force deployment?
- When should supply chain teams increase stock levels to meet seasonal demand peaks?

Beyond the business questions, this project also demonstrates a data governance capability that is directly applicable in a corporate analytics environment - identifying a systematic pricing anomaly affecting 40% of revenue records, documenting it with evidence, correcting it with a traceable recalculation, and flagging it as a finding rather than silently discarding the affected rows.

That is the difference between a data analyst who cleans data and one who audits it — and it is precisely the skill that separates candidates in interviews for mid-level analyst roles.

## 📂 Project Structure

```text
adidas-us-sales-analytics/
│
├── Adidas US Sales Datasets.xlsx                    # Raw source data from Kaggle
├── cleaned_adidas_US_sales_dataset.xlsx             # Cleaned output after ETL
├── End-to-End_ETL_Pipeline_Python_&_MySQL.ipynb     # Full ETL pipeline notebook
├── Adidas_Sales_Insights.sql                        # SQL business insight queries
├── Adidas US Sales Performance Dashboard.pbix       # Power BI dashboard file
└── README.md                                        # Project documentation
```

## 🧑‍💻 Skills Demonstrated

This project demonstrates the following skills directly relevant to a Data Analyst role:

- **Data wrangling** — Detecting and correcting systematic pricing anomalies, type casting, feature engineering.
- **ETL pipeline design** — End-to-end pipeline from raw Excel to structured MySQL database.
- **Database connectivity** — DataFrame → MySQL using SQLAlchemy and PyMySQL with environment variable security.
- **SQL analysis** — Writing business-context queries using `GROUP BY`, `HAVING`, `AGGREGATE FUNCTIONS`, and `ORDER BY`.
- **Business intelligence** — Building a multi-page Power BI dashboard with DAX measures, slicers.
- **Data storytelling** — Translating raw retail transactions into 5 specific actionable business findings.
- **Data governance** — Documenting all transformation decisions with business reasoning in notebook markdown


## 👤 Author

**Jeevan Abishek**  
Aspiring Data Analyst

<a href="https://www.linkedin.com/in/jeevan-abishek" target="_blank">LinkedIn Profile</a>

## 📜 License

This project is licensed under the MIT License. The dataset is sourced from Kaggle and used for educational and portfolio purposes only.
