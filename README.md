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

<img width="806" height="398" alt="1 0 Original dataset (customer table)" src="https://github.com/user-attachments/assets/5b13afd3-070e-4746-9695-64ca0e8786d0" />

<img width="902" height="398" alt="1 1 Original dataset order table)" src="https://github.com/user-attachments/assets/05068e36-532f-4a2a-9f5e-573bcf8356c4" />

<img width="313" height="397" alt="1 2 Original dataset (product table)" src="https://github.com/user-attachments/assets/1d5207fa-4317-40ee-ba5c-cdf018863c8a" />

This "copy-first" approach is a standard safeguard. it ensures the original import is always available to reference or restart from if a cleaning step goes wrong.

**Data Quality Assessment**

Inspection of the raw data surfaced the following confirmed issues (each addressed in Section 8):

●	Duplicate records in both customers_copy and orders_copy

●	Inconsistent identifier formatting customer_id and order_id values appeared in multiple formats (e.g. CUST00001, cust-1, C1) with inconsistent whitespace

●	Inconsistent categorical values country, gender, payment_method, and order_status each contained multiple casing/spelling variants representing the same underlying value

●	Non-standard missing-value placeholders’ text such as 'n/a', 'unknown', 'none', '-', and empty strings were used instead of true SQL NULL

●	Invalid numeric values ages outside a plausible human range, discount percentages outside 0–100%, and negative order quantities

●	Text-formatted dates and currency date and price columns stored as unformatted text, preventing direct numeric or date-based analysis

## Data Cleaning From Raw Data to Trusted Data

Before analyzing performance, the first challenge was determining whether the data could be trusted at all. Below is the major cleaning problems addressed, each following the same investigate-then-fix pattern.

**a. Duplicate customer and order records**

Duplicate rows silently inflate counts, revenue totals, and customer metrics.  A customer counted twice looks like two customers; an order counted twice looks like two purchases.

15 duplicate customer records were identified and removed (835 to 820). A number of duplicate order records were similarly removed as part of the broader orders cleanup (5,020 to 4,804, combined with the invalid-quantity row removal described below).

Same duplicate removal steps was also carried out on the order table.

**b. Inconsistent ID formatting (customer_id, order_id)**

If the same customer's ID appears as CUST00001 in one table and cust-1 in another, joins between tables will silently fail to match, undercounting that customer's activity without any error being raised.

Every customer_id in all tables and order_id in the order_table now reliably matches its counterpart in customers, making every join in this report trustworthy.

**c. Inconsistent categorical values (country, gender, payment_method, order_status)**

If "USA," "US," and "United States" are treated as three separate values, no single query can correctly answer "how many customers are in the United States?"

Every categorical column now has a single, consistent set of values, confirmed via SELECT DISTINCT after each update.

Same cleaning process was applied to gender, payment_method, order_status

**d. Non-standard missing-value placeholders**

SQL's IS NULL only recognizes true NULL values. Text like 'n/a' or 'unknown' is treated as a real value by aggregate functions, silently corrupting averages and counts unless explicitly converted first.

All placeholder text was converted to true NULL before any date conversion or numeric aggregation was performed. This ensures that calculations like average discount or average fulfillment time correctly exclude missing data rather than silently mishandling placeholder text

Same step was applied to signup_date, order_date, ship_date, loyalty_tier, and discount_percent

**e. Invalid numeric values (age, discount, quantity)**

An age of 0 or a discount of 150% isn't just noisy it's logically impossible, and including it would distort every average calculated on that column.

Note: the discount-percent decision mapping invalid values to 0 rather than NULL. It assumes an invalid discount most likely represents "no discount applied" rather than genuinely unknown data, which very slightly pulls average-discount figures downward compared to treating those rows as missing.

**f.  Zero-quantity orders needed context, not a blanket rule**

A quantity = 0 order isn't automatically bad data if the order was cancelled, zero quantity fulfilled is logically consistent. Treating all zero-quantity rows identically risks either keeping genuine errors or discarding legitimate records.

