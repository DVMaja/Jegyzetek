
-- adott k�z�piskola adott tan�vi, minden h�ten ugyanolyan �rarendj�nek nyt.
-- az oszt�lyok di�kjainak �s a tant�rgyakat tan�t� tan�rok adataival
-- a nap (1-5) �s �ra (1-8) sorsz�mozott adat! az oszt�ly 9C alak� adat
-- tant�rgy azonos�t�ja itt legyen annak r�vidneve az �vfolyammal pl. MAT7 a hetedikes matematika
-- figyelem: nincs oszt�ly, sem terem t�rzst�bla, �s nem t�rolt: mely tan�rok mely t�rgyakat tan�thatj�k
-- akt. szab�ly: a p�rhuzamos oszt�lyoknak ugyanazokat a t�rgyakat kell tan�tani az el��rt heti �rasz�mban
-- �r�k szab�ly: az �rarendi �r�k �tk�z�smentesek (az oszt�lyoknak �s a tan�roknak adott nap adott valah�nyadik tan�r�j�ban legfeljebb 1 �r�juk lehet)

create database oktat�s
go

use oktat�s

create table di�k
(
azon int identity (101,1),
oszt�ly char(2) not null,
n�v varchar(30) not null, 
primary key (azon)
)

create table tan�r
(
k�d int identity (11,1),
n�v varchar(30) not null, 
szoba smallint,
-- bel�p�s date,
primary key (k�d)
)


create table tant�rgy
(
tant char(5),
megnevez�s varchar(25) not null, 
heti_�rasz�m tinyint not null,
primary key (tant)
)

create table tan�t
(
oszt�ly char(2),
tant char(5),
k�d int,
primary key (oszt�ly, tant)
)

alter table tan�t
add foreign key (tant) references tant�rgy (tant)
alter table tan�t
add foreign key (k�d) references tan�r (k�d)



create table �rarend
(
oszt�ly char(2),
nap tinyint,
�ra tinyint,
tant char(5),
primary key (oszt�ly, nap, �ra)
)

alter table �rarend
add foreign key (oszt�ly, tant) references tan�t (oszt�ly, tant)

-- megj. a terem lehet vagy a tan�t, vagy az �rarend adata a konkr�t �gymenet szerint (ez befoly�solja, milyen egyedi kulcsok lehetnek m�g)


-- Tesztadatok 
-- (2 ill. 3 p�rhuzamos oszt�lyban 20 di�k, csak 4 tan�r, 5 tant�rgy; 
-- a p�rhuzamos oszt�lyoknak uazt tan�tj�k, de van 1 tan�ri �tk�z�s
-- az �rarendi �r�k le�temez�se nincs befejezve)
   

insert into di�k (oszt�ly, n�v) values ('2A', 'VARGA TEREZ')
insert into di�k (oszt�ly, n�v) values ('2A', 'MOLNAR GEZA')
insert into di�k (oszt�ly, n�v) values ('2B', 'BALOGH MIHALY')
insert into di�k (oszt�ly, n�v) values ('2B', 'CINEGE KATA')
insert into di�k (oszt�ly, n�v) values ('2A', 'VIDA ZSOFIA')
insert into di�k (oszt�ly, n�v) values ('1C', 'ALMASI GABOR')
insert into di�k (oszt�ly, n�v) values ('1C', 'SZABO ENDRE')
insert into di�k (oszt�ly, n�v) values ('1C', 'BAN TIBOR')
insert into di�k (oszt�ly, n�v) values ('1C', 'PEK LILLA')
insert into di�k (oszt�ly, n�v) values ('1C', 'RIGO PAL')
insert into di�k (oszt�ly, n�v) values ('1C', 'VARGA DANIEL')
insert into di�k (oszt�ly, n�v) values ('1C', 'SZABO PETER')
insert into di�k (oszt�ly, n�v) values ('1A', 'KOVACS BEA')
insert into di�k (oszt�ly, n�v) values ('1B', 'LOVAS LAJOS')
insert into di�k (oszt�ly, n�v) values ('1A', 'MAGYAR ANNA')
insert into di�k (oszt�ly, n�v) values ('1A', 'NAGY KOLOS')
insert into di�k (oszt�ly, n�v) values ('1A', 'KISS ZSOLT')
insert into di�k (oszt�ly, n�v) values ('1B', 'KIS MARIA')
insert into di�k (oszt�ly, n�v) values ('1B', 'KIS LILLA')
insert into di�k (oszt�ly, n�v) values ('1B', 'ALIG ELEK')

insert into tan�r (n�v, szoba) values ('OKOS ELEK', 101)
insert into tan�r (n�v, szoba) values ('CS�CS ILI', 101)
insert into tan�r (n�v, szoba) values ('UNDOK S�RA', 102)
insert into tan�r (n�v, szoba) values ('ZORD �D�N', 105)

insert into tant�rgy values ('MAT1', 'matematika 1', 5)
insert into tant�rgy values ('MAT2', 'matematika 2', 5)
insert into tant�rgy values ('IRO1', 'irodalom 1', 2)
insert into tant�rgy values ('FIZ2', 'fizika 2', 3)
insert into tant�rgy values ('INFO1', 'informatika 1', 2)

