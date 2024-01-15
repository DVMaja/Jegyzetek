------Kérdésre kell válaszolni
--1 lek
--feltéve ha arról az emberõl beszélek aki
--száraz pezsgõ
--linddel fekete csoki
--mercy étcsoki
--nincs értelme egymás mellé masszírozni
--külsõ paraméteres lekérdezés
--ha csak egy adat van, akkor az 5 ös lesz a legkedveltebb és a legkevésbé kedvelt termék is
--UNIoN jobb mert ott van mindenhol is

--2
-- az outer joinos a 2A saját megold
--nemláttam hogy mit mennyire kedvel
--2B cross join, ami benne van a kedvelbe azt ki kell hagyni
--a kiinduló tábla dékárt szorzata 
--bárki bármit kedvelhet --> cross join, nincs feltétel
--dékárt szorzat Rendben van lehet használni
--PL ki mit nem tanít, ki mit nem rendelt

--3. Melyik termék a legnagyobb kedvenc
--TOP 1 WITH TIES --holtverseny

--4
--fõ táblából kell kezdeni
-- ha belsõbe gyoup by van akkor kívûlre nem kell
--alszelect
--TOP 1 WITH TIEs
Select TOP 1 WITH TIEs dolog, count(*) as mennyiség
from termék
group by dolog
order by COUNT(*) desc


--5 a különbözõ személyeket kell megszámlálni mert egy személy többször is lehet a kevdvelben
--Hány Barátom szereti a csokit
--mindenki max 1 szer legyen benne
select count(distinct személy) as ennyien_szeretik_aCsokit
from kedvel as k
  inner join személy as sz on k.személy=sz.azon
  inner join termék as t on k.termék=t.tkód
  inner join dolog as d on t.dolog=d.dkód
  inner join szótár as visz on visz.id=sz.viszony
where d.elnevezés like('csok%') and visz.érték like('barát%') and k.mérték>3


--6. Kik nem kedvelnek semmiféle italt?
------------------------------------------
--6A ki nmilyen italt nem kedvel--nem az eredeti kérdésre válaszol
Select *--sze.név as nem_kedvelik 
from kedvel as k
  inner join termék as t on k.termék=t.tkód
  inner join dolog as d on t.dolog=d.dkód
  inner join szótár bes on bes.id=d.besorolás
  inner join személy as sze on sze.azon=k.személy
where bes.érték ='ital' and k.mérték<3
--csak maszkoláshoz legyen LIKE

-------------------JO megoldas
Select személy--sze.név as nem_kedvelik 
from kedvel as k
  inner join termék as t on k.termék=t.tkód
  inner join dolog as d on t.dolog=d.dkód
  inner join szótár bes on bes.id=d.besorolás
  inner join személy as sze on sze.azon=k.személy
where bes.érték ='ital' and k.mérték<3
Except
--meg kell keresni azokat akik kedvelnek egy italt
Select személy--sze.név as nem_kedvelik 
from kedvel as k
  inner join termék as t on k.termék=t.tkód
  inner join dolog as d on t.dolog=d.dkód
  inner join szótár bes on bes.id=d.besorolás
  --inner join személy as sze on sze.azon=k.személy
where bes.érték ='ital' and k.mérték>3
--ki az aki legalább egy italt nem kedvel, de nem kedvel egyyetlen italt
-- a nem kedvelõkbõl kivonjuk azokat akik legalább eggyet kedvelnek

--7. Ki nem kedvel semmilyen sört és semmilyen bort?

Select *--sze.név as nem_kedvelik 
from kedvel as k
  inner join termék as t on k.termék=t.tkód
  inner join dolog as d on t.dolog=d.dkód
  inner join szótár bes on bes.id=d.besorolás
  --inner join személy as sze on sze.azon=k.személy
where (d.elnevezés='sör'or d.elnevezés='bor') and k.mérték<3

Except
Select *
from kedvel as k
  inner join termék as t on k.termék=t.tkód
  inner join dolog as d on t.dolog=d.dkód
  inner join szótár bes on bes.id=d.besorolás
  --inner join személy as sze on sze.azon=k.személy
where (d.elnevezés='sör'or d.elnevezés='bor') and k.mérték>3

--Másisik verzió
Select *--sze.név as nem_kedvelik 
from kedvel as k
  inner join termék as t on k.termék=t.tkód
  inner join dolog as d on t.dolog=d.dkód
  inner join szótár bes on bes.id=d.besorolás
  --inner join személy as sze on sze.azon=k.személy
where (d.elnevezés='sör'or d.elnevezés='bor') and k.mérték<3
and személy not in(
Select *
from kedvel as k
  inner join termék as t on k.termék=t.tkód
  inner join dolog as d on t.dolog=d.dkód
  inner join szótár bes on bes.id=d.besorolás
  --inner join személy as sze on sze.azon=k.személy
where (d.elnevezés='sör'or d.elnevezés='bor') and k.mérték>3
)




--Ajándékok bedobozolása, és  hogy ki/kik adták
--ajándékot felvinni
--feladni, kapni
--Pszeudo kód ---Wirth

 
--MINtAsorok az ajándékozásban
--az ital, édesség, a  szótárba megy besoroláshoz
--irány adja meg hogy adom avgy kapom
--lekérdezések:
	--ki az a szerencsés aki csupa olyan ajándékot kapott amit kedvel
	--legutolsó karira mit kaptam szüleimtõl
	--a legelsõ ajándékom szüleimtõl
	--mi az a z ajándék amibõl tõbbet adtam mint kaptam

--melyik az a termék amibõl többet adtam mint kaptam

select * from ajándék
select * from ajándékozás


--valami fura
Select k.termék, ISNULL(a.hányat, 0) as adtam, ISNULL(k.hányat, 0) as kaptam
from (
	select termék,  SUM(hány) as hányat
	from ajándék
	where irány ='A'
	group by termék
) a
	full outer join
	(	
		select termék,SUM(hány) as hányat
		from ajándék
		where irány ='K'
		group by termék
	) k
	on a.termék=k.termék
	where ISNULL(a.hányat, 0)< ISNULL(k.hányat, 0)