
-- adott középiskola adott tanévi, minden héten ugyanolyan órarendjének nyt.
-- az osztályok diákjainak és a tantárgyakat tanító tanárok adataival
-- a nap (1-5) és óra (1-8) sorszámozott adat! az osztály 9C alakú adat
-- tantárgy azonosítója itt legyen annak rövidneve az évfolyammal pl. MAT7 a hetedikes matematika
-- figyelem: nincs osztály, sem terem törzstábla, és nem tárolt: mely tanárok mely tárgyakat taníthatják
-- akt. szabály: a párhuzamos osztályoknak ugyanazokat a tárgyakat kell tanítani az elõírt heti óraszámban
-- örök szabály: az órarendi órák ütközésmentesek (az osztályoknak és a tanároknak adott nap adott valahányadik tanórájában legfeljebb 1 órájuk lehet)

create database oktatás
go

use oktatás

create table diák
(
azon int identity (101,1),
osztály char(2) not null,
név varchar(30) not null, 
primary key (azon)
)

create table tanár
(
kód int identity (11,1),
név varchar(30) not null, 
szoba smallint,
-- belépés date,
primary key (kód)
)


create table tantárgy
(
tant char(5),
megnevezés varchar(25) not null, 
heti_óraszám tinyint not null,
primary key (tant)
)

create table tanít
(
osztály char(2),
tant char(5),
kód int,
primary key (osztály, tant)
)

alter table tanít
add foreign key (tant) references tantárgy (tant)
alter table tanít
add foreign key (kód) references tanár (kód)



create table órarend
(
osztály char(2),
nap tinyint,
óra tinyint,
tant char(5),
primary key (osztály, nap, óra)
)

alter table órarend
add foreign key (osztály, tant) references tanít (osztály, tant)

-- megj. a terem lehet vagy a tanít, vagy az órarend adata a konkrét ügymenet szerint (ez befolyásolja, milyen egyedi kulcsok lehetnek még)


-- Tesztadatok 
-- (2 ill. 3 párhuzamos osztályban 20 diák, csak 4 tanár, 5 tantárgy; 
-- a párhuzamos osztályoknak uazt tanítják, de van 1 tanári ütközés
-- az órarendi órák leütemezése nincs befejezve)
   

insert into diák (osztály, név) values ('2A', 'VARGA TEREZ')
insert into diák (osztály, név) values ('2A', 'MOLNAR GEZA')
insert into diák (osztály, név) values ('2B', 'BALOGH MIHALY')
insert into diák (osztály, név) values ('2B', 'CINEGE KATA')
insert into diák (osztály, név) values ('2A', 'VIDA ZSOFIA')
insert into diák (osztály, név) values ('1C', 'ALMASI GABOR')
insert into diák (osztály, név) values ('1C', 'SZABO ENDRE')
insert into diák (osztály, név) values ('1C', 'BAN TIBOR')
insert into diák (osztály, név) values ('1C', 'PEK LILLA')
insert into diák (osztály, név) values ('1C', 'RIGO PAL')
insert into diák (osztály, név) values ('1C', 'VARGA DANIEL')
insert into diák (osztály, név) values ('1C', 'SZABO PETER')
insert into diák (osztály, név) values ('1A', 'KOVACS BEA')
insert into diák (osztály, név) values ('1B', 'LOVAS LAJOS')
insert into diák (osztály, név) values ('1A', 'MAGYAR ANNA')
insert into diák (osztály, név) values ('1A', 'NAGY KOLOS')
insert into diák (osztály, név) values ('1A', 'KISS ZSOLT')
insert into diák (osztály, név) values ('1B', 'KIS MARIA')
insert into diák (osztály, név) values ('1B', 'KIS LILLA')
insert into diák (osztály, név) values ('1B', 'ALIG ELEK')

insert into tanár (név, szoba) values ('OKOS ELEK', 101)
insert into tanár (név, szoba) values ('CSÚCS ILI', 101)
insert into tanár (név, szoba) values ('UNDOK SÁRA', 102)
insert into tanár (név, szoba) values ('ZORD ÖDÖN', 105)

insert into tantárgy values ('MAT1', 'matematika 1', 5)
insert into tantárgy values ('MAT2', 'matematika 2', 5)
insert into tantárgy values ('IRO1', 'irodalom 1', 2)
insert into tantárgy values ('FIZ2', 'fizika 2', 3)
insert into tantárgy values ('INFO1', 'informatika 1', 2)

