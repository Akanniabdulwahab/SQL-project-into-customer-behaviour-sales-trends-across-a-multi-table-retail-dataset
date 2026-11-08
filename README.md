## Executive Summary
This project set out to answer a question every retail business eventually has to ask: what is our data actually telling us about our customers, our products, and our sales performance and can we trust it enough to act on it? The analysis worked with three related datasets: customers (835 records), orders (5,020 records), and products (43 records) representing a typical e-commerce operation. Before any business question could be answered, the raw data required significant investigation and cleaning, inconsistent identifiers, mixed date formats, non-standard missing-value placeholders, invalid numeric values, and duplicate records all had to be identified and resolved using SQL.
After cleaning, the dataset was reduced from 5,898 combined raw records (835 customers + 5,020 orders + 43 products) to 5,667 trustworthy records (820 customers + 4,804 orders + 43 products), and was then used to answer a few business questions spanning customer behavior, product performance, and sales trends.

Key findings from the analysis:

●	Order outcomes are almost perfectly evenly distributed across all six statuses Delivered, Shipped, Processing, Cancelled, Returned, and Pending each account for roughly 16.5 - 16.8% of all orders, with no single outcome dominating.

●	Total confirmed revenue (excluding cancelled orders) reached $2,598,041.85 across 4,004 non-cancelled orders, an average order value of approximately $648.86.

●	Revenue leadership does not always follow order volume. Apparel generated the highest category revenue ($570,985.57) despite Electronics recording more individual orders (839 vs. 827) a pattern that repeated at the product level.

●	Unit sales and revenue leadership diverge at the product level. The Wireless Keyboard sold the most units (517) of any product, yet the Running Belt generated the most revenue ($103,678.27) on fewer units sold (507).

●	The Gold loyalty tier leads on both customer count (199) and total tier revenue ($768,731.01) but average revenue per order is closely clustered across all four tiers ($622 - $659).

●	Shipping performance is remarkably consistent average fulfillment time is 5 days, holding true across every shipping country with no meaningful geographic variation.

●	Revenue by shipping country is relatively balanced, ranging from $367,809 (India) to $422,514 (Canada) no single market accounts for a disproportionate share of revenue.

Business implication: the data does not point to an urgent crisis, but it does surface clear opportunities particularly around understanding why Apparel and the Running Belt outperform on revenue despite not leading on volume, and around the essentially uniform order-status distribution, which is worth validating against real operational definitions.
Primary recommendation: prioritize a deeper investigation into the price-vs-volume divergence at the category and product level, since it directly affects merchandising and promotional strategy, and would benefit from margin data not currently available in this dataset.

Key metrics at a glance:

<img width="568" height="227" alt="Key metrics" src="https://github.com/user-attachments/assets/1ee15373-1e0a-4c22-97dc-ed74eeb423b8" />

## Business Context
The dataset structure is consistent with a mid-sized, multi-country online retailer selling physical products across several categories, including Electronics, Apparel, Home & Kitchen, Beauty, Sporting Goods, and Office Supplies.

●	Customers are individual consumers with demographic attributes (age, gender, country) and a loyalty program (Bronze/Silver/Gold/Platinum tiers).

●	Products are cataloged with category, a standard retail product catalog structure.

●	Orders represent individual purchase transactions, capturing product, quantity, pricing, discount, payment method, fulfillment dates, and order status.

Understanding the relationships between these three entities matters because it is only through combining them that meaningful business questions can be answered. A customer table alone can't reveal spending behavior, and an orders table alone can't reveal which customer segments or products actually drive that behavior.

## Business Problem
The business has transactional and customer data but lacks a unified understanding of what is actually driving performance. This creates the central analytical question:
How can the business use its customer, product, and order data to identify the factors driving sales performance, and uncover opportunities for customer growth, retention, and revenue optimization?

Here are some questions that can be answered from each table:

Customer questions

●	Who are the most valuable customers, and how concentrated is revenue among them?

●	How is the customer base distributed by country, age, and gender?

●	Does loyalty tier correlate with spending behavior?

Product questions

●	Which products and categories generate the most revenue?

●	Which products sell the highest volume and is that the same as revenue leadership?

●	Which products carry the highest average discount?

Order questions

●	What is the average order value, and how does it vary by category?

●	What proportion of orders are cancelled or returned?

●	Is there a relationship between payment method and order outcome?

●	How efficient is order fulfillment, and does it vary by market?

4. Analytical Objectives

● Establish a trustworthy, cleaned dataset from raw, inconsistent source data.

● Quantify customer distribution and value across demographic and loyalty segments.

● Identify product and category level revenue and volume drivers.

● Characterize order outcomes, payment behavior, and fulfillment performance.

● Translate findings into concrete, prioritized business recommendations.

## Dataset Overview

Three related tables were used, joined via customer_id and product_id:

customers (835 raw rows to 820 cleaned)

<img width="568" height="178" alt="2 1 Data overview(customers)" src="https://github.com/user-attachments/assets/6d21fa50-0515-49de-93b8-be31a2524020" />

orders (5,020 raw rows → 4,804 cleaned)

<img width="571" height="215" alt="2 2 Data overview (orders)" src="https://github.com/user-attachments/assets/68fab6b7-bc08-4713-ac49-fdcf02065891" />

products (43 rows, unchanged by cleaning)

<img width="568" height="93" alt="2 3 Data overview (products)" src="https://github.com/user-attachments/assets/e12d5828-876e-4f82-8ad4-5d6c57ad3870" />

## Tools & Technology Stack
<img width="567" height="192" alt="3  Technology stack" src="https://github.com/user-attachments/assets/f1b5cda4-a488-493d-9e7c-881f6aac7497" />

Methodology / Pipeline Overview

The project followed four broad stages:

●	Import & Inspection: load raw data into working copies and profile initial data quality issues

●	Cleaning & Standardization: remove duplicates, standardize identifiers and categorical values, resolve missing/invalid values, convert data types

●	Validation: confirm row counts, referential integrity, and column consistency before trusting the data for analysis

●	Exploratory Analysis: answer business questions across customer, product, and order/sales dimensions, using both standard aggregation and advanced SQL techniques

A key methodological discipline maintained throughout raw source tables were never modified directly. All cleaning was performed on working copies (customers_copy2, orders_copy2), so the original import remains available to restart from at any point.

## Data Import & Initial Inspection
Each dataset was first loaded into staging tables (customers, orders, products) as-is, then working copies (customers_copy, orders_copy, products_copy) were created to preserve the original raw data untouched:


































































