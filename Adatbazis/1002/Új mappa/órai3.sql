select * from term�k
select * from �r0

go

drop view �rlista0
go 
create view �rlista0
as
select term�k, dt�l as t�l, isnull(dig, getdate()) as ig, �r from �r0

go
select * from �rlista0
-- pl. ebben m�r tud keresni:
select �r
from �rlista0
where term�k=101 and t�l<='20221205' and ig>='20221205'

-- t�rol�sra alkalmas verzi�:

select * from �r
drop view �rlista1
go
create view �rlista1 
as
select term�k
	, dt�l
	, isnull((select dateadd(day,-1, min(dt�l)) from �r where term�k=K.term�k and dt�l>k.dt�l),getdate()) as dig
	, �j_�r 
from �r K
--
select * from �rlista1


select * from term�k
select * from v�lt

go

create view [dbo].[�rlista2]
as
-- a V�LTb�l egy teljes �rlista

select	term�k, 
		(select isnull(dateadd(day, +1,MAX(dig)), '20200102') from v�lt where term�k=K.term�k and dig<K.dig ) as dt�l,	
		dig,
		r�gi_�r as �r
from V�LT K
UNION
select tk�d, '20200102', cast(getdate() as date), akt_�r
from term�k
where tk�d NOT IN (select term�k from v�lt)
UNION
select tk�d, (select dateadd(day,+1,max(dig)) from v�lt where term�k=tk�d), cast(getdate() as date), akt_�r
from term�k
where  tk�d IN (select term�k from v�lt)


go

select * from �rlista2
go


create view v�ltoz�sok
as
select term�k, count(*) as ennyiszer --kell oszlopnevet adni minden kif-nek
from �r
group by term�k

go


select * from v�ltoz�sok -- egyedi nev�

-------------
use oktat�s
--- oktat�s ab. szkriptje futtatva
create table terem
(
	tsz�m int,
	h�ny_f�s tinyint,
	primary key (tsz�m)
)

alter table �rarend
add terem tinyint
-- nem j� a t�pusa:

alter table �rarend
alter column terem int

alter table �rarend
add foreign key (terem) references Terem (tsz�m)

-- az oszt�ly se �tk�zz�n adott nap adott �r�j�ban (PK)
-- a terem+nap+�ra legyen UK -- vajon lehet_e a terem null?
-- a tan�r se �tk�zz�n! ld. tavalyi lek�rdez�s az ellen�rz�shez
