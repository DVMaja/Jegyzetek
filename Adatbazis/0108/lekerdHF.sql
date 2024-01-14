use ajandekozas2

--1. Ki mit kedvel/nem kedvel a legjobban?

select sz.n�v, s.�rt�k, sm.�rt�k,d.elnevez�s,k.m�rt�k as kedvel�s_m�rt�ke
from kedvel as k
	inner join szem�ly as sz on sz.azon=k.szem�ly
	inner join term�k as t on k.term�k=t.tk�d
	inner join dolog as d on t.dolog=d.dk�d
	inner join sz�t�r as s on t.jellemz�=s.id
	inner join sz�t�r as sm on t.m�rka=sm.id
Order by k.m�rt�k, sz.n�v

--2. Kir�l nem tudni, h milyen dolgokat mennyire kedvel?

select sz.n�v 
from  szem�ly as sz
	left outer join kedvel as k on sz.azon=k.szem�ly	
where k.m�rt�k IS NULL 

--3. Melyik term�k a legnagyobb kedvenc?

Select TOP 1 t.tk�d, sm.�rt�k, sj.�rt�k, d.elnevez�s, sum(k.m�rt�k) as ossz_pontok
from term�k as t
	inner join kedvel as k on t.tk�d=k.term�k
	inner join dolog as d on t.dolog=d.dk�d
	inner join sz�t�r as sm on t.m�rka=sm.id
	inner join sz�t�r as sj on t.jellemz�=sj.id	
group by t.tk�d, sm.�rt�k, sj.�rt�k, d.elnevez�s 
order by sum(k.m�rt�k) desc
  
--4. Mely dologb�l van a legt�bbf�le term�k?

select kt.dolog, MAX(ossz_termsz.mennyis�g) as legtobb_termek
from term�k as kt 
	inner join (
	select TOP 1 d.dk�d, count(t.dolog) as mennyis�g
	from dolog as d
		inner join term�k as t on d.dk�d=t.dolog
	group by d.dk�d
	order by count(t.dolog) desc
) as ossz_termsz on kt.dolog=ossz_termsz.dk�d	
group by kt.dolog
	
--5. H�ny bar�tom szereti a csokit?

select count(*) as ennyien_szeretik_aCsokit from kedvel as k
	inner join szem�ly as sz on k.szem�ly=sz.azon
	inner join term�k as t on k.term�k=t.tk�d
	inner join dolog as d on t.dolog=d.dk�d
	inner join sz�t�r as szo on szo.id=sz.viszony
	where d.elnevez�s like('csokol�d�') and szo.�rt�k like('bar�t')

--6. Kik nem kedvelnek semmif�le italt?
Select sze.n�v as nem_kedvelik from kedvel as k 
	inner join term�k as t on k.term�k=t.tk�d
	inner join dolog as d on t.dolog=d.dk�d
	inner join szem�ly as sze on sze.azon=k.szem�ly
	where d.elnevez�s like('ital') and k.m�rt�k=1

--7. Ki nem kedvel semmilyen s�rt �s semmilyen bort?

Select sze.n�v as nem_kedvelik from kedvel as k 
	inner join term�k as t on k.term�k=t.tk�d
	inner join dolog as d on t.dolog=d.dk�d
	inner join szem�ly as sze on sze.azon=k.szem�ly
	where (d.elnevez�s like('s�r') and d.elnevez�s like('bor')) and k.m�rt�k=1