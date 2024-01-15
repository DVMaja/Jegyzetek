use ajandekozas2

--1. Ki mit kedvel/nem kedvel a legjobban?
-- ez nem arra válaszol
select sz.név, s.érték, sm.érték,d.elnevezés,k.mérték as kedvelés_mértéke
from kedvel as k
  inner join személy as sz on sz.azon=k.személy
  inner join termék as t on k.termék=t.tkód
  inner join dolog as d on t.dolog=d.dkód
  inner join szótár as s on t.jellemzõ=s.id
  inner join szótár as sm on t.márka=sm.id
  
Order by k.mérték, sz.név

go
create view lek1
as
-- Egymás alá kerülnek a termékek 
select személy, termék, 'leginkább' as megjegyz
from kedvel k
where mérték = (Select Max(mérték) from kedvel where k.személy = személy)
UNION
select személy, termék, 'legkevesbé'  
from kedvel k
where mérték = (Select Min(mérték) from kedvel where k.személy = személy)
go
--Egymás mellé kerülnek a termékek
--András megoldása


go
create view lek2A
as
--2. Kirõl nem tudni, h milyen dolgokat mennyire kedvel?
--2A kirõl nem tudni semmit, hogy mit mennyire kedvel
Select * 
from személy s
where not exists (Select 1 from kedvel where s.azon= kedvel.személy)
--outer join erre jó, de az a B lesz
go
create view lek2B
as
--2B KIrõl nem tudni hogy milyen termékeket mennyire kedvel
Select azon, tkód
from személy, termék
Except
select személy, termék
from kedvel

go

select * from személy
select * from dolog
create view lek2
as
--2. Kirõl nem tudni, h milyen dolgokat mennyire kedvel?
Select azon, dkód
from személy, dolog
Except
select személy, t.dolog
from kedvel
inner join termék t on t.tkód=kedvel.termék
go

go
create view lek3
as
--3. Melyik termék a legnagyobb kedvenc?
--nevek luxusból vannak benne
Select TOP 1 with ties  t.tkód, sm.érték as Márka, sj.érték as jellemzõ, d.elnevezés
, avg(k.mérték* 1.00) as ossz_pontok
from kedvel as k
  inner join termék as t on t.tkód=k.termék
  inner join dolog as d on t.dolog=d.dkód
  inner join szótár as sm on t.márka=sm.id
  inner join szótár as sj on t.jellemzõ=sj.id
group by t.tkód, sm.érték, sj.érték, d.elnevezés
order by ossz_pontok desc
go
create view lek4 as
--4. Mely dologból van a legtöbbféle termék?
select TOP 1 with ties dolog, count(*) as mennyiség
     from termék
      group by dolog
order by count(*) desc

go
create view lek5 as
--5. Hány barátom szereti a csokit?
-- de mindenki 1x legyen benne!
select count(distinct személy) as ennyien_szeretik_aCsokit 
from kedvel as k
  inner join személy as sz on k.személy=sz.azon
  inner join szótár as viszony on viszony.id=sz.viszony
  inner join termék as t on k.termék=t.tkód
  inner join dolog as d on t.dolog=d.dkód
where d.elnevezés like('csok%') and viszony.érték like('barát%') and mérték>3

--6. Kik nem kedvelnek semmiféle italt?
-- ez más
-- 6a) kik milyen italt nem kedvel?
Select * -- sze.név as nem_kedvelik 
from kedvel k
  inner join termék t on k.termék=t.tkód
  inner join dolog d on t.dolog=d.dkód
  inner join szótár besor on besor.id=d.besorolás
  inner join személy sze on sze.azon=k.személy
  where besor.érték = 'ital' and k.mérték<3
go

alter view lek6 as
--6. Kik nem kedvelnek semmiféle italt?
Select személy 
from kedvel k
  inner join termék t on k.termék=t.tkód
  inner join dolog d on t.dolog=d.dkód
  inner join szótár besor on besor.id=d.besorolás
  --inner join személy sze on sze.azon=k.személy
  where besor.érték = 'ital' and k.mérték<3
except
Select személy 
from kedvel k
  inner join termék t on k.termék=t.tkód
  inner join dolog d on t.dolog=d.dkód
  inner join szótár besor on besor.id=d.besorolás
  --inner join személy sze on sze.azon=k.személy
  where besor.érték = 'ital' and k.mérték>3
go



--7. Ki nem kedvel semmilyen sört és semmilyen bort?
create view lek7 as
--6. Kik nem kedvelnek semmiféle italt?
Select személy 
from kedvel k
  inner join termék t on k.termék=t.tkód
  inner join dolog d on t.dolog=d.dkód
  where (d.elnevezés = 'sör' or d.elnevezés = 'bor') and k.mérték<3 
  and személy not in
  (
Select személy 
from kedvel k
  inner join termék t on k.termék=t.tkód
  inner join dolog d on t.dolog=d.dkód
  where (d.elnevezés = 'sör' or d.elnevezés = 'bor') and k.mérték>3 )
go