Ultimately, all rows with quantity IS NULL OR quantity = 0 were removed in the final cleanup step, as they could not contribute a meaningful quantity value to revenue calculations regardless of the reason. This means the small number of legitimately-zero cancelled-order rows were removed alongside genuinely invalid rows.
Business impact: revenue and quantity figures in this report reflect only orders with a valid, non-zero quantity. One consequence: the Cancelled order count reported later (800 orders) reflects orders with a valid quantity that were subsequently cancelled it does not include any zero-quantity cancellations that existed prior to this cleanup step, since those rows were removed entirely.

**g Currency-formatted price strings**

A column containing "$42.58", "126.36 USD", and "42.58" in the same field cannot be summed, averaged, or compared numerically until it's a consistent number.

All currency symbols and suffixes were stripped, leaving a clean numeric string ready for type conversion. This enables every revenue calculation in this report without this step, unit_price could not be multiplied by quantity at all.

**h. Type Conversion**

Once each column passed validation, it was converted to its proper type:

Discount_percent were converted to INT rather than DECIMAL. This means cent-level fractional discount percentages (e.g. 15.5%) were rounded before revenue was calculated. The revenue figures throughout this report are therefore accurate to the nearest whole currency unit, not the cent a reasonable trade-off for high-level business analysis, but worth noting for anyone reconciling these figures against a system that retains full decimal precision.

## Cleaned Dataset

This is a cleaned version of the Dataset

<img width="781" height="395" alt="16 1 customer_cleaned" src="https://github.com/user-attachments/assets/a6998226-8fa8-4653-9e6b-125159dc4392" />

<img width="934" height="398" alt="16 2 order_cleaned" src="https://github.com/user-attachments/assets/a3b8d717-88aa-4ace-80c9-4a05f3cb5a7c" />

## Exploratory Data Analysis
With the data now cleaned, the next set of questions should be answering business performance starting with a foundational calculation that underlies every subsequent finding: REVENUE.

<img width="845" height="523" alt="1" src="https://github.com/user-attachments/assets/81b004ab-b168-4ae8-a366-d69570671cc5" />

This generated column automatically calculates each order line's actual revenue (price minus discount).

##Customer Analysis##

**Age distribution**

<img width="521" height="535" alt="2" src="https://github.com/user-attachments/assets/007eb513-e027-43a1-9e1e-411a0e085165" />

The customer base is weighted toward older age brackets — the 55+ population (296 customers) outnumbers the under-35 population (202 customers).

**Gender distribution**

<img width="402" height="282" alt="3" src="https://github.com/user-attachments/assets/0f33dce0-3451-47ab-a7fe-0ff216a70196" />

Roughly 9% of customers have no recorded gender. B

**Customers per Country**

Country distribution is close with no single market dominating. Germany leading only slightly.

<img width="472" height="362" alt="4" src="https://github.com/user-attachments/assets/ca568949-a399-4106-b526-a445f49abd25" />

**Country by revenue**

<img width="500" height="373" alt="5" src="https://github.com/user-attachments/assets/50d101bb-5917-4194-96f8-bc9670b8089a" />

Canada brings in the most revenue which ranks fourth for the mos number of customers

**Best selling products by quantity sold and revenue generated^^

<img width="675" height="447" alt="9" src="https://github.com/user-attachments/assets/e2b9a4bf-7968-4b70-91ee-e8482f98b9e6" />

Wireless keyboard has more quantity sold than running belt but generated less revenue

**Most used payment method**

<img width="495" height="324" alt="12" src="https://github.com/user-attachments/assets/a10c6731-62e8-443e-ada1-b4dc7f302210" />

## Reccomendations

- Apparel and the Running Belt outperform on revenue despite not leading on order/unit count. Check to determine whether this divergence reflects healthy premium pricing or an opportunity to grow volume on already-high-value items.

- 9% of customers are missing gender data and 8% are missing loyalty tier assignment. Review the signup/enrollment flow for opportunities to capture this data more completely, without adding friction.

- 
































