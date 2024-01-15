use ajandekozas2

--1. Ki mit kedvel/nem kedvel a legjobban?
-- ez nem arra v�laszol
select sz.n�v, s.�rt�k, sm.�rt�k,d.elnevez�s,k.m�rt�k as kedvel�s_m�rt�ke
from kedvel as k
  inner join szem�ly as sz on sz.azon=k.szem�ly
  inner join term�k as t on k.term�k=t.tk�d
  inner join dolog as d on t.dolog=d.dk�d
  inner join sz�t�r as s on t.jellemz�=s.id
  inner join sz�t�r as sm on t.m�rka=sm.id
  
Order by k.m�rt�k, sz.n�v

go
create view lek1
as
-- Egym�s al� ker�lnek a term�kek 
select szem�ly, term�k, 'legink�bb' as megjegyz
from kedvel k
where m�rt�k = (Select Max(m�rt�k) from kedvel where k.szem�ly = szem�ly)
UNION
select szem�ly, term�k, 'legkevesb�'  
from kedvel k
where m�rt�k = (Select Min(m�rt�k) from kedvel where k.szem�ly = szem�ly)
go
--Egym�s mell� ker�lnek a term�kek
--Andr�s megold�sa


go
create view lek2A
as
--2. Kir�l nem tudni, h milyen dolgokat mennyire kedvel?
--2A kir�l nem tudni semmit, hogy mit mennyire kedvel
Select * 
from szem�ly s
where not exists (Select 1 from kedvel where s.azon= kedvel.szem�ly)
--outer join erre j�, de az a B lesz
go
create view lek2B
as
--2B KIr�l nem tudni hogy milyen term�keket mennyire kedvel
Select azon, tk�d
from szem�ly, term�k
Except
select szem�ly, term�k
from kedvel

go

select * from szem�ly
select * from dolog
create view lek2
as
--2. Kir�l nem tudni, h milyen dolgokat mennyire kedvel?
Select azon, dk�d
from szem�ly, dolog
Except
select szem�ly, t.dolog
from kedvel
inner join term�k t on t.tk�d=kedvel.term�k
go

go
create view lek3
as
--3. Melyik term�k a legnagyobb kedvenc?
--nevek luxusb�l vannak benne
Select TOP 1 with ties  t.tk�d, sm.�rt�k as M�rka, sj.�rt�k as jellemz�, d.elnevez�s
, avg(k.m�rt�k* 1.00) as ossz_pontok
from kedvel as k
  inner join term�k as t on t.tk�d=k.term�k
  inner join dolog as d on t.dolog=d.dk�d
  inner join sz�t�r as sm on t.m�rka=sm.id
  inner join sz�t�r as sj on t.jellemz�=sj.id
group by t.tk�d, sm.�rt�k, sj.�rt�k, d.elnevez�s
order by ossz_pontok desc
go
create view lek4 as
--4. Mely dologb�l van a legt�bbf�le term�k?
select TOP 1 with ties dolog, count(*) as mennyis�g
     from term�k
      group by dolog
order by count(*) desc

go
create view lek5 as
--5. H�ny bar�tom szereti a csokit?
-- de mindenki 1x legyen benne!
select count(distinct szem�ly) as ennyien_szeretik_aCsokit 
from kedvel as k
  inner join szem�ly as sz on k.szem�ly=sz.azon
  inner join sz�t�r as viszony on viszony.id=sz.viszony
  inner join term�k as t on k.term�k=t.tk�d
  inner join dolog as d on t.dolog=d.dk�d
where d.elnevez�s like('csok%') and viszony.�rt�k like('bar�t%') and m�rt�k>3

--6. Kik nem kedvelnek semmif�le italt?
-- ez m�s
-- 6a) kik milyen italt nem kedvel?
Select * -- sze.n�v as nem_kedvelik 
from kedvel k
  inner join term�k t on k.term�k=t.tk�d
  inner join dolog d on t.dolog=d.dk�d
  inner join sz�t�r besor on besor.id=d.besorol�s
  inner join szem�ly sze on sze.azon=k.szem�ly
  where besor.�rt�k = 'ital' and k.m�rt�k<3
go

alter view lek6 as
--6. Kik nem kedvelnek semmif�le italt?
Select szem�ly 
from kedvel k
  inner join term�k t on k.term�k=t.tk�d
  inner join dolog d on t.dolog=d.dk�d
  inner join sz�t�r besor on besor.id=d.besorol�s
  --inner join szem�ly sze on sze.azon=k.szem�ly
  where besor.�rt�k = 'ital' and k.m�rt�k<3
except
Select szem�ly 
from kedvel k
  inner join term�k t on k.term�k=t.tk�d
  inner join dolog d on t.dolog=d.dk�d
  inner join sz�t�r besor on besor.id=d.besorol�s
  --inner join szem�ly sze on sze.azon=k.szem�ly
  where besor.�rt�k = 'ital' and k.m�rt�k>3
go



--7. Ki nem kedvel semmilyen s�rt �s semmilyen bort?
create view lek7 as
--6. Kik nem kedvelnek semmif�le italt?
Select szem�ly 
from kedvel k
  inner join term�k t on k.term�k=t.tk�d
  inner join dolog d on t.dolog=d.dk�d
  where (d.elnevez�s = 's�r' or d.elnevez�s = 'bor') and k.m�rt�k<3 
  and szem�ly not in
  (
Select szem�ly 
from kedvel k
  inner join term�k t on k.term�k=t.tk�d
  inner join dolog d on t.dolog=d.dk�d
  where (d.elnevez�s = 's�r' or d.elnevez�s = 'bor') and k.m�rt�k>3 )
go













