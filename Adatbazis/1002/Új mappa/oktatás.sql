
-- adott k�z�piskola adott tan�vi, minden h�ten ugyanolyan �rarendj�nek nyt.
-- az oszt�lyok di�kjainak �s a tant�rgyakat tan�t� tan�rok adataival
-- a nap (1-5) �s �ra (1-8) sorsz�mozott adat! az oszt�ly 9C alak� adat
-- tant�rgy azonos�t�ja itt legyen annak r�vidneve az �vfolyammal pl. MAT7 a hetedikes matematika
-- figyelem: nincs oszt�ly, sem terem t�rzst�bla, �s nem t�rolt: mely tan�rok mely t�rgyakat tan�thatj�k
-- akt. szab�ly: a p�rhuzamos oszt�lyoknak ugyanazokat a t�rgyakat kell tan�tani az el��rt heti �rasz�mban
-- �r�k szab�ly: az �rarendi �r�k �tk�z�smentesek (az oszt�lyoknak �s a tan�roknak adott nap adott valah�nyadik tan�r�j�ban legfeljebb 1 �r�juk lehet)

--create database oktat�s
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
tan�r int,
primary key (oszt�ly, tant)
)

alter table tan�t
add foreign key (tant) references tant�rgy (tant)
alter table tan�t
add foreign key (tan�r) references tan�r (k�d)



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

create table terem
(
	tsz�m int,
	kapacit�s smallint,
	primary key (tsz�m)
)

alter table �rarend
-- add terem int
drop column terem






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

select * from �rarend
order by 1,2,3
-- a K miatt az oszt�ly nem is tudna �tk�zni


alter table �rarend
add terem int

alter table �rarend
add foreign key (terem) references TEREM (tsz�m)


select * from �rarend
order by terem, nap, �ra

update �rarend set
terem=2
-- where oszt�ly like '1%' -- % vagy _ jel a maszkol�shoz
-- where oszt�ly='2b'
where terem is null

-- a terem se �tk�zz�n adott nap adott �r�j�ban!
-- egy UK biztos�tja: nap,�ra,terem (nemclusteres indexk�nt)

CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20230925-153945] ON [dbo].[�rarend]
(
	[nap] ASC,
	[�ra] ASC,
	[terem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


alter table �rarend
add check (nap between 1 and 5)
-- �ra 1 �s 10 k�z�tti legyen
-- a tan�r se �tk�zz�n adott nap adott �r�j�ban m�r egy igazi constraint-et ig�nyel...
-- folyt. egy fgv seg�ts�g�vel meg�rhat� megszor�t�ssal


