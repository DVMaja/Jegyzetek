
-- adott középiskola adott tanévi, minden héten ugyanolyan órarendjének nyt.
-- az osztályok diákjainak és a tantárgyakat tanító tanárok adataival
-- a nap (1-5) és óra (1-8) sorszámozott adat! az osztály 9C alakú adat
-- tantárgy azonosítója itt legyen annak rövidneve az évfolyammal pl. MAT7 a hetedikes matematika
-- figyelem: nincs osztály, sem terem törzstábla, és nem tárolt: mely tanárok mely tárgyakat taníthatják
-- akt. szabály: a párhuzamos osztályoknak ugyanazokat a tárgyakat kell tanítani az elõírt heti óraszámban
-- örök szabály: az órarendi órák ütközésmentesek (az osztályoknak és a tanároknak adott nap adott valahányadik tanórájában legfeljebb 1 órájuk lehet)

--create database oktatás
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
tanár int,
primary key (osztály, tant)
)

alter table tanít
add foreign key (tant) references tantárgy (tant)
alter table tanít
add foreign key (tanár) references tanár (kód)



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

create table terem
(
	tszám int,
	kapacitás smallint,
	primary key (tszám)
)

alter table órarend
-- add terem int
drop column terem






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

select * from órarend
order by 1,2,3
-- a K miatt az osztály nem is tudna ütközni


alter table órarend
add terem int

alter table órarend
add foreign key (terem) references TEREM (tszám)


select * from órarend
order by terem, nap, óra

update órarend set
terem=2
-- where osztály like '1%' -- % vagy _ jel a maszkoláshoz
-- where osztály='2b'
where terem is null

-- a terem se ütközzön adott nap adott órájában!
-- egy UK biztosítja: nap,óra,terem (nemclusteres indexként)

CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20230925-153945] ON [dbo].[órarend]
(
	[nap] ASC,
	[óra] ASC,
	[terem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


alter table órarend
add check (nap between 1 and 5)
-- óra 1 és 10 közötti legyen
-- a tanár se ütközzön adott nap adott órájában már egy igazi constraint-et igényel...
-- folyt. egy fgv segítségével megírható megszorítással


