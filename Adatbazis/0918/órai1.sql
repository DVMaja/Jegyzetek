create database proba
use proba
create table AR0 
(
tkod int,
dtol date,
dig date,
ar money,
primary key (tkod, dtol)
)
select * from ar0
insert into ar0 values (101, '20230101', null, 12500)
insert into ar0 values (201, '20230101', null, 11000)
insert into ar0 values (301, '20230101', null, 5500)

create table AR
(
tkod int,
dtol date,
-- dig date,
ar money,
primary key (tkod, dtol)
)

insert into ar
select tkod, dtol, ar from ar0 


select * from ar
-- 1 webprogramozó hogy keresi ki ebbõl: adott termék adott napon mennyibe került?

select  
	tkod
	, dtol
	, isnull((select dateadd(day,-1,MIN(dtol)) from ar where tkod=K.tkod and dtol>K.dtol),getdate()) as dig
	, ar
from ar K


-- select getdate() , isnull(null, 'nincs adat')
-- nézetként elmentjük az értékes lekérdezésünket:
go 

create view árlista as
select  
	tkod
	, dtol
	, isnull((select dateadd(day,-1,MIN(dtol)) from ar where tkod=K.tkod and dtol>K.dtol),getdate()) as dig
	, ar
from ar K


-- webprg. ezt használja:
select * from árlista


