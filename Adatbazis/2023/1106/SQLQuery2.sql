
use ugyfelszolg
--f�ggv�ny
--1 Adott cikkb�l h�ny visszafizet�s lehets�ges m�ig?
Create function

Select 
From VISSZAFIZ v
		inner join CSERE c on c.cikksz�m=v.cikksz�m and c.�j_gy�rtsz=v.�j_gy�rtsz
		inner join TERM�K t on t.cikksz�m=c.cikksz�m and t.gy�rtsz=c.gy�rtsz
		inner join CIKK ci on ci.cikksz�m=t.cikksz�m

	


--2 H�ny cser�be adott k�v�f�z�b�l h�nyat hoztak vissza?
--k�v�fozo
go
Create view visszahozott_k�v�f�z�k
as
 Select * 
 from CSERE cs
	inner join TERM�K t on t.cikksz�m=cs.cikksz�m and t.gy�rtsz=cs.gy�rtsz
	inner join CIKK c on c.cikksz�m=t.cikksz�m
 where c.megnev like (%'k�v�fozo'%)






-- 3. Mekkora �rbev�tel volt elad�sokb�l ebben a h�napban?
Go
create view novemberi_bevetel
as 
Select Month(kelt) as aktu�lis_h�nap, SUM(�r)
From ELAD�S
where MONTH(kelt)=11
Group by Month(kelt)