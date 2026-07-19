create database sales;
select * from sales.brands;
select * from sales.stores;
select * from sales.staffs;
SHOW CREATE TABLE staffs;
SELECT store_id, COUNT(*)
FROM storesorder_items
GROUP BY store_id
HAVING COUNT(*) > 1;
ALTER TABLE staffs
ADD INDEX idx_store_id (store_id);
SELECT * FROM stocks;
SHOW CREATE TABLE stocks;
SHOW CREATE TABLE stores;
SELECT
    o.order_id,
    o.order_date,
    oi.item_id,
    p.product_name,
    oi.quantity,
    oi.list_price,
    oi.discount
FROM orders o
INNER JOIN order_items oi
ON o.order_id = oi.order_id
INNER JOIN products p
ON oi.product_id = p.product_id;

-- 4th
SELECT
    s.store_name,
    ROUND(SUM((oi.list_price * oi.quantity) * (1 - oi.discount)), 2) AS total_sales
FROM stores s
JOIN orders o
    ON s.store_id = o.store_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY total_sales DESC;

-- 5th
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- 6th
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS total_items_purchased,
    ROUND(SUM((oi.list_price * oi.quantity) * (1 - oi.discount)), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_revenue DESC;

-- 7th
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ROUND(SUM((oi.list_price * oi.quantity) * (1 - oi.discount)), 2) AS total_spent,
    CASE
        WHEN SUM((oi.list_price * oi.quantity) * (1 - oi.discount)) < 2000
            THEN 'Low'
        WHEN SUM((oi.list_price * oi.quantity) * (1 - oi.discount)) BETWEEN 2000 AND 5000
            THEN 'Medium'
        ELSE 'High'
    END AS spending_segment
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 8th
SELECT
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM((oi.list_price * oi.quantity) * (1 - oi.discount)), 2) AS total_revenue
FROM staffs s
JOIN orders o
    ON s.staff_id = o.staff_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY total_revenue DESC;

-- 9th
SELECT
    s.store_id,
    st.store_name,
    p.product_id,
    p.product_name,
    s.quantity
FROM stocks s
JOIN products p
    ON s.product_id = p.product_id
JOIN stores st
    ON s.store_id = st.store_id
WHERE s.quantity < 10
ORDER BY s.quantity ASC;

--  10th
CREATE TABLE customer_segments (
    customer_id VARCHAR(100) NOT NULL,
    segment VARCHAR(50),
    PRIMARY KEY (customer_id),
    CONSTRAINT fk_customer_segments_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

SELECT * FROM customer_segments;