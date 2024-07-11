create table location(locid integer primary key, city char(20),state char(20));
insert into location values(1,'DumDum','West Bengal');
insert into location values(2,'Mumbai','Maharashtra');
insert into location values(3,'Birati','West Bengal');
insert into location values(4,'Bangaluru','Karnataka');
insert into location values(5,'Pune','Maharashtra');
select * from location;

create table product(pid integer primary key, pname char(20),ptype char(20));
insert into product values(1,'Phone','Electronics');
insert into product values(2,'Refrigerator','Electronics');
insert into product values(3,'Apple','Fruits');
insert into product values(4,'Shirt','Clothings');
insert into product values(5,'Cheese','Dairy');
select * from product;

create table dateid(did integer primary key,day char(15), month char(30), year integer);
insert into dateid values(1,'Monday','January',2018);
insert into dateid values(2,'Tuesday','January',2019);
insert into dateid values(3,'Sunday','February',2020);
insert into dateid values(4,'Wednesday','February',2021);
insert into dateid values(5,'Friday','March',2022);
select * from dateid;

create table sales(saleid integer primary key,locid integer, pid integer, did integer, units integer, price integer, foreign key(locid) references location(locid), foreign key(pid) references product(pid), foreign key(did) references dateid(did));

insert into sales values(1,1,1,1,1,10000);
insert into sales values(2,1,1,2,1,30000);
insert into sales values(3,1,1,3,4,8000);
insert into sales values(4,1,1,4,3,90000);
insert into sales values(5,1,1,5,10,100000);

insert into sales values(6,1,2,1,8,90000);
insert into sales values(7,1,2,2,4,40000);
insert into sales values(8,1,2,3,7,56000);
insert into sales values(9,1,2,4,6,85000);
insert into sales values(10,1,2,5,15,90000);

insert into sales values(11,1,3,1,5,87000);
insert into sales values(12,1,3,2,10,98000);
insert into sales values(13,1,3,3,12,4560);
insert into sales values(14,1,3,4,17,98700);
insert into sales values(15,1,3,5,14,17000);

insert into sales values(16,1,4,1,4,19000);
insert into sales values(17,1,4,2,2,14000);
insert into sales values(18,1,4,3,8,68000);
insert into sales values(19,1,4,4,5,67000);
insert into sales values(20,1,4,5,12,91000);

insert into sales values(21,1,5,1,1,10000);
insert into sales values(22,1,5,2,6,87000);
insert into sales values(23,1,5,3,9,79000);
insert into sales values(24,1,5,4,5,77000);
insert into sales values(25,1,5,5,2,8000);

insert into sales values(26,2,1,1,1,1000);
insert into sales values(27,2,1,2,5,700);
insert into sales values(28,2,1,3,8,90000);
insert into sales values(29,2,1,4,4,78000);
insert into sales values(30,2,1,5,2,25000);

insert into sales values(31,2,2,1,1,17000);
insert into sales values(32,2,2,2,6,15000);
insert into sales values(33,2,2,3,6,8000);
insert into sales values(34,2,2,4,7,9000); 
insert into sales values(35,2,2,5,5,7000);

insert into sales values(36,2,3,1,9,11000);
insert into sales values(37,2,3,2,5,44000);
insert into sales values(38,2,3,3,7,3000);
insert into sales values(39,2,3,4,2,1000);
insert into sales values(40,2,3,5,9,8000);

insert into sales values(41,2,4,1,6,7000);
insert into sales values(42,2,4,2,9,90000);
insert into sales values(43,2,4,3,7,45000);
insert into sales values(44,2,4,4,4,56800);
insert into sales values(45,2,4,5,9,98700);

insert into sales values(46,2,5,1,8,67900);
insert into sales values(47,2,5,2,2,7890);
insert into sales values(48,2,5,3,4,87400);
insert into sales values(49,2,5,4,3,65300);
insert into sales values(50,2,5,5,5,59400);

insert into sales(saleid,locid,pid,did) values(51,3,1,1);
update sales set units=10 where saleid=51;
update sales set price=5230 where saleid=51;

insert into sales(saleid,locid,pid,did) values(52,3,1,2);
update sales set units=14 where saleid=52;
update sales set price=1423 where saleid=52;

