										-- Explortory Data Analysis (EDA)
                                        
-- create and add revenue column to the orders_copy2 table
select quantity, unit_price, discount_percent,
round((quantity * unit_price) - (quantity * unit_price) * coalesce(discount_percent, 0) / 100, 2) as revenue
from orders_copy2;

alter table orders_copy2
add column revenue decimal(10,2)
generated always as (
round((quantity * unit_price) - (quantity * unit_price) * coalesce(discount_percent, 0) / 100, 2)
) stored;

-- 1. Distribution of customers by age_group
select customer_id, age,
case
	when age between 18 and 24 then 'Young Adult'
    when age between 25 and 34 then 'Early Career'
    when age between 35 and 44 then 'Established'
    when age between 45 and 54 then 'Mid-Career'
    when age between 55 and 64 then 'Senior'
    when age between 65 and 75 then 'Pre-Retirement'
end as age_group
from customers_copy2;

-- 1. Distribution of customers by age_group
select age_group, count(*) as no_of_customers
from 
(
select customer_id, age,
case
	when age between 18 and 24 then 'Young Adult'
    when age between 25 and 34 then 'Early Career'
    when age between 35 and 44 then 'Established'
    when age between 45 and 54 then 'Mid-Career'
    when age between 55 and 64 then 'Senior'
    when age between 65 and 75 then 'Pre-Retirement'
end age_group
from customers_copy2
)age_group
group by age_group
order by no_of_customers desc;

-- count of genders
select gender, count(*) count_of_gender
from customers_copy2
group by gender;

-- no of customers per country
select country, count(*) no_of_customers_per_country
from customers_copy2
group by country
order by no_of_customers_per_country desc;

-- coutries with the highest revenue
select shipping_country, sum(revenue) as sum_of_revenue
from orders_copy2 
group by shipping_country
order by sum_of_revenue desc;

-- Maximum order per day
select order_date, count(*) as max_order_per_day
from orders_copy2
where order_date is not null
group by order_date
order by max_order_per_day desc
limit 7;

-- Loyalty tier: customer count, and correlation with total spend
select loyalty_tier, count(*) AS customer_count
FROM customers_copy2
group by loyalty_tier
order by customer_count desc;


-- Which loyalty tier has the most customers, total revenue by loyalty_tier and average revenue by loyalty_tier
select loyalty_tier, count(c.customer_id) as no_of_customers, sum(revenue) as sum_of_revenue, avg(revenue) as avg_revenue
from customers_copy2 as c
join orders_copy2 as o
on c.customer_id = o.customer_id
where loyalty_tier is not null
group by c.loyalty_tier
order by sum_of_revenue desc;


-- Top 10 best-selling products by quantity sold and revenue 
select product_name, sum(quantity) as quantity_sold, sum(revenue) as total_revenue
from orders_copy2 as o
join products_copy as p
on o.product_id = p.product_id
group by product_name
order by total_revenue desc
limit 10;

-- Products with the highest average discount applied
select product_name, round(avg(o.discount_percent), 2) as avg_discount
from orders_copy2 o
join products_copy p 
on o.product_id = p.product_id
group by p.product_name
order by avg_discount desc
limit 10;

-- What percentage of orders are Cancelled, Returned, Shipped, Processing, Pending, and Delivered?
select order_status,
    count(*) as order_count,
    round(count(*) * 100.0 / (select COUNT(*) from orders_copy2), 2) as percent_of_total
from orders_copy2
group by order_status
order by percent_of_total desc;

-- Most used payment method
select payment_method, count(*) as no_of_times_used
from orders_copy2
group by payment_method
order by no_of_times_used desc;

-- Revenue by age_grop
select 
case
	when age between 18 and 24 then 'Young Adult'
    when age between 25 and 34 then 'Early Career'
    when age between 35 and 44 then 'Established'
    when age between 45 and 54 then 'Mid-Career'
    when age between 55 and 64 then 'Senior'
    when age between 65 and 75 then 'Pre-Retirement'
end as age_group,
sum(revenue) as revenue
from customers_copy2 as c
join orders_copy2 as o
on c.customer_id = o.customer_id
group by age_group
having age_group is not null
order by revenue desc;

