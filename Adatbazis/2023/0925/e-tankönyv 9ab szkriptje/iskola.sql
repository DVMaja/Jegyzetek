
-- adott középiskola adott tanévében a diákok (akik 9C alakú osztályba járnak): 
-- havonta max. 1x kaphatnak segélyt vlmilyen jogcímen, 
-- ill. tagjai lehetnek bármely körnek, amely típusa SZakkör/NYelvkör/SPortkör lehet
-- (a kör azonosítója az elsõ 2 karapteren jelzi annak típusát, nem külön mezõ)

-- létrehozás

create database iskola
go

use iskola

create table tanulo
(
azon char(5),
osztaly char(2),
nev varchar(30), 
primary key (azon)
)

create table jogcim
(
jogc char(2),
megnev varchar(25),
primary key (jogc)
)


create table segely
(
azon char(5),
honap tinyint,
osszeg money, 
kifiz date,
jogc char(2),
primary key (azon, honap)
)

create table kor
(
kor char(5),
elnev varchar(20),
heti_oraszam tinyint,
primary key (kor) 
)


create table tagsag
(
azon char(5),
kor char(5),
hany_eve tinyint,
primary key (azon, kor)
)

alter table segely
add foreign key (azon) references tanulo (azon)

alter table tagsag
add foreign key (azon) references tanulo (azon)

alter table segely
add foreign key (jogc) references jogcim (jogc)

alter table tagsag
add foreign key (kor) references kor (kor)


-- feltöltés tesztadatokkal

insert into tanulo values ('91113', '2A', 'VARGA TEREZ')
insert into tanulo values ('91115', '2A', 'MOLNAR GEZA')
insert into tanulo values ('91116', '2B', 'BALOGH MIHALY')
insert into tanulo values ('91117', '2B', 'CINEGE KATA')
insert into tanulo values ('91120', '2A', 'VIDA ZSOFIA')
insert into tanulo values ('91121', '2C', 'ALMASI GABOR')
insert into tanulo values ('91123', '2C', 'SZABO ENDRE')
insert into tanulo values ('91124', '2C', 'BAN TIBOR')
insert into tanulo values ('91125', '2C', 'PEK LILLA')
insert into tanulo values ('91127', '2C', 'RIGO PAL')
insert into tanulo values ('91128', '2C', 'VARDA DANIEL')
insert into tanulo values ('91129', '2C', 'SZABO PETER')
insert into tanulo values ('92111', '1A', 'KOVACS BEA')
insert into tanulo values ('92112', '1B', 'LOVAS LAJOS')
insert into tanulo values ('92115', '1A', 'MAGYAR ANNA')
insert into tanulo values ('92117', '1A', 'NAGY KOLOS')
insert into tanulo values ('92118', '1A', 'KISS ZSOLT')
insert into tanulo values ('92119', '1B', 'KIS MARIA')
insert into tanulo values ('92120', '1B', 'KIS LILLA')
insert into tanulo values ('92121', '1B', 'ALIG ELEK')


insert into jogcim values ('ar', 'arvasagi')
insert into jogcim values ('be', 'beiskolazasi')
insert into jogcim values ('cs', 'nagycsalados')
insert into jogcim values ('sz', 'szakkonyvvasarlas')
insert into jogcim values ('tk', 'tankonyv hozzajarulas')

insert into segely values ('91113', 3, 21000, '19970329', 'ar')
insert into segely values ('91116', 3, 11000, '19970329', 'sz')
insert into segely values ('91123', 3, 2800, '19970329', 'cs')
insert into segely values ('92112', 2, 12000, '19970312', 'cs')
insert into segely values ('92115', 2, 3000, '19970312', 'sz')
insert into segely values ('92118', 2, 4500, '19970212', 'sz')
insert into segely values ('92119', 2, 11000, '19970211', 'tk')
insert into segely values ('92119', 3, 8000, '19970312', 'sz')


insert into kor values ('NYANG', 'angol kezdo', 8)
insert into kor values ('NYFRA', 'francia', 4)
insert into kor values ('SPATL', 'atletika', 5)
insert into kor values ('SPKOS', 'kosarlabda', 5)
insert into kor values ('SPTEN', 'tenisz', 4)
insert into kor values ('SPTOR', 'torna', 5)
insert into kor values ('SZBIO', 'biologia', 4)
insert into kor values ('SZFIZ', 'fizika', 4)
insert into kor values ('SZMAT', 'matematika', 6)

