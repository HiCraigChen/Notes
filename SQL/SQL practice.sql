select first,age
from empinfo

select first, last, city
from empinfo
where city <> 'Payson'


select * from empinfo
where age > 40


select first, last
from empinfo
where last like '%ay'

select * from empinfo
where first = 'Mary'

select * from empinfo
where first like '%Mary%'

create table employees
(first varchar(15),
last varchar(20),
title varchar(30),
age number(3),
salary number(10));



select MAX(price)
from items_ordered;

select avg(price)
from items_ordered
where order_date like '%Dec%';

select count(*)
from items_ordered;

select count(*)
from items_ordered
where item = ‘Tent’;


select state, count(*)
from customers
group by state;
OR
SELECT state, count(state)
FROM customers
GROUP BY state;

select max(price),min(price),item
from items_ordered
group by item;

select customerid, count(customerid), SUM(price)
from items_ordered 
group by customerid;

select state, count(state)
from customers
group by state
having count(state)>1;



select item, max(price),min(price)
from items_ordered
group by item
having max(price)>190;

select customerid, count(customerid), sum(price)
from items_ordered
group by customerid
having count(customerid)>1;


-- Order by
select lastname, firstname, city
from customers
order by lastname ASC;

select lastname, firstname, city
from customers
order by lastname DESC;

select item, price
from items_ordered
where price > 10
order by price ASC;


select customerid, order_date, item
from items_ordered 
where item <> 'Snow Shoes' and item <> ' Ear Muffs';

select item, price 
from items_ordered 
WHERE (item LIKE 'S%') OR (item LIKE 'P%') OR (item LIKE 'F%');



-- In & between
select order_date, item, price 
from items_ordered
where price between 10.00 and 80.00;


select firstname, city, state
from customers
where state in ('Arizona', 'Washington', 'Oklahoma', 'Colorado', 'Hawaii');

-- Operation
select item, price/quantity
from items_ordered;
