-- adott sz�lloda t�pusba sorolt szob�it lehet min. 1 �jszak�ra lefoglalni
-- a lefoglalt szob�kat a bek�lt�z�sig ki is kell fizetni a megrendel� �gyf�lnek (a szoba teljes �ra 1 �jszak�ra �rtend�) 
-- a lefoglalt szob�ba korl�tozott sz�mban bek�lt�z� vend�gek is �gyfelek 
-- megj. ebben a verzi�ban nincs lemond�s

create database sz�lloda
go

use sz�lloda

create table szobatipus
(
sztip char(1),
�r money not null,
�gy tinyint not null,
primary key (sztip)
)
insert into szobatipus values ('A', 12500, 2)
insert into szobatipus values ('B', 8000, 2)
insert into szobatipus values ('C', 12000, 3)

create table szoba
(
szsz�m smallint,
sztip char(1) not null,
primary key (szsz�m),
foreign key (sztip) references szobatipus (sztip)
)
insert into szoba values (101, 'A')
insert into szoba values (201, 'A')
insert into szoba values (105, 'B')


create table �gyf�l
-- megrendel�k �s vend�gek t�rzsadatai
(
azon int identity (101,1),
n�v varchar(20),
c�m varchar(40),
-- bankszla 
-- ig_sz�m
primary key (azon),
)
insert into �gyf�l (n�v, c�m) values ('walaki', 'valahol')


create table foglalt
(
szsz�m smallint,
mett�l date,
meddig date not null,
megrendel� int not null,
fogl_d�tuma datetime not null,
kifiz_d�tuma datetime, 
primary key (szsz�m, mett�l),
foreign key (szsz�m) references szoba (szsz�m),
foreign key (megrendel�) references �gyf�l (azon)
)

-- megj.
-- a foglalt term�szetes kulcsa helyett lehetne egyszer�, egy aut. gener�lt fogl_sz�m a kulcs
-- ekkor a lakik a foglal�s_sz�mmal hivatkozna a foglalt-ra...

create table lakik
(
szsz�m smallint,
mett�l date,
vend�g int,
-- �rkez�s datetime not null,
-- t�voz�s datetime,
primary key (szsz�m, mett�l, vend�g),
foreign key (szsz�m, mett�l) references foglalt (szsz�m, mett�l),
foreign key (vend�g) references �gyf�l (azon)
)



-- az evidens (kulcsok, k�ls� kulcsok, k�telez� le�r�) megszor�t�sokon t�li megszor�t�sok nincsenek m�g be�p�tve
-- ellen�rz� lek�rdez�sekkel MEGJELEN�TJ�K a HIB�San r�gz�tett adatokat
-- persze tesztadatok felvitele javasolt a be nem �p�tett megszor�t�sok ellen�rz�s�hez  


-- ahol az �gyak sz�ma vagy a szoba�r adatok helytelenek
select * from szobatipus
where �gy<=0 or �r<0

-- ahol a foglal�s intervalluma rossz
SELECT *
FROM foglalt
WHERE not mett�l<meddig;

-- ahol a foglal�s id�pontja k�s�i
SELECT *
FROM foglalt
WHERE not fogl_d�tuma<mett�l;

-- ahol a kifizet�s k�sik 
SELECT *
FROM foglalt
WHERE mett�l<getdate() and kifiz_d�tuma is null

-- ahol a bek�lt�z� tart�zkod�sa nem esik a lefoglalt intervallumba (a 2 mez� m�g nincs a lakik-t�bl�ban)
select * 
from lakik l inner join foglalt f on l.szsz�m=f.szsz�m and l.mett�l=f.mett�l
where not �rkez�s between f.mett�l and meddig or not t�voz�s between f.mett�l and meddig and t�voz�s is not null

-- ahol t�bben laknak a lefoglalt szob�ban, mint ah�ny �gyas a szoba
SELECT l.szsz�m, mett�l, count(vend�g) AS h�ny_vend�g, MAX(�gy) AS h�ny_�gyas
FROM lakik l, szoba sz, szobatipus t
WHERE l.szsz�m=sz.szsz�m and sz.sztip=t.sztip
GROUP BY l.szsz�m, mett�l
HAVING NOT count(vend�g)<=MAX(�gy);


-- Mely szobafoglal�sok �tk�znek egym�ssal?
-- sz�lloda eset�n a [mett�l, meddig) intervallumoknak nem lehet metszet�k egy szob�ra vonatk. 
-- ui. adott napon d�lig kijelentkezhetnek, du. bejelentkezhetnek ugyanabba a szob�ba

SELECT e.szsz�m, e.fogl_d�tuma, e.mett�l, e.meddig, m.szsz�m, m.fogl_d�tuma, m.mett�l, m.meddig
FROM foglalt AS e, foglalt AS m  -- egyik �s m�sik foglalt-sor
WHERE e.szsz�m=m.szsz�m and e.mett�l<m.mett�l -- uaz a szoba 2 k�l�nb. foglal�sa
and (e.mett�l between m.mett�l and dateadd(day, -1, m.meddig) OR m.mett�l between e.mett�l and dateadd(day, -1, e.meddig)) -- �tk�z�si felt�tel a)
-- and not (e.meddig<=m.mett�l or e.mett�l>=m.meddig) -- �tk�z�si felt�tel b)

-- mely foglal�shoz van azzal id�ben �tk�z� foglal�s?
SELECT szsz�m, mett�l, meddig, 'a szob�ra ezid�n bel�l m�sik foglal�s is van' as megj
from foglalt K
where (select count(*) from foglalt 
     where szsz�m=K.szsz�m and not (K.meddig<=mett�l or K.mett�l>=meddig)) > 1
-- order by 1,2

-- melyik foglal�shoz h�ny, azzal id�ben �tk�z� foglal�s van?
 
SELECT szsz�m, mett�l, meddig, 
    (select count(*) from foglalt 
     where szsz�m=K.szsz�m and not (K.meddig<=mett�l or K.mett�l>=meddig)) as ennyi_fogl_van_r�
from foglalt K
where (select count(*) from foglalt 
     where szsz�m=K.szsz�m and not (K.meddig<=mett�l or K.mett�l>=meddig)) > 1
-- order by 1,2
	 

-- extra lek�rd. a 101-es szoba h�ny �szak�t volt foglalt 2020-ban?
SELECT sum(datediff(day, mett�l, meddig)) as hib�san_sz�molva, 
sum(datediff(day, case when '20200101'> mett�l then'20200101' else mett�l end, case when '20201231'< meddig then '20210101' else meddig end)) as ennyi_napon
FROM foglalt
WHERE 2020 between year(mett�l) and year(meddig) 
and szsz�m=101;


