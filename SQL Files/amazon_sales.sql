use amazon_sales;
select * from dbo.Orders

select count(*) as TotalRows
from dbo.orders

select count(*) as TotalColumns
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'Orders'


select distinct status from Orders;
select distinct fulfilment from Orders;
select distinct sales_channel from Orders;
select distinct ship_country from Orders;


select 
    SUM(amount) AS total_sales,
    AVG(amount) AS avg_sales,
    MAX(amount) AS max_sale,
    MIN(amount) AS min_sale,
    SUM(qty) AS total_qty
from dbo.Orders;


select ship_state, count(*) as TotalOrders, SUM(amount) as TotalSales
from dbo.orders
group by ship_state
order by TotalSales DESC


select ship_city, count(*) as TotalOrders, SUM(amount) as TotalSales
from dbo.orders
group by ship_city
order by TotalSales DESC


-- top products
select sku, category, style, SUM(qty) as TotalQuantity, SUM(amount) as TotalSales
from dbo.Orders
group by sku, category, style
order by TotalSales DESC

-- top Category
select category, SUM(qty) as TotalQuantity, SUM(amount) as TotalSales
from dbo.Orders
group by category
order by TotalSales DESC

delete from dbo.Orders where qty = 0

