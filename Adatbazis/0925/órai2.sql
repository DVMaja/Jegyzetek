use Term�k�rak
select *from term�k

select * from �r0

select term�k, dt�l, dig, �r 
from �r0
--where term�k=101 and '20200405 between dt�l and dig --nullal nincs �sszehasonl�t�s
where term�k=101 
and dt�l<='20200405' and isnull(dig, getdate())>='20200505'
--101-es 2020 m�jus 5-�n mennyibe ker�lt

--aj�nlott:
create view w_n�zet1
as
select term�k, dt�l, isnull(dig, getdate()) as ig, �r
from �r0
select * from w_n�zet1 -- a neve minden n�zet, ill t�bla nev�t�l k�l�nb�zik

select * 
from w_n�zet1
where term�k=101 and '20200505' between dt�l and ig

--T�rol�sra nem javsolt az Ar0

select * from �r
--dig nincs de a id�szakok s�vosak

create view v_n�zet2
as
select term�k ,
		dt�l
		,(select dateadd(day,-1, MIN(dt�l)) from �R where term�k=K.term�k and dt�l > K.dt�l) as dig
		,�j_�r
from �R K
--k�t d�tum k�l�nbs�ge 

--select cast(getdate() as date), Dateadd(day, 1, getdate())

--csak a v�ltoz�sok vannak elt�rolva,, de az akt_�r ott legyen a term�kben
select * from term�k
select * from v�lt

-- a V�LTb�l egy teljes �rlista
select	term�k, 
		(select isnull(dateadd(day, +1,MAX(dig)), cast('2020-01-02'as date)) from v�lt where term�k=K.term�k and dig<K.dig ) as dt�l,	
		dig,
		r�gi_�r as �r
from V�LT K
UNION
select tk�d, cast('2020-01-02'as date), cast(getdate() as date), akt_�r
from term�k
where tk�d NOT IN (select term�k from v�lt)
UNION
select tk�d, (select dateadd(day,+1,max(dig)) from v�lt where term�k=tk�d), cast(getdate() as date), akt_�r
from term�k
where  tk�d IN (select term�k from v�lt)









select * from v�lt 

--101 es term�knek a nyit� �ta mikor nincs �ra, vagy mikor van t�bb �ra
--minden nap legyen �ra, �s csak 1 �ra legyen

