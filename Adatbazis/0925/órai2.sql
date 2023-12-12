use Termékárak
select *from termék

select * from ár0

select termék, dtól, dig, ár 
from ár0
--where termék=101 and '20200405 between dtól and dig --nullal nincs összehasonlítás
where termék=101 
and dtól<='20200405' and isnull(dig, getdate())>='20200505'
--101-es 2020 május 5-én mennyibe került

--ajánlott:
create view w_nézet1
as
select termék, dtól, isnull(dig, getdate()) as ig, ár
from ár0
select * from w_nézet1 -- a neve minden nézet, ill tábla nevétõl különbözik

select * 
from w_nézet1
where termék=101 and '20200505' between dtól and ig

--Tárolásra nem javsolt az Ar0

select * from ár
--dig nincs de a idõszakok sávosak

create view v_nézet2
as
select termék ,
		dtól
		,(select dateadd(day,-1, MIN(dtól)) from ÁR where termék=K.termék and dtól > K.dtól) as dig
		,új_ár
from ÁR K
--két dátum különbsége 

--select cast(getdate() as date), Dateadd(day, 1, getdate())

--csak a változások vannak eltárolva,, de az akt_ár ott legyen a termékben
select * from termék
select * from vált

-- a VÁLTból egy teljes árlista
select	termék, 
		(select isnull(dateadd(day, +1,MAX(dig)), cast('2020-01-02'as date)) from vált where termék=K.termék and dig<K.dig ) as dtól,	
		dig,
		régi_ár as ár
from VÁLT K
UNION
select tkód, cast('2020-01-02'as date), cast(getdate() as date), akt_ár
from termék
where tkód NOT IN (select termék from vált)
UNION
select tkód, (select dateadd(day,+1,max(dig)) from vált where termék=tkód), cast(getdate() as date), akt_ár
from termék
where  tkód IN (select termék from vált)









select * from vált 

--101 es terméknek a nyitá óta mikor nincs ára, vagy mikor van több ára
--minden nap legyen ára, és csak 1 ára legyen

