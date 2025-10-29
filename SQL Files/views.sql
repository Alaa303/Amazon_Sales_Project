select top 10 * from dbo.orders_fact
GO
-- views , procedures, triggers, indexes, cte, window fun, functions

------------------- views ------------------
-- order summary
CREATE VIEW vw_orders_summary AS
SELECT 
    f.order_id,
    d.date AS order_date,
    p.category,
    sc.sales_channel AS sales_channel,
    f.quantity,
    f.amount,
    f.currency,
    f.status,
    l.ship_state AS ship_state
FROM orders_fact f
JOIN date_dim d ON f.date_id = d.date_id
JOIN product_dim p ON f.product_id = p.product_id
JOIN sales_channel_dim sc ON f.sales_channel_id = sc.sales_channel_id
JOIN location_dim l ON f.ship_state_id = l.ship_state_id;
Go

-- daily sales summary
create view vw_daily_sales_summary as
select d.date , count(distinct o.order_id) as TotalOrders,
	   sum(o.quantity) as TotalQuantity, sum(o.amount) TotalSales
from dbo.orders_fact o
join date_dim d on d.date_id = o.date_id
group by d.date;
Go


--products summary
create view vw_top_products as
select p.category, sum(o.quantity) as TotalQuantity, sum(o.amount) as TotalRevenue
from product_dim p
join orders_fact o on o.product_id = p.product_id
group by p.product_id, p.category;
Go

-- sales by state and city
create view vw_sales_by_state as
select l.ship_state, l.ship_city,
	   count(distinct o.order_id) as TotalOrders,sum(o.amount) as TotalSales
from location_dim l 
join orders_fact o on o.ship_state_id = l.ship_state_id
group by l.ship_state, l.ship_city;
Go

-- status summary
create view vw_order_status_summary as
select o.status, count(o.order_id) as TotalOrders, sum(o.amount) as TotalSales
from orders_fact o
group by o.status;
GO

-- sales by channel
create view vw_sales_by_channel as
select sc.sales_channel, count(distinct o.order_id) as TotalOrders,sum(o.amount) as TotalSales
from sales_channel_dim sc
join orders_fact o on o.sales_channel_id = sc.sales_channel_id
group by sc.sales_channel;
GO


-- sales by fullfilment
create view vw_sales_by_fulfilment as
select f.fulfillment, count(distinct o.order_id) as TotalOrders,sum(o.amount) as TotalSales
from fulfillment_dim f
join orders_fact o on o.fulfillment_id = f.fulfillment_id 
group by f.fulfillment;
GO
----------------------------------

SELECT * 
FROM vw_top_products
ORDER BY TotalRevenue DESC;
