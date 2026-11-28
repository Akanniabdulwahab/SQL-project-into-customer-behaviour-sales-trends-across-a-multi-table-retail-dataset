
															-- Data Cleaning
-- Original dataset
select * from customers;
select * from orders;
select *from products;


			# Project Workfloww
-- 1. Create a copy of the data
-- 2. Remove Duplicates
-- 3. Standardize the Data
-- 4. Remove any rows/columns that are not essential

										#  1. Create a copy of the two dataset
create table customers_copy
like customers;
create table orders_copy
like orders;
create table products_copy
like products;

select *
from customers_copy;

select *
from orders_copy;

select *
from products_copy;

-- insert the data into customer_copy & order_copy table
insert customers_copy
select *
from customers;

insert orders_copy
select *
from orders;

insert products_copy
select * 
from products;

select * from customers_copy;
select * from orders_copy;
select * from products_copy;

											
													# 2. Remove Duplicates
											# (Removing duplicates on the customer table)
select *,
row_number() 
over(partition by customer_id, customer_name, email, phone, signup_date, 
					country, age, gender, loyalty_tier) as row_num
from customers_copy;

-- Put the above code into a subquery or a CTE to filter based on the row_num > 1

-- Using a subquery
select * 
from (select *,
row_number() 
over(partition by customer_id, customer_name, email, phone, signup_date, country, age, gender, loyalty_tier) as row_num
from customers_copy) as row_num
where row_num > 1;

-- Using a CTE 
with duplicate_customers_copy as
(
select *,
row_number() 
over(partition by customer_id, customer_name, email, phone, signup_date, 
					country, age, gender, loyalty_tier) as row_num
from customers_copy
)
select *
from duplicate_customers_copy
where row_num > 1;
-- checking out the duplicate
select *
from customers_copy
where customer_name = 'Jonathan Scott';

select *
from customers_copy
where customer_name = '  Andre Fernandez  ';

