alter table dbo.Orders
alter column [date] date;

-- product
insert into dbo.product_dim(sku, style,category,size,asin) 
select distinct sku, style, category, size, asin 
from dbo.Orders

select * from dbo.product_dim

--location
insert into dbo.location_dim(ship_state, ship_city,ship_postal_code,ship_country) 
select distinct ship_state, ship_city,ship_postal_code,ship_country
from dbo.Orders

select * from dbo.location_dim

--sales_channel
insert into dbo.sales_channel_dim(sales_channel) 
select distinct sales_channel
from dbo.Orders

select * from dbo.sales_channel_dim


--fulfillment
insert into dbo.fulfillment_dim(fulfillment, fulfillment_by,ship_service_level,courier_status) 
select distinct fulfilment, fulfilled_by,ship_service_level,courier_status
from dbo.Orders

select * from dbo.fulfillment_dim


--date
insert into dbo.date_dim(date, day, month, quarter, year, weekday)
select distinct date, day(date),month(date), datepart(quarter,date),year(date), datepart(weekday,date)
from dbo.Orders

select * from dbo.date_dim


-- orders_fact
;WITH CleanedOrders AS (
    SELECT
        o.order_id,
        d.date_id,
        p.product_id,
        f.fulfillment_id,
        sc.sales_channel_id,
        l.ship_state_id,
        o.qty,
        o.amount,
        o.currency,
        o.status,
        ROW_NUMBER() OVER (PARTITION BY o.order_id ORDER BY o.date) AS rn
    FROM dbo.Orders o
    JOIN dbo.date_dim d ON d.date = o.date
    JOIN dbo.product_dim p ON o.sku = p.sku
    JOIN (
            SELECT fulfillment, MIN(fulfillment_id) AS fulfillment_id
            FROM dbo.fulfillment_dim
            GROUP BY fulfillment
        ) f ON f.fulfillment = o.fulfilment
    JOIN dbo.sales_channel_dim sc ON sc.sales_channel = o.sales_channel
    JOIN (
            SELECT ship_state, ship_country, MIN(ship_state_id) AS ship_state_id
            FROM dbo.location_dim
            GROUP BY ship_state, ship_country
        ) l ON l.ship_state = o.ship_state
           AND l.ship_country = o.ship_country
)
INSERT INTO dbo.orders_fact (
    order_id, date_id, product_id, fulfillment_id, sales_channel_id, ship_state_id,
    quantity, amount, currency, status
)
SELECT
    c.order_id, c.date_id, c.product_id, c.fulfillment_id, c.sales_channel_id, c.ship_state_id,
    c.qty, c.amount, c.currency, c.status
FROM CleanedOrders c
LEFT JOIN dbo.orders_fact fct ON c.order_id = fct.order_id
WHERE c.rn = 1
  AND fct.order_id IS NULL;


select * from dbo.orders_fact