insert into tagsag values ('91113', 'NYANG', 1)
insert into tagsag values ('91113', 'SPTOR', 1)
insert into tagsag values ('91123', 'SPKOS', 2)
insert into tagsag values ('91128', 'SPATL', 1)
insert into tagsag values ('92115', 'SPATL', 0)
insert into tagsag values ('92115', 'NYFRA', 0)
insert into tagsag values ('92119', 'NYANG', 1)
insert into tagsag values ('92119', 'SZBIO', 0)
insert into tagsag values ('92115', 'SZBIO', 1)

-- lekérdezések
use iskola
--Hány osztály van az iskolában?
select count(distinct osztaly) from tanulo
-- vagy
select count(*) from (select distinct osztaly from tanulo) s

--Hány kör van típusonként?
select left(kor,2) as tipus, count(*) as hány
from kor 
group by left(kor,2)

--Osztályonként hányan járnak legalább 1 körre?
select osztaly, count(distinct g.azon) as ennyien
from tagsag G inner join tanulo T on g.azon=t.azon
group by osztaly

--Mely évfolyamon van legfeljebb 30 tanuló?
select left(osztaly,1) as évf, count(*) as létszám
from tanulo
group by left(osztaly,1)

--Jelenjen meg az elsõsök osztálynévsora!
select osztaly, nev, azon
from tanulo 
where osztaly like '1_' -- vagy where left(osztaly,1)='1'
order by 1,2,3

--Jelenjenek meg a nyelvkörök tagságának osztálynévsorai!
select kor, osztaly, nev 
from tagsag g
	inner join tanulo t on g.azon=t.azon 
where osztaly like '1_' and kor like 'NY%'
order by 1,2,3

--Kik kapták meg a segélyt abban a hónapban, amikorra utalták?
select *
from segely
where month(kifiz) = honap -- évre itt nem kell szûrni, mert egy tanév adatai volnának benne

--Kik és mikor kaptak segélyt az jelenlegi átlag feletti összegben?
select *
from segely
where osszeg > (select avg(osszeg) from segely)
--Kik és mikor kaptak segélyt az akkori átlag feletti összegben?
select *
from segely K
where osszeg > (select avg(osszeg) from segely where kifiz<=K.kifiz)

--Mekkora összegben fizettek ki segélyt ebben a hónapban az 1A osztályos tanulóknak?
select sum(osszeg) as összesen
from segely s inner join tanulo t on s.azon=t.azon 
where osztaly = '1A' and year(kifiz)=year(getdate()) and month(kifiz)=month(getdate())

--Mely jogcímen nem fizettek segélyt tavaly? 
select * from jogcim
where jogc NOT IN
(select jogc from segely where year(kifiz)=year(getdate())-1)
-- vagy a gyorsabb halmazmûvelettel, ha nem kell a megnevezése is
select jogc from jogcim
except 
select jogc from segely where year(kifiz)=year(getdate())-1

--Ki jár többféle sportkörre?
select azon --, count(*) as hány
from tagsag
where kor like 'SP%'
group by azon
having count(*)>1

--Mely körnek van a legkevesebb tagja?
-- pontosítás: a körnek van tagja!
-- a) verzió 2 lépésben
create view tagletszam as
select kor, count(*) as ennyien
from tagsag
group by kor

select *
from tagletszam
where ennyien=(select min(ennyien) from tagletszam)
-- b) verzió 
select top 1 with ties kor, count(*) as ennyien
from tagsag
group by kor
order by 2 
-- amennyiben az a kör is válasz lehet, aminek nincs tagja, akkor a kiinduló lépés:
select k.kor, count(azon) as ennyien
from kor k left outer join tagsag g on g.kor=k.kor
group by k.kor

--Melyik hónapra ki kapta a legnagyobb összeget?
-- azaz minden hónapra jelenjen meg a legtöbbet kapó: 
select honap, s.azon 
from segely s inner join tanulo t on s.azon=t.azon 
where osszeg=(select max(osszeg) from segely where honap=s.honap)

-- nem ez: melyik hónapra fizették ki és kinek a legnagyobb összeget?
select honap, s.azon 
from segely s inner join tanulo t on s.azon=t.azon 
where osszeg=(select max(osszeg) from segely)

--Ki kapott segélyt több mint egyszer?
select azon, count(*)
from segely
group by azon
having count(*)>1
--Ki kapott segélyt eddig a legtöbbször?
select top 1 with ties azon, count(*)
from segely
group by azon
order by 2 desc
--Ki kapott segélyt mindig, amikor volt kifizetés?
select azon, count(*)
from segely
group by azon
having count(*)=(select count(distinct honap) from segely)

--Mekkora az osztályoknak összesen kifizetett segélyek átlaga?
select avg(B.osszesen) as átlag
from (
select osztaly, sum(osszeg) as osszesen
from segely s inner join tanulo t on s.azon=t.azon
group by osztaly
) B