-- create a customers_copy2 table and insert the row_num column then delete where the row_num is greater then 1 (row_num > 1)
CREATE TABLE `customers_copy2` (
  `customer_id` text,
  `customer_name` text,
  `email` text,
  `phone` text,
  `signup_date` text,
  `country` text,
  `age` text,
  `gender` text,
  `loyalty_tier` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from customers_copy2;

insert into customers_copy2
select *,
row_number() 
over(partition by customer_id, customer_name, email, phone, signup_date, 
					country, age, gender, loyalty_tier) as row_num
from customers_copy;

select *
from customers_copy2
where row_num > 1;

-- then delete where row_num > 1
delete
from customers_copy2
where row_num > 1;

-- confirm the duplicate if it has been deleted
select *
from customers_copy2
where customer_name = 'Jonathan Scott';

select *
from customers_copy2
where customer_name = '  Andre Fernandez  ';

select *
from customers_copy2;

													# 2.2 Remove Duplicates
											# (Removing duplicates on the order table)
select * 
from orders_copy;
                  
select *,
row_number() 
over(partition by order_id, customer_id, product_id, quantity, unit_price,
								discount_percent, payment_method, order_date, ship_date, order_status, shipping_country) as row_num
from orders_copy;

-- Put the above code into a subquery or a CTE to filter based on the row_num > 1

-- using a CTE
with duplicate_orders_copy as
(
select *,
row_number() 
over(partition by order_id, customer_id, product_id, quantity, unit_price,
								discount_percent, payment_method, order_date, ship_date, order_status, shipping_country) as row_num
from orders_copy
)
select *
from duplicate_orders_copy
where row_num > 1;

-- Using a subquery
select *
from (select *,
row_number() 
over(partition by order_id, customer_id, product_id, quantity, unit_price,
								discount_percent, payment_method, order_date, ship_date, order_status, shipping_country) as row_num
from orders_copy) as row_num
where row_num > 1;

-- create a orders_copy2 table and insert the row_num column then delete where the row_num is greater then 1 (row_num > 1)
CREATE TABLE `orders_copy2` (
  `order_id` text,
  `customer_id` text,
  `product_id` text,
  `quantity` text,
  `unit_price` text,
  `discount_percent` text,
  `payment_method` text,
  `order_date` text,
  `ship_date` text,
  `order_status` text,
  `shipping_country` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
                  
select * from orders_copy2;

insert into orders_copy2
select *,
row_number() 
over(partition by order_id, customer_id, product_id, quantity, unit_price,
								discount_percent, payment_method, order_date, ship_date, order_status, shipping_country) as row_num
from orders_copy;

select *
from orders_copy2
where row_num > 1;

-- then delete where row_num > 1
delete
from orders_copy2
where row_num > 1;

-- checking if the duplicate have been deleted
select *
from orders_copy2
where row_num > 1;


														# 2.3 Remove Duplicates
											# (Removing duplicates on the product table)
select * 
from products_copy;
                  
select *,
row_number() 
over(partition by product_id, product_name, category) as row_num
from products_copy;

-- Put the above code into a subquery or a CTE to filter based on the row_num > 1

-- Using a subquery
select *
from (select *,
row_number() 
over(partition by product_id, product_name, category) as row_num
from products_copy) as row_num
where row_num > 1;

-- There are no duplicate in product_copy table

-- using a CTE
with duplicate_products_copy as
(
select *,
row_number() 
over(partition by product_id, product_name, category) as row_num
from products_copy
)
select *
from duplicate_products_copy
where row_num > 1;

                  
										# 3.1 Standardizing the data (Customer table)
select *
from customers_copy2;

select *
from orders_copy2;

select *
from products_copy;

-- cleaning the customer_id in the customers_copy2 table, orders_copy2 table  and order_id in the orders_copy2 table
-- for customer_id in the customers_copy2 table
UPDATE customers_copy2
SET customer_id = CONCAT('CUST', LPAD(REGEXP_REPLACE(TRIM(customer_id), '[^0-9]', ''), 5, '0'));

-- for order_id in the orders_copy2 table
UPDATE orders_copy2
SET order_id = CONCAT('ORD-', LPAD(REGEXP_REPLACE(TRIM(order_id), '[^0-9]', ''), 6, '0'));

-- for customer_id in the orders_copy2 table
UPDATE orders_copy2
SET customer_id = CONCAT('CUST', LPAD(REGEXP_REPLACE(TRIM(customer_id), '[^0-9]', ''), 5, '0'));

-- confirming the cleaned columns
select customer_id from customers_copy2;
select customer_id from orders_copy2;
select order_id from orders_copy2;


-- customer_name
select customer_name, lower(trim(customer_name))
from customers_copy2;

update customers_copy2
set customer_name = lower(trim(customer_name));

select customer_name 
from customers_copy2;

-- country
select distinct country 
from customers_copy2
order by 1;

select distinct country, 
case
    when TRIM(LOWER(country)) in ('usa', 'us', 'u.s.a.', 'united states', 'united states of america') then 'USA'
    when TRIM(LOWER(country)) in ('uk', 'u.k.', 'united kingdom', 'britain', 'great britain') then 'UK'
    when TRIM(LOWER(country)) in ('ca', 'can.', 'canada') then 'Canada'
    when TRIM(LOWER(country)) in ('au', 'aus', 'australia') then 'Australia'
    when TRIM(LOWER(country)) in ('de', 'germany', 'deutschland') then 'Germany'
    when TRIM(LOWER(country)) in ('fr', 'france') then 'France'
    when TRIM(LOWER(country)) in ('in', 'india') then 'India'
    when TRIM(LOWER(country)) in ('uae', 'u.a.e.', 'united arab emirates') then 'UAE'
end as country
from customers_copy2;

update customers_copy2
SET country = case
    when TRIM(LOWER(country)) in ('usa', 'us', 'u.s.a.', 'united states', 'united states of america') then 'USA'
    when TRIM(LOWER(country)) in ('uk', 'u.k.', 'united kingdom', 'britain', 'great britain') then 'UK'
    when TRIM(LOWER(country)) in ('ca', 'can.', 'canada') then 'Canada'
    when TRIM(LOWER(country)) in ('au', 'aus', 'australia') then 'Australia'
    when TRIM(LOWER(country)) in ('de', 'germany', 'deutschland') then 'Germany'
    when TRIM(LOWER(country)) in ('fr', 'france') then 'France'
    when TRIM(LOWER(country)) in ('in', 'india') then 'India'
    when TRIM(LOWER(country)) in ('uae', 'u.a.e.', 'united arab emirates') then 'UAE'
end;

select distinct country from customers_copy2;

-- gender
 select distinct gender 
 from customers_copy2;

select distinct gender, 
case
	when gender in ('m', 'male') then 'Male'
    when gender in ('f', 'female') then 'Female'
    when gender = 'non-binary' then 'Non-binary'
    when gender = 'other' then 'Other'
end as gender
from customers_copy2;

-- gender
update customers_copy2
set gender = 
case
	when gender in ('m', 'male') then 'Male'
    when gender in ('f', 'female') then 'Female'
    when gender = 'non-binary' then 'Non-binary'
    when gender = 'other' then 'Other'
end;

select distinct gender 
from customers_copy2;

-- convert age <= 0 or age >= 100 to null
select age
from customers_copy2
where age <= 0 or age >= 100;

update customers_copy2
set age = null
where age <= 0 or age >= 100;

-- Signup_date column
-- step 1: replace '','N/A', and 'unknown' with NULLupdate
select signup_date
from customers_copy2
where signup_date in ('n/a', 'unknown', '')
order by 1 desc;

update customers_copy2
set signup_date = null
where signup_date in ('n/a', 'unknown', '');

select distinct signup_date,
str_to_date(signup_date, '%m/%d/%Y')
from customers_copy2;

update customers_copy2
SET signup_date = str_to_date(signup_date, '%m/%d/%Y');

alter table customers_copy2
modify column signup_date date;

-- loyalty_tier
select loyalty_tier
from customers_copy2
where loyalty_tier = 'n/a'
or loyalty_tier = 'none'
or loyalty_tier = '-'
or loyalty_tier = ''
order by 1 desc;
 
update customers_copy2
set loyalty_tier = null
where loyalty_tier = 'n/a'
or loyalty_tier = 'none'
or loyalty_tier = '-'
or loyalty_tier = '';

										# 3.2 Standardizing the data (Order table)
-- Payment Method
select distinct payment_method
from orders_copy2;

select distinct payment_method,
case
	when payment_method in ('cr. card', 'credit card', ' credit card ', 'cc', 'credit_card') then 'Credit Card'
    when payment_method in ('GIFTCARD', 'Gift-Card', 'Gift Card') then 'Gift Card'
    when payment_method in ('Bank_Transfer', 'bank transfer') then 'Bank Transfer'
	when payment_method in ('debit card', 'dc', 'debit_card') then 'Debit Card'
    when payment_method in ('Pay-Pal', 'paypal', 'pay pal') then 'Paypal'
    when payment_method in ('wire transfer') then 'Wire Transfer'
end as payment_method
from orders_copy2;

update orders_copy2
set payment_method = 
case
	when payment_method in ('cr. card', 'credit card', ' credit card ', 'cc', 'credit_card') then 'Credit Card'
    when payment_method in ('GIFTCARD', 'Gift-Card', 'Gift Card') then 'Gift Card'
    when payment_method in ('Bank_Transfer', 'bank transfer') then 'Bank Transfer'
	when payment_method in ('debit card', 'dc', 'debit_card') then 'Debit Card'
    when payment_method in ('Pay-Pal', 'paypal', 'pay pal') then 'Paypal'
    when payment_method in ('wire transfer') then 'Wire Transfer'
end;

-- Order status
select distinct order_status
from orders_copy2;

select distinct order_status,
case
	when order_status in ('In Progress', 'Processing', 'in-progress') then 'Processing'
    when order_status in ('Delivered', 'deliverred','Deliverd') then 'Delivered'
    when order_status in ('canceled', 'CANCELLED') then 'Cancelled'
    when order_status in ('RETURNED', 'Retured') then 'Returned'
    when order_status in ('Pendng', 'PENDING') then 'Pending'
    when order_status in ('SHIPPED', 'Shiped') then 'Shipped'
end as order_status
from orders_copy2;
    
update orders_copy2
set order_status = 
case
	when order_status in ('In Progress', 'Processing', 'in-progress') then 'Processing'
    when order_status in ('Delivered', 'deliverred','Deliverd') then 'Delivered'
    when order_status in ('canceled', 'CANCELLED') then 'Cancelled'
    when order_status in ('RETURNED', 'Retured') then 'Returned'
    when order_status in ('Pendng', 'PENDING') then 'Pending'
    when order_status in ('SHIPPED', 'Shiped') then 'Shipped'
end;
    
-- shipping country
select distinct shipping_country
from orders_copy2;

select distinct shipping_country,
case
    when shipping_country in ('usa', 'us', 'u.s.a.', 'united states', 'united states of america') then 'USA'
    when shipping_country in ('uk', 'u.k.', 'united kingdom', 'britain', 'great britain') then 'UK'
    when shipping_country in ('ca', 'can.', 'canada') then 'Canada'
    when shipping_country in ('au', 'aus', 'australia') then 'Australia'
    when shipping_country in ('de', 'germany', 'deutschland') then 'Germany'
    when shipping_country in ('fr', 'france') then 'France'
    when shipping_country in ('in', 'india') then 'India'
    when shipping_country in ('uae', 'u.a.e.', 'united arab emirates') then 'UAE'
end as shipping_country
from orders_copy2;

update orders_copy2
SET shipping_country = 
case
	when shipping_country in ('usa', 'us', 'u.s.a.', 'united states', 'united states of america') then 'USA'
	when shipping_country in ('uk', 'u.k.', 'united kingdom', 'britain', 'great britain') then 'UK'
	when shipping_country in ('uae', 'u.a.e.', 'united arab emirates') then 'UAE'
	when shipping_country in ('de', 'germany', 'deutschland') then 'Germany'
	when shipping_country in ('au', 'aus', 'australia') then 'Australia'
	when shipping_country in ('ca', 'can.', 'canada') then 'Canada'
	when shipping_country in ('fr', 'france') then 'France'
	when shipping_country in ('in', 'india') then 'India'
end;

-- order date and ship_date (converting it to the right data type)
select * 
from orders_copy2
where order_date in ('n/a', 'unknown', '')
or order_date is null;

update orders_copy2
set order_date = null
where order_date in ('n/a', 'unknown', '');

select distinct order_date,
str_to_date(order_date, '%m/%d/%Y')
from orders_copy2;

update orders_copy2
SET order_date = str_to_date(order_date, '%m/%d/%Y');

alter table orders_copy2
modify column order_date date;


-- ship_date
select  distinct ship_date 
from orders_copy2
where ship_date in ('n/a', 'unknown', '')
or ship_date is null
order by 1 desc;

update orders_copy2
set ship_date = null
where ship_date in ('n/a', 'unknown', '');

select distinct ship_date,
str_to_date(ship_date, '%m/%d/%Y')
from orders_copy2;

update orders_copy2
SET ship_date = str_to_date(ship_date, '%m/%d/%Y');

alter table orders_copy2
modify column ship_date date;

-- unit price (trimming and remiving the leading $)
select distinct unit_price
from orders_copy2
where unit_price like '%$%' or unit_price like '%USD%';

select distinct unit_price, 
trim(
	trim(leading '$' from unit_price)
)
from orders_copy2;

select distinct unit_price, 
trim(
	replace(unit_price, 'USD', '')
)
from orders_copy2;

select distinct unit_price,
trim(
    replace(
			replace(unit_price, '$', ''), 'USD', '')
) as unit_price
from orders_copy2;

update orders_copy2
set unit_price = trim(
    replace(
			replace(unit_price, '$', ''), 'USD', '')
);

-- discount_percent (converting '', -, n/a, and none to null)
select distinct discount_percent
from orders_copy2
where trim(discount_percent) = '-'
   OR trim(discount_percent) = ''
   OR trim(discount_percent) = 'n/a'
   OR trim(discount_percent) = 'none';

update orders_copy2
set discount_percent = null
where trim(discount_percent) = '-'
   OR trim(discount_percent) = ''
   OR trim(discount_percent) = 'n/a'
   OR trim(discount_percent) = 'none';
   
--  discount_percent (converting to null where it's greater than 100 and less than o)
select distinct discount_percent
from orders_copy2
where trim(discount_percent) < 0
   OR trim(discount_percent) > 100;
   
update orders_copy2
set discount_percent = 0
where trim(discount_percent) < 0
   OR trim(discount_percent) > 100;

-- investigating where quantity is < 0
select distinct quantity 
from orders_copy2
where quantity < 0;

update orders_copy2
set quantity = 0
where quantity < 0;

-- investigatng where quantity = '' and set it to null
select distinct quantity 
from orders_copy2
where quantity = '';

update orders_copy2
set quantity = null
where quantity = '';

-- investigating where quantity is 0 and  order_status != 'cancelled' when grouped by order_status
select order_status, count(*)
from orders_copy2
where quantity = 0
and order_status != 'cancelled'
group by order_status;

select quantity, order_status
from orders_copy2
where quantity = 0
and order_status != 'cancelled';


							-- convert columns to the right datatypes
-- customer table
-- Age column
alter table customers_copy2
modify column age int;

-- Order table
alter table orders_copy2
modify column quantity int;

alter table orders_copy2
modify column unit_price int;

alter table orders_copy2
modify column discount_percent int;


									-- 4. Remove any rows/columns that are not essential

-- Delete rows that are not needed
select *
from orders_copy2
where quantity is null
or quantity = 0;

delete
from orders_copy2
where quantity is null
or quantity = 0;

-- Delete columns that are not needed
alter table orders_copy2
drop column row_num;

alter table customers_copy2
drop column row_num;

