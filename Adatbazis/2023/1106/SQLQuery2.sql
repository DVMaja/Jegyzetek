
use ugyfelszolg
--függvény
--1 Adott cikkbõl hány visszafizetés lehetséges máig?
Create function

Select 
From VISSZAFIZ v
		inner join CSERE c on c.cikkszám=v.cikkszám and c.új_gyártsz=v.új_gyártsz
		inner join TERMÉK t on t.cikkszám=c.cikkszám and t.gyártsz=c.gyártsz
		inner join CIKK ci on ci.cikkszám=t.cikkszám

	


--2 Hány cserébe adott kávéfõzõbõl hányat hoztak vissza?
--kávéfozo
go
Create view visszahozott_kávéfõzök
as
 Select * 
 from CSERE cs
	inner join TERMÉK t on t.cikkszám=cs.cikkszám and t.gyártsz=cs.gyártsz
	inner join CIKK c on c.cikkszám=t.cikkszám
 where c.megnev like (%'kávéfozo'%)






-- 3. Mekkora árbevétel volt eladásokból ebben a hónapban?
Go
create view novemberi_bevetel
as 
Select Month(kelt) as aktuális_hónap, SUM(ár)
From ELADÁS
where MONTH(kelt)=11
Group by Month(kelt)