insert into tanít values ('1A','INFO1', 11)
insert into tanít values ('1B','INFO1', 11)
insert into tanít values ('1C','INFO1', 11)
insert into tanít values ('1A','IRO1', 12)
insert into tanít values ('1B','IRO1', 12)
insert into tanít values ('1C','IRO1', 13)
insert into tanít values ('1A','MAT1', 14)
insert into tanít values ('1B','MAT1', 14)
insert into tanít values ('1C','MAT1', 12)
insert into tanít values ('2A','MAT2', 14)
insert into tanít values ('2B','MAT2', 14)
insert into tanít values ('2A','FIZ2', 13)
insert into tanít values ('2B','FIZ2', 14)

insert into órarend values ('2A',1, 1, 'FIZ2')
insert into órarend values ('2B',2, 1, 'FIZ2')
insert into órarend values ('2A',1, 2, 'MAT2')
insert into órarend values ('2B',2, 2, 'MAT2')
insert into órarend values ('2A',3, 3, 'FIZ2')
insert into órarend values ('2B',4, 3, 'FIZ2')
insert into órarend values ('2A',3, 4, 'FIZ2')
insert into órarend values ('2B',4, 4, 'FIZ2')
insert into órarend values ('1A',3, 1, 'IRO1')
insert into órarend values ('1B',4, 1, 'MAT1')
insert into órarend values ('1B',4, 4, 'MAT1')


-- Lekérdezések

-- Adott tanár órarendje

declare @kód int
set @kód=14

select * 
from órarend r inner join tanít t on r.osztály=t.osztály and r.tant=t.tant
where kód=@kód
order by nap, óra

-- Az egyes tárgyakból mikor van a heti legelsõ óra?

select tant, nap, óra
from órarend k
where 10*nap+óra = (select MIN(10*nap+óra) from órarend where tant=k.tant)

-- A napi legutolsó tanórák...

select nap, max(óra) -- mikor vannak?
from órarend
group by nap

select nap, tant, osztály -- mik azok?
from órarend K
where óra=(select max(óra) from órarend where nap=K.nap)

-- Tanári ütközések

SELECT kód as tanár, nap, óra, count(*) AS hány_osztályt
FROM órarend AS r, tanít AS t
WHERE r.osztály=t.osztály and r.tant=t.tant
GROUP BY kód, nap, óra
HAVING count(*)>1;

-- Hiányzó tanórák (mely osztálynak mely tárgyból hány óra nincs leütemezve)
	
	-- klasszikus szabv. megoldással:
	-- 1. lépésben összeszámoljuk, mely osztálynak mely tárgyból mennyi óra ban az órarendben, hozzátéve, amibõl 0
	create view levan as
	SELECT osztály, tant, count(*) AS leütemezve
	FROM órarend
	GROUP BY osztály, tant
	UNION
	SELECT osztály, tant, 0
	from tanít t
	-- where osztály+tant not in (select  osztály+tant from órarend);
	where not exists (select  1 from órarend where osztály=t.osztály and tant=t.tant);
	-- 2. lépésben az elõbbi E-tábla óraszámait kivonjuk a megfelelõ tantárgy elõírt heti óraszámából
	SELECT osztály, t.tant, heti_óraszám-leütemezve as nincs
	from levan l inner join tantárgy t on l.tant=t.tant
	where heti_óraszám <> leütemezve 
					-- heti_óraszám > leütemezve elegendõ szûrõfeltétel lenne, ha nem engednénk meg a túlütemezést
	
	-- korszerûbb megoldással az 1. lépés:
	create view levanB as
	SELECT t.osztály, t.tant, count(r.osztály) AS leütemezve
	FROM tanít t left outer join órarend r on t.osztály=r.osztály and t.tant=r.tant 
	GROUP BY t.osztály, t.tant

	-- bátrabb megoldás összesen 1 lépésben:
	SELECT t.osztály, t.tant, max(heti_óraszám) - count(r.osztály) as nincs
	FROM (tanít t left outer join órarend r on t.osztály=r.osztály and t.tant=r.tant) inner join tantárgy g on t.tant=g.tant
	GROUP BY t.osztály, t.tant
	having max(heti_óraszám) > count(r.osztály)


-- Kiket mire tanít Zord Ödön?

-- ellenõrizzük az alábbi kiinduló táblát (amely 2, egymással kapcsolatban nem lévõ táblából épült): 
-- minden diák annyiszor jelenik meg, ahány tárgyat tanítanak az osztályának
-- ill. minden tanít-sor annyiszor jelenik meg, ahány diák jár az akt. tanít osztályába
	select *
	from diák d inner join tanít t on d.osztály=t.osztály
	--order by t.osztály, tant, azon
	--order by azon, tant 

select d.*, tant
from diák d 
	inner join tanít t on d.osztály=t.osztály
	inner join tanár p on t.kód=p.kód
where p.név='Zord Ödön'
--order by d.név, tant

