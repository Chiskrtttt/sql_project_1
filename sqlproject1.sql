
-- Customer purchase behavior
	-- Geographical segmentation (city & state)
select customer_city, count (*) as total_customers
from customers 
group by customer_city
order by total_customers; 
select customer_state, count (*) as total_customers
from customers 
group by customer_state
order by total_customers; 
	-- Total sales of different state
select customer_state, count (order_id) as total_orders
from customers
inner join orders on orders.customer_id = customers.customer_id
group by customer_state; 

	-- More photos -> more orders?
select products.product_photos_qty, count (order_items.order_id) as total_orders
from order_items 
inner join products on order_items.product_id = products.product_id
group by products.product_photos_qty;
	-- Preferred payment type?
select payment_type, count (*) as total_customers
from order_payments
group by payment_type;
	-- Average value paid with each payment type
select payment_type, avg (payment_value) as average_value
from order_payments
group by payment_type; 
	-- Top buying seasons
		-- Convert to date
SELECT datetime(order_purchase_timestamp) AS order_datetime FROM orders;
select strftime('%m',order_purchase_timestamp) as order_month, count (*) as total_purchases
from orders
group by order_month;

-- Product performance 
	-- English name for categories
ALTER TABLE products
ADD COLUMN products_english_name TEXT;
UPDATE products
SET products_english_name = (
    SELECT product_category_name_translation.product_category_name_english
    FROM product_category_name_translation
    WHERE products.product_category_name = product_category_name_translation.product_category_name
)
WHERE EXISTS (
    SELECT 1
    FROM product_category_name_translation
    WHERE products.product_category_name = product_category_name_translation.product_category_name
);
	-- Top categories with the most sale
select products.products_english_name, count (*) as total_orders from order_items 
inner join products on order_items.product_id = products.product_id
group by products.products_english_name
order by total_orders desc;
	-- Average number of products a seller has
SELECT seller_id, COUNT(DISTINCT order_id) AS total_orders
FROM order_items
GROUP BY seller_id;
SELECT AVG(total_orders) AS average_orders_per_seller
FROM (
    SELECT seller_id, COUNT(DISTINCT order_id) AS total_orders
    FROM order_items
    GROUP BY seller_id
) AS orders_per_seller;
	-- Top location of seller
select seller_city, count (*) as no_sellers from sellers
group by seller_city
order by no_sellers desc;
	-- Average photo a product has 
select product_id, SUM (product_photos_qty) as total_photos
from products 
group by product_id;
select avg(total_photos) as average_photoss_per_product
from (select product_id, SUM (product_photos_qty) as total_photos
from products 
group by product_id); 
	-- Top reached platform 
select origin, count (*) as total_reach
from leads_qualified lq
group by origin
order by total_reach desc; 
	