create database proba
use proba
create table AR0
(
tkod int,
dtol date,
dig date,
ar money,
--, 
primary key(tkod, dtol)

)

insert into AR0 values(101, '20230401', null, 22500)
insert into AR0 values(102, '20230401', null, 42500)
insert into AR0 values(103, '20230401', null, 15500)
insert into AR0 values(104, '20230401', null, 7000)

select * from AR0



create table AR(
tkod int,
dtol date,
--dig date,
ar money,
primary key(tkod, dtol)
)

insert into ar
select tkod, dtol, ar from ar0

select * from ar
--egy webprogramozó hogy keresi mi  ebbõl hogy adott termék adott napon mennyibe kerül

select 
	tkod
	, dtol
	, isnull((select dateadd(day,-1, MIN(dtol)) from ar where tkod=K.tkod and dtol> K.dtol), getdate())as dig
	, ar
from ar K

--select getdate(), isnull(null, 'nincs adat')
--nézetként elmentjük az értékes lekérdezésünket
go 

create view arlista as
select 
	tkod
	, dtol
	, isnull((select dateadd(day,-1, MIN(dtol)) from ar where tkod=K.tkod and dtol> K.dtol), getdate())as dig
	, ar
from ar K