-- using cte
with age_grouping as
(
select customer_id,
case
	when age between 18 and 24 then 'Young Adult'
    when age between 25 and 34 then 'Early Career'
    when age between 35 and 44 then 'Established'
    when age between 45 and 54 then 'Mid-Career'
    when age between 55 and 64 then 'Senior'
    when age between 65 and 75 then 'Pre-Retirement'
end as age_group
from customers_copy2
)
select age_group, sum(revenue) as revenue
from age_grouping as a
join orders_copy2 as o
on a.customer_id = o.customer_id
where age_group is not null
group by age_group
order by revenue desc;

-- using temp table
create temporary table age_grouping
select customer_id,
case
	when age between 18 and 24 then 'Young Adult'
    when age between 25 and 34 then 'Early Career'
    when age between 35 and 44 then 'Established'
    when age between 45 and 54 then 'Mid-Career'
    when age between 55 and 64 then 'Senior'
    when age between 65 and 75 then 'Pre-Retirement'
end as age_group
from customers_copy2;

select age_group, sum(revenue) as revenue
from age_grouping as a
join orders_copy2 as o
on a.customer_id = o.customer_id
where age_group is not null
group by age_group
order by revenue desc;

-- Total revenue without cancelled orders
select sum(revenue) as total_revenue
from orders_copy2
where order_status != 'cancelled';

-- How many days between order_date and shio_date
select order_date, ship_date, datediff(ship_date, order_date) as no_of_days_to_ship
from orders_copy2
order by no_of_days_to_ship desc
limit 10;

-- Average days to ship
select round(avg(no_of_days_to_ship), 0) as avg_no_of_days_to_ship
from (select order_date, ship_date, datediff(ship_date, order_date) as no_of_days_to_ship
	  from orders_copy2) as no_of_days_to_ship_table;
      
-- Average days to ship per country
select shipping_country, round(avg(no_of_days_to_ship), 0) as avg_no_of_days_to_ship_per_country
from (
		select shipping_country, order_date, ship_date, datediff(ship_date, order_date) as no_of_days_to_ship
		from orders_copy2
	 ) as no_of_days_to_ship_table
group by shipping_country;

-- Category with the highest revenue
select category, count(order_id) as no_of_orders, sum(revenue) as sum_of_revenue
from products_copy as p
join orders_copy2 as o
on p.product_id = o.product_id
group by category
order by sum_of_revenue desc;

-- Product with the highest revenue
select product_name, count(order_id) as no_of_orders, sum(revenue) as sum_of_revenue
from products_copy as p
join orders_copy2 as o
on p.product_id = o.product_id
group by product_name
order by sum_of_revenue desc
limit 10;


select min(order_date), max(order_date)
from orders_copy2;

-- Maximum amounts made in a day
select order_date, sum(revenue) as revenue_in_a_day
from orders_copy2
where order_status != 'cancelled'
and order_date is not null
group by order_date
order by revenue_in_a_day desc
limit 15;

-- revenue per year
select year(order_date ) as years, sum(revenue) as revenue_per_year
from orders_copy2
where order_status != 'cancelled' 
and year(order_date) is not null
group by year(order_date)
order by year(order_date);

-- revenue by each month
select substring(order_date,1,7) as `month`, sum(revenue) as revenue_per_month
from orders_copy2
where order_status != 'cancelled'
and substring(order_date,1,7) is not null
group by `month`
order by 1
limit 15;

-- Rolling total 
with rolling_total as
(
select substring(order_date,1,7) as `month`, sum(revenue) as revenue_per_month
from orders_copy2
where order_status != 'cancelled'
group by `month`
order by 1
)
select `month`, revenue_per_month, sum(revenue_per_month) 
over(order by `month`) as rolling_total
from rolling_total
where `month` is not null;

-- years0 each country made most profit
select shipping_country, year(order_date), sum(revenue)
from orders_copy2
group by shipping_country, year(order_date)
order by shipping_country;

-- years each country made most profit
with revenue_year (shipping_country, years, total_revenue) as 
(
select shipping_country, year(order_date), sum(revenue)
from orders_copy2
where order_status != 'cancelled'
group by shipping_country, year(order_date)
), country_year_rank as 
(select *, dense_rank() over(partition by years order by total_revenue) as ranking
from revenue_year
where years is not null
)
select * 
from country_year_rank
where ranking <= 5;




















