------K�rd�sre kell v�laszolni
--1 lek
--felt�ve ha arr�l az ember�l besz�lek aki
--sz�raz pezsg�
--linddel fekete csoki
--mercy �tcsoki
--nincs �rtelme egym�s mell� massz�rozni
--k�ls� param�teres lek�rdez�s
--ha csak egy adat van, akkor az 5 �s lesz a legkedveltebb �s a legkev�sb� kedvelt term�k is
--UNIoN jobb mert ott van mindenhol is

--2
-- az outer joinos a 2A saj�t megold
--neml�ttam hogy mit mennyire kedvel
--2B cross join, ami benne van a kedvelbe azt ki kell hagyni
--a kiindul� t�bla d�k�rt szorzata 
--b�rki b�rmit kedvelhet --> cross join, nincs felt�tel
--d�k�rt szorzat Rendben van lehet haszn�lni
--PL ki mit nem tan�t, ki mit nem rendelt

--3. Melyik term�k a legnagyobb kedvenc
--TOP 1 WITH TIES --holtverseny

--4
--f� t�bl�b�l kell kezdeni
-- ha bels�be gyoup by van akkor k�v�lre nem kell
--alszelect
--TOP 1 WITH TIEs
Select TOP 1 WITH TIEs dolog, count(*) as mennyis�g
from term�k
group by dolog
order by COUNT(*) desc


--5 a k�l�nb�z� szem�lyeket kell megsz�ml�lni mert egy szem�ly t�bbsz�r is lehet a kevdvelben
--H�ny Bar�tom szereti a csokit
--mindenki max 1 szer legyen benne
select count(distinct szem�ly) as ennyien_szeretik_aCsokit
from kedvel as k
  inner join szem�ly as sz on k.szem�ly=sz.azon
  inner join term�k as t on k.term�k=t.tk�d
  inner join dolog as d on t.dolog=d.dk�d
  inner join sz�t�r as visz on visz.id=sz.viszony
where d.elnevez�s like('csok%') and visz.�rt�k like('bar�t%') and k.m�rt�k>3


--6. Kik nem kedvelnek semmif�le italt?
------------------------------------------
--6A ki nmilyen italt nem kedvel--nem az eredeti k�rd�sre v�laszol
Select *--sze.n�v as nem_kedvelik 
from kedvel as k
  inner join term�k as t on k.term�k=t.tk�d
  inner join dolog as d on t.dolog=d.dk�d
  inner join sz�t�r bes on bes.id=d.besorol�s
  inner join szem�ly as sze on sze.azon=k.szem�ly
where bes.�rt�k ='ital' and k.m�rt�k<3
--csak maszkol�shoz legyen LIKE

-------------------JO megoldas
Select szem�ly--sze.n�v as nem_kedvelik 
from kedvel as k
  inner join term�k as t on k.term�k=t.tk�d
  inner join dolog as d on t.dolog=d.dk�d
  inner join sz�t�r bes on bes.id=d.besorol�s
  inner join szem�ly as sze on sze.azon=k.szem�ly
where bes.�rt�k ='ital' and k.m�rt�k<3
Except
--meg kell keresni azokat akik kedvelnek egy italt
Select szem�ly--sze.n�v as nem_kedvelik 
from kedvel as k
  inner join term�k as t on k.term�k=t.tk�d
  inner join dolog as d on t.dolog=d.dk�d
  inner join sz�t�r bes on bes.id=d.besorol�s
  --inner join szem�ly as sze on sze.azon=k.szem�ly
where bes.�rt�k ='ital' and k.m�rt�k>3
--ki az aki legal�bb egy italt nem kedvel, de nem kedvel egyyetlen italt
-- a nem kedvel�kb�l kivonjuk azokat akik legal�bb eggyet kedvelnek

--7. Ki nem kedvel semmilyen s�rt �s semmilyen bort?

Select *--sze.n�v as nem_kedvelik 
from kedvel as k
  inner join term�k as t on k.term�k=t.tk�d
  inner join dolog as d on t.dolog=d.dk�d
  inner join sz�t�r bes on bes.id=d.besorol�s
  --inner join szem�ly as sze on sze.azon=k.szem�ly
where (d.elnevez�s='s�r'or d.elnevez�s='bor') and k.m�rt�k<3

Except
Select *
from kedvel as k
  inner join term�k as t on k.term�k=t.tk�d
  inner join dolog as d on t.dolog=d.dk�d
  inner join sz�t�r bes on bes.id=d.besorol�s
  --inner join szem�ly as sze on sze.azon=k.szem�ly
where (d.elnevez�s='s�r'or d.elnevez�s='bor') and k.m�rt�k>3

--M�sisik verzi�
Select *--sze.n�v as nem_kedvelik 
from kedvel as k
  inner join term�k as t on k.term�k=t.tk�d
  inner join dolog as d on t.dolog=d.dk�d
  inner join sz�t�r bes on bes.id=d.besorol�s
  --inner join szem�ly as sze on sze.azon=k.szem�ly
where (d.elnevez�s='s�r'or d.elnevez�s='bor') and k.m�rt�k<3
and szem�ly not in(
Select *
from kedvel as k
  inner join term�k as t on k.term�k=t.tk�d
  inner join dolog as d on t.dolog=d.dk�d
  inner join sz�t�r bes on bes.id=d.besorol�s
  --inner join szem�ly as sze on sze.azon=k.szem�ly
where (d.elnevez�s='s�r'or d.elnevez�s='bor') and k.m�rt�k>3
)




--Aj�nd�kok bedobozol�sa, �s  hogy ki/kik adt�k
--aj�nd�kot felvinni
--feladni, kapni
--Pszeudo k�d ---Wirth

 
--MINtAsorok az aj�nd�koz�sban
--az ital, �dess�g, a  sz�t�rba megy besorol�shoz
--ir�ny adja meg hogy adom avgy kapom
--lek�rdez�sek:
	--ki az a szerencs�s aki csupa olyan aj�nd�kot kapott amit kedvel
	--legutols� karira mit kaptam sz�leimt�l
	--a legels� aj�nd�kom sz�leimt�l
	--mi az a z aj�nd�k amib�l t�bbet adtam mint kaptam

--melyik az a term�k amib�l t�bbet adtam mint kaptam

select * from aj�nd�k
select * from aj�nd�koz�s


--valami fura
Select k.term�k, ISNULL(a.h�nyat, 0) as adtam, ISNULL(k.h�nyat, 0) as kaptam
from (
	select term�k,  SUM(h�ny) as h�nyat
	from aj�nd�k
	where ir�ny ='A'
	group by term�k
) a
	full outer join
	(	
		select term�k,SUM(h�ny) as h�nyat
		from aj�nd�k
		where ir�ny ='K'
		group by term�k
	) k
	on a.term�k=k.term�k
	where ISNULL(a.h�nyat, 0)< ISNULL(k.h�nyat, 0)