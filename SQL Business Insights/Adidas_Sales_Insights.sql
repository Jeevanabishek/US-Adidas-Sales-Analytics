-- ADIDAS US SALES INSIGHTS — SQL ANALYSIS
-- Database: adidas_data  |  Table : adidas  |  Records : 9,648
-- Period: January 2020 — December 2021
-- Purpose: Extract business insights to support retailer strategy, product profitability, channel optimization, and regional sales planning for Adidas US leadership.

use adidas_data

-- Q1 — Retailer revenue performance
-- Business question: Which retailer generates the highest total revenue?
-- Business use: Identifies the most valuable retail partner for prioritising account management and trade spend allocation

SELECT
    retailer,
    ROUND(SUM(total_sales), 2) AS total_revenue,
    SUM(units_sold) AS total_units,
    ROUND(AVG(operating_margin), 2) AS avg_margin
FROM adidas
GROUP BY retailer
ORDER BY total_revenue DESC;

-- Q2 — Year-over-year revenue trend by region
-- Business question: Which regions are growing vs declining YoY?
-- Business use: Detects geographic momentum shifts — critical for regional budget planning and sales force deployment

SELECT
    region,
    YEAR(invoice_date) AS year,
    ROUND(SUM(total_sales), 2) AS total_revenue
FROM adidas
GROUP BY region, YEAR(invoice_date)
ORDER BY region, year;

-- Q3 — Product profitability analysis
-- Business question: Which product generates the highest operating profit margin?
-- Business use: Helps the merchandising team identify which products are most profitable per dollar of revenue — informs pricing strategy and promotional focus

SELECT
    product,
    ROUND(AVG(operating_margin), 2) AS avg_margin,
    ROUND(SUM(operating_profit), 2) AS total_profit,
    ROUND(SUM(total_sales), 2) AS total_revenue
FROM adidas
GROUP BY product
ORDER BY avg_margin DESC;

-- Q4 — Revenue split by sales method
-- Business question: How does revenue split across In-store, Online, and Outlet?
-- Business use: Informs channel strategy — understanding whether Online is growing the market or cannibalising In-store is essential for marketing investment decisions

SELECT
    sales_method,
    ROUND(SUM(total_sales), 2) AS total_revenue,
    ROUND(SUM(total_sales) * 100.0 / SUM(SUM(total_sales)) OVER(), 2) AS revenue_share,
    ROUND(AVG(operating_margin), 2) AS avg_margin
FROM adidas
GROUP BY sales_method
ORDER BY total_revenue DESC;

-- Q5 — Top 5 states by revenue 
-- Business question: Which states generate the most revenue?
-- Business use: Supports decisions on where to open new stores, increase distribution, or concentrate regional marketing campaigns

SELECT
    state,
    region,
    ROUND(SUM(total_sales), 2) AS total_revenue,
    SUM(units_sold) AS total_units
FROM adidas
GROUP BY state, region
ORDER BY total_revenue DESC
LIMIT 5;

-- Q6 — Monthly revenue trend across both years 
-- Business question: What are the seasonal peaks and troughs in 2020–2021?
-- Business use: Reveals seasonality patterns — knowing peak and trough months enables supply chain and marketing teams to plan inventory procurement and campaign timing

SELECT
    YEAR(invoice_date) AS year,
    MONTH(invoice_date) AS month,
    MONTHNAME(invoice_date) AS month_name,
    ROUND(SUM(total_sales), 2) AS total_revenue
FROM adidas
GROUP BY YEAR(invoice_date), MONTH(invoice_date), MONTHNAME(invoice_date)
ORDER BY year, month;

-- Q7 — Retailer × sales method revenue cross-analysis 
-- Business question: Which retailer performs best through which sales channel?
-- Business use: Enables channel-specific account strategy — for eg, if Amazon dominates online but underperforms in-store, Adidas can focus digital co-marketing budgets accordingly

SELECT
    retailer,
    sales_method,
    ROUND(SUM(total_sales), 2) AS total_revenue,
    SUM(units_sold) AS total_units,
    ROUND(AVG(operating_margin), 2) AS avg_margin
FROM adidas
GROUP BY retailer, sales_method
ORDER BY retailer, total_revenue DESC;