insert into sales(saleid,locid,pid,did) values(53,3,1,3);
update sales set units=8 where saleid=53;
update sales set price=8630 where saleid=53;

insert into sales(saleid,locid,pid,did) values(54,3,1,4);
update sales set units=6 where saleid=54;
update sales set price=6060 where saleid=54;

insert into sales(saleid,locid,pid,did) values(55,3,1,5);
update sales set units=18 where saleid=55;
update sales set price=29 where saleid=55;

insert into sales values(56,4,1,1,9,8888);
insert into sales values(57,4,1,1,10,8275);
insert into sales values(58,4,1,1,11,18767);
insert into sales values(59,4,1,1,5,56888);
insert into sales values(60,4,1,1,2,88588);


select * from sales;

--23_02_24
--1.clean the data by average value in data warehouse where the amount is null
update sales set price=(select avg(price) from sales where price is not null) where price is null;
--2.remove the inconsistency in data due to redundancy by the MAXIMUM Value of amount
DELETE FROM sales WHERE (locid, pid, did, price) NOT IN (SELECT locid, pid, did, MAX(price) FROM sales GROUP BY locid, pid, did);

--01_03_24
--rollup year
SELECT d.year,SUM(s.units),SUM(s.price) FROM sales s JOIN dateid d ON s.did = d.did GROUP BY ROLLUP (d.year);

-- SELECT d.year,SUM(price) FROM sales s,dateid d where s.did = d.did GROUP BY year;

--rollup state wise
-- SELECT l.state AS State,d.year AS Year,SUM(s.units * s.price) AS TotalSales FROM sales s JOIN location l ON s.locid = l.locid JOIN dateid d ON s.did = d.did GROUP BY ROLLUP (l.state, d.year);

SELECT l.state,SUM(s.units * s.price) AS TotalSales FROM sales s JOIN location l ON s.locid = l.locid JOIN dateid d ON s.did = d.did GROUP BY ROLLUP (l.state);

--slice detail of state where loc=KOLKATA
SELECT s.saleid,p.pname AS ProductName,d.day AS Day,d.month AS Month,d.year AS Year,s.units AS UnitsSold,s.price AS Price FROM sales s JOIN location l ON s.locid = l.locid JOIN product p ON s.pid = p.pid JOIN dateid d ON s.did = d.did WHERE l.city = 'Dumdum';

-- SELECT s.saleid,p.pname AS ProductName,d.day AS Day,d.month AS Month,d.year AS Year,s.units AS UnitsSold,s.price AS Price FROM sales s JOIN location l ON s.locid = l.locid JOIN product p ON s.pid = p.pid JOIN dateid d ON s.did = d.did WHERE l.city = 'DumDum';

-- SELECT s.saleid,l.city,p.name,d.day,d.month,d.year,s.units,s.price FROM sales s JOIN location l ON s.locid = l.locid JOIN product p ON s.pid = p.pid JOIN dateid d ON s.did = d.did WHERE l.city = 'DumDum'

--dice detail of state where loc=DumDum
SELECT saleid,locid, pid, did, units, price FROM sales WHERE locid = (SELECT locid FROM location WHERE city = 'DumDum');

SELECT * FROM sales WHERE locid = (SELECT locid FROM location WHERE city = 'DumDum');

--dice detail of state where prod=ELECTRONICS
SELECT * FROM sales WHERE pid IN (SELECT pid FROM product WHERE ptype = 'Electronics');




--best one
--rollup year
SELECT d.year,SUM(s.units),SUM(s.price) FROM sales s JOIN dateid d ON s.did = d.did GROUP BY ROLLUP (d.year);

--rollup state
SELECT l.state,SUM(s.units * s.price) AS TotalSales FROM sales s JOIN location l ON s.locid = l.locid JOIN dateid d ON s.did = d.did GROUP BY ROLLUP (l.state);

--slice loc-dumdum
SELECT s.saleid,l.city,p.pname,d.day,d.month,d.year,s.units,s.price FROM sales s JOIN location l ON s.locid = l.locid JOIN product p ON s.pid = p.pid JOIN dateid d ON s.did = d.did WHERE l.city = 'DumDum';

--dice prod-Electronics
SELECT * FROM sales WHERE pid IN (SELECT pid FROM product WHERE ptype = 'Electronics');



--drop table location;
--drop table product;
--drop table dateid;
--drop table sales;

