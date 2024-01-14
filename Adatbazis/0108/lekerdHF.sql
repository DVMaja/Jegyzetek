use ajandekozas2

--1. Ki mit kedvel/nem kedvel a legjobban?

select sz.név, s.érték, sm.érték,d.elnevezés,k.mérték as kedvelés_mértéke
from kedvel as k
	inner join személy as sz on sz.azon=k.személy
	inner join termék as t on k.termék=t.tkód
	inner join dolog as d on t.dolog=d.dkód
	inner join szótár as s on t.jellemzõ=s.id
	inner join szótár as sm on t.márka=sm.id
Order by k.mérték, sz.név

--2. Kirõl nem tudni, h milyen dolgokat mennyire kedvel?

select sz.név 
from  személy as sz
	left outer join kedvel as k on sz.azon=k.személy	
where k.mérték IS NULL 

--3. Melyik termék a legnagyobb kedvenc?

Select TOP 1 t.tkód, sm.érték, sj.érték, d.elnevezés, sum(k.mérték) as ossz_pontok
from termék as t
	inner join kedvel as k on t.tkód=k.termék
	inner join dolog as d on t.dolog=d.dkód
	inner join szótár as sm on t.márka=sm.id
	inner join szótár as sj on t.jellemzõ=sj.id	
group by t.tkód, sm.érték, sj.érték, d.elnevezés 
order by sum(k.mérték) desc
  
--4. Mely dologból van a legtöbbféle termék?

select kt.dolog, MAX(ossz_termsz.mennyiség) as legtobb_termek
from termék as kt 
	inner join (
	select TOP 1 d.dkód, count(t.dolog) as mennyiség
	from dolog as d
		inner join termék as t on d.dkód=t.dolog
	group by d.dkód
	order by count(t.dolog) desc
) as ossz_termsz on kt.dolog=ossz_termsz.dkód	
group by kt.dolog
	
--5. Hány barátom szereti a csokit?

select count(*) as ennyien_szeretik_aCsokit from kedvel as k
	inner join személy as sz on k.személy=sz.azon
	inner join termék as t on k.termék=t.tkód
	inner join dolog as d on t.dolog=d.dkód
	inner join szótár as szo on szo.id=sz.viszony
	where d.elnevezés like('csokoládé') and szo.érték like('barát')

--6. Kik nem kedvelnek semmiféle italt?
Select sze.név as nem_kedvelik from kedvel as k 
	inner join termék as t on k.termék=t.tkód
	inner join dolog as d on t.dolog=d.dkód
	inner join személy as sze on sze.azon=k.személy
	where d.elnevezés like('ital') and k.mérték=1

--7. Ki nem kedvel semmilyen sört és semmilyen bort?

Select sze.név as nem_kedvelik from kedvel as k 
	inner join termék as t on k.termék=t.tkód
	inner join dolog as d on t.dolog=d.dkód
	inner join személy as sze on sze.azon=k.személy
	where (d.elnevezés like('sör') and d.elnevezés like('bor')) and k.mérték=1