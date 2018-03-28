/* Type of SQL : Oracle */

-- List the Sales Outlet Names and their Total Revenue for 2015 and 2016. 
-- Show the revenue in US Dollars. The header for the total revenue should be REVENUE.
select sales_outlet.sales_outlet_name, to_char(sum(sales.sales_revenue), 'L999,999,999.00' ) as REVENUE
from Sales
left join Sales_Outlet on sales.sales_outlet_Id = sales_outlet.sales_outlet_Id
where sales.sales_year = 2015 or sales.sales_year = 2016
group by sales_outlet.sales_outlet_name


-- For the year 2015, list the Quantity of Bikes sold by each Sales Outlet. 
-- The header for the Sales Outlet name would be “Outlet Name” and the Sales Quantity should be marked as “Quantity Sold”.
select sales_outlet.sales_outlet_name as "Outlet Name", sum(Sales.sales_quantity) as "Quantity Sold"
from sales
Left join product on product.product_id = sales.product_id
Left join Sales_outlet on Sales.Sales_outlet_id = Sales_outlet.Sales_outlet_id
where UPPER(product.product_name) like '%BIKE%' and sales.sales_year = 2015
group by Sales_outlet.sales_outlet_name


-- List all the tables in your database
SELECT table_name FROM user_tables;