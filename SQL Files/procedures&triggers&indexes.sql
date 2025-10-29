------------------ Stored Procedures -------------------
-- sales by date
create or alter procedure sp_sales_by_date_range @start_date date, @end_date date
as
Begin
select d.date,
        sum(f.amount) AS total_sales,
        count(DISTINCT f.order_id) AS total_orders
from orders_fact f
join date_dim d on f.date_id = d.date_id
where d.date between @start_date and @end_date
group by d.date
order by total_sales
End;

exec sp_sales_by_date_range '2022-04-01','2022-04-30';
Go
----------------------------

create procedure sp_sales_by_channel
as
begin
    select 
        sc.sales_channel,
        sum(f.amount) AS total_sales,
        count(DISTINCT f.order_id) AS total_orders
    from orders_fact f
    join sales_channel_dim sc ON f.sales_channel_id = sc.sales_channel_id
    group by sc.sales_channel;
end;

Exec sp_sales_by_channel
GO
------------------------------
------------------  TRIGGERS -------------------
create table orders_audit (
    audit_id int identity(1,1) primary key,
    order_id varchar(50),
    inserted_at datetime default getdate()
);
GO


create trigger trg_orders_insert on orders_fact
after insert
as
begin
    insert into orders_audit (order_id)
    select order_id 
    from inserted;  
end;
GO
--------------------------

create trigger trg_prevent_delete_orders
on orders_fact
instead of delete
as
begin
    print 'Deletion is not allowed on orders_fact!';
end;

delete from orders_fact where order_id = '171-0001409-6228339'
GO
-------------------------

------------------  INDEXES -------------------
create index idx_order_id
on orders_fact(order_id);


create index idx_date_state
on orders_fact(date_id, ship_state_id);


EXEC sp_helpindex 'orders_fact';

DROP INDEX idx_order_id ON orders_fact;