insert into tan�t values ('1A','INFO1', 11)
insert into tan�t values ('1B','INFO1', 11)
insert into tan�t values ('1C','INFO1', 11)
insert into tan�t values ('1A','IRO1', 12)
insert into tan�t values ('1B','IRO1', 12)
insert into tan�t values ('1C','IRO1', 13)
insert into tan�t values ('1A','MAT1', 14)
insert into tan�t values ('1B','MAT1', 14)
insert into tan�t values ('1C','MAT1', 12)
insert into tan�t values ('2A','MAT2', 14)
insert into tan�t values ('2B','MAT2', 14)
insert into tan�t values ('2A','FIZ2', 13)
insert into tan�t values ('2B','FIZ2', 14)

insert into �rarend values ('2A',1, 1, 'FIZ2')
insert into �rarend values ('2B',2, 1, 'FIZ2')
insert into �rarend values ('2A',1, 2, 'MAT2')
insert into �rarend values ('2B',2, 2, 'MAT2')
insert into �rarend values ('2A',3, 3, 'FIZ2')
insert into �rarend values ('2B',4, 3, 'FIZ2')
insert into �rarend values ('2A',3, 4, 'FIZ2')
insert into �rarend values ('2B',4, 4, 'FIZ2')
insert into �rarend values ('1A',3, 1, 'IRO1')
insert into �rarend values ('1B',4, 1, 'MAT1')
insert into �rarend values ('1B',4, 4, 'MAT1')


-- Lek�rdez�sek

-- Adott tan�r �rarendje

declare @k�d int
set @k�d=14

select * 
from �rarend r inner join tan�t t on r.oszt�ly=t.oszt�ly and r.tant=t.tant
where k�d=@k�d
order by nap, �ra

-- Az egyes t�rgyakb�l mikor van a heti legels� �ra?

select tant, nap, �ra
from �rarend k
where 10*nap+�ra = (select MIN(10*nap+�ra) from �rarend where tant=k.tant)

-- A napi legutols� tan�r�k...

select nap, max(�ra) -- mikor vannak?
from �rarend
group by nap

select nap, tant, oszt�ly -- mik azok?
from �rarend K
where �ra=(select max(�ra) from �rarend where nap=K.nap)

-- Tan�ri �tk�z�sek

SELECT k�d as tan�r, nap, �ra, count(*) AS h�ny_oszt�lyt
FROM �rarend AS r, tan�t AS t
WHERE r.oszt�ly=t.oszt�ly and r.tant=t.tant
GROUP BY k�d, nap, �ra
HAVING count(*)>1;

-- Hi�nyz� tan�r�k (mely oszt�lynak mely t�rgyb�l h�ny �ra nincs le�temezve)
	
	-- klasszikus szabv. megold�ssal:
	-- 1. l�p�sben �sszesz�moljuk, mely oszt�lynak mely t�rgyb�l mennyi �ra ban az �rarendben, hozz�t�ve, amib�l 0
	create view levan as
	SELECT oszt�ly, tant, count(*) AS le�temezve
	FROM �rarend
	GROUP BY oszt�ly, tant
	UNION
	SELECT oszt�ly, tant, 0
	from tan�t t
	-- where oszt�ly+tant not in (select  oszt�ly+tant from �rarend);
	where not exists (select  1 from �rarend where oszt�ly=t.oszt�ly and tant=t.tant);
	-- 2. l�p�sben az el�bbi E-t�bla �rasz�mait kivonjuk a megfelel� tant�rgy el��rt heti �rasz�m�b�l
	SELECT oszt�ly, t.tant, heti_�rasz�m-le�temezve as nincs
	from levan l inner join tant�rgy t on l.tant=t.tant
	where heti_�rasz�m <> le�temezve 
					-- heti_�rasz�m > le�temezve elegend� sz�r�felt�tel lenne, ha nem engedn�nk meg a t�l�temez�st
	
	-- korszer�bb megold�ssal az 1. l�p�s:
	create view levanB as
	SELECT t.oszt�ly, t.tant, count(r.oszt�ly) AS le�temezve
	FROM tan�t t left outer join �rarend r on t.oszt�ly=r.oszt�ly and t.tant=r.tant 
	GROUP BY t.oszt�ly, t.tant

	-- b�trabb megold�s �sszesen 1 l�p�sben:
	SELECT t.oszt�ly, t.tant, max(heti_�rasz�m) - count(r.oszt�ly) as nincs
	FROM (tan�t t left outer join �rarend r on t.oszt�ly=r.oszt�ly and t.tant=r.tant) inner join tant�rgy g on t.tant=g.tant
	GROUP BY t.oszt�ly, t.tant
	having max(heti_�rasz�m) > count(r.oszt�ly)


-- Kiket mire tan�t Zord �d�n?

-- ellen�rizz�k az al�bbi kiindul� t�bl�t (amely 2, egym�ssal kapcsolatban nem l�v� t�bl�b�l �p�lt): 
-- minden di�k annyiszor jelenik meg, ah�ny t�rgyat tan�tanak az oszt�ly�nak
-- ill. minden tan�t-sor annyiszor jelenik meg, ah�ny di�k j�r az akt. tan�t oszt�ly�ba
	select *
	from di�k d inner join tan�t t on d.oszt�ly=t.oszt�ly
	--order by t.oszt�ly, tant, azon
	--order by azon, tant 

select d.*, tant
from di�k d 
	inner join tan�t t on d.oszt�ly=t.oszt�ly
	inner join tan�r p on t.k�d=p.k�d
where p.n�v='Zord �d�n'
--order by d.n�v, tant