--Név szerint kik járnak sportkörre és nyelvkörre, de szakkörre nem?
-- klasszikusan:
select azon from tanulo
where azon in (select azon from tagsag where kor like 'SP%') 
and azon in (select azon from tagsag where kor like 'NY%')
and azon not in (select azon from tagsag where kor like 'SZ%')
-- újabb halmazmûveletekkel:
select azon from tagsag where kor like 'SP%'
intersect
select azon from tagsag where kor like 'NY%'
except
select azon from tagsag where kor like 'SZ%'

--Melyik körnek ki a tagja a legtöbb éve?
select kor, azon
from tagsag K
where hany_eve = (select max(hany_eve) from tagsag B where B.kor=K.kor)

-- külsõ paraméteres belsõ lekérdezés nélkül 2 lépésben:
create view korevek as
select kor, max(hany_eve) as leg
from tagsag 
group by kor
-- a 2. lépés szintén elmenthetõ nézetként...
select e.kor, azon
from korevek e inner join tagsag g on e.kor=g.kor
where hany_eve=leg

--Az egyes osztályok tanulói átlagosan heti hány órát töltenek szak-, nyelv- vagy sportköri foglalkozással?
create view osszora as
select osztaly, sum(heti_oraszam) as osszora
from tagsag g 
	inner join tanulo t on g.azon=t.azon
	inner join kor k on g.kor=k.kor
group by osztaly
create view letszam as 
select osztaly, count(*) as letszam
from tanulo
group by osztaly
create view atlagok as
select l.osztaly, osszora*1.0/letszam*1.0 
from osszora o inner join letszam l on o.osztaly=l.osztaly
-- vagy a 3. lépés a 0 átlaggal rendelk. osztályok megjelenítésével együtt:
select l.osztaly, isnull(osszora*1.0/letszam*1.0,0) 
from osszora o right outer join letszam l on o.osztaly=l.osztaly

-- figyelem, ha a fõtábla a tagsag az átlagoláskor, az átlag hamis lesz! 
-- mert akkor nem az osztálylétszámmal osztjuk a tagok által hozott heti óraszámok összegét:
select osztaly, avg(heti_oraszam*1.0) as hamis_átlag
from tagsag g 
	inner join tanulo t on g.azon=t.azon
	inner join kor k on g.kor=k.kor
group by osztaly

--Az egyes osztályokban név szerint ki tölti a legtöbb idõt szak-, nyelv- vagy sportköri foglalkozással?
-- 1.lépésben egy kényelmes lekérdezést csinálunk és mentünk el az egyéni hozott órákra:
create view egyeni_orak as 
select g.azon, max(osztaly) as t_osztaly, max(nev) as t_nev, sum(heti_oraszam) as egyeni
from tagsag g 
	inner join tanulo t on g.azon=t.azon
	inner join kor k on g.kor=k.kor
group by g.azon
-- megj. az azontól függõ osztály és név minden csoporton belül egyforma, amiknek a legnagyobbika/legkisebbike önmaga

-- 2.lépésben a kényelmes táblából lekérdezzük minden osztály legaktívabb tanulóját:
select * 
from egyeni_orak K
where egyeni=(select max(egyeni) from egyeni_orak where t_osztaly=K.t_osztaly)

--Melyik osztályban nem volt segélykifizetés?
-- a)
select distinct osztaly 
from tanulo
where osztaly not in (select osztaly from segely s inner join tanulo t on s.azon=t.azon) 
-- b)
select distinct osztaly 
from tanulo
where not exists (select 1 from segely s inner join tanulo t on s.azon=t.azon where osztaly=tanulo.osztaly) 
-- c)
select osztaly from tanulo
except
select osztaly from segely s inner join tanulo t on s.azon=t.azon


--Minden osztályra jelenjen meg, hány tanuló jár sportkörre!  

select osztaly, count(distinct g.azon)
from tagsag g right outer join tanulo t on g.azon=t.azon AND kor like 'SP%'
--where kor like 'SP%' -- itt nem helyes szûrni, ha látni akrjuk a 0 taglétszámú osztályokat is
group by osztaly

-- vagy Selectben elhelyezett alSelecttel (csak éppen nincs osztály-törzstábla):
select distinct osztaly
	   , (select count(distinct g.azon) from tagsag g inner join tanulo t on g.azon=t.azon 
			where osztaly=tanulo.osztaly and kor like 'SP%') as ennyien
from tanulo 


-- javaslat: minden esetben tov. tesztadatok készítésével vagy a meglevõk módosításával ellenõrizzék a lekérdezéseket!
