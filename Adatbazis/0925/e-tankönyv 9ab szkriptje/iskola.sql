
-- adott k�z�piskola adott tan�v�ben a di�kok (akik 9C alak� oszt�lyba j�rnak): 
-- havonta max. 1x kaphatnak seg�lyt vlmilyen jogc�men, 
-- ill. tagjai lehetnek b�rmely k�rnek, amely t�pusa SZakk�r/NYelvk�r/SPortk�r lehet
-- (a k�r azonos�t�ja az els� 2 karapteren jelzi annak t�pus�t, nem k�l�n mez�)

-- l�trehoz�s

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


-- felt�lt�s tesztadatokkal

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

-- lek�rdez�sek
use iskola
--H�ny oszt�ly van az iskol�ban?
select count(distinct osztaly) from tanulo
-- vagy
select count(*) from (select distinct osztaly from tanulo) s

--H�ny k�r van t�pusonk�nt?
select left(kor,2) as tipus, count(*) as h�ny
from kor 
group by left(kor,2)

--Oszt�lyonk�nt h�nyan j�rnak legal�bb 1 k�rre?
select osztaly, count(distinct g.azon) as ennyien
from tagsag G inner join tanulo T on g.azon=t.azon
group by osztaly

--Mely �vfolyamon van legfeljebb 30 tanul�?
select left(osztaly,1) as �vf, count(*) as l�tsz�m
from tanulo
group by left(osztaly,1)

--Jelenjen meg az els�s�k oszt�lyn�vsora!
select osztaly, nev, azon
from tanulo 
where osztaly like '1_' -- vagy where left(osztaly,1)='1'
order by 1,2,3

--Jelenjenek meg a nyelvk�r�k tags�g�nak oszt�lyn�vsorai!
select kor, osztaly, nev 
from tagsag g
	inner join tanulo t on g.azon=t.azon 
where osztaly like '1_' and kor like 'NY%'
order by 1,2,3

--Kik kapt�k meg a seg�lyt abban a h�napban, amikorra utalt�k?
select *
from segely
where month(kifiz) = honap -- �vre itt nem kell sz�rni, mert egy tan�v adatai voln�nak benne

--Kik �s mikor kaptak seg�lyt az jelenlegi �tlag feletti �sszegben?
select *
from segely
where osszeg > (select avg(osszeg) from segely)
--Kik �s mikor kaptak seg�lyt az akkori �tlag feletti �sszegben?
select *
from segely K
where osszeg > (select avg(osszeg) from segely where kifiz<=K.kifiz)

--Mekkora �sszegben fizettek ki seg�lyt ebben a h�napban az 1A oszt�lyos tanul�knak?
select sum(osszeg) as �sszesen
from segely s inner join tanulo t on s.azon=t.azon 
where osztaly = '1A' and year(kifiz)=year(getdate()) and month(kifiz)=month(getdate())

--Mely jogc�men nem fizettek seg�lyt tavaly? 
select * from jogcim
where jogc NOT IN
(select jogc from segely where year(kifiz)=year(getdate())-1)
-- vagy a gyorsabb halmazm�velettel, ha nem kell a megnevez�se is
select jogc from jogcim
except 
select jogc from segely where year(kifiz)=year(getdate())-1

--Ki j�r t�bbf�le sportk�rre?
select azon --, count(*) as h�ny
from tagsag
where kor like 'SP%'
group by azon
having count(*)>1

--Mely k�rnek van a legkevesebb tagja?
-- pontos�t�s: a k�rnek van tagja!
-- a) verzi� 2 l�p�sben
create view tagletszam as
select kor, count(*) as ennyien
from tagsag
group by kor

select *
from tagletszam
where ennyien=(select min(ennyien) from tagletszam)
-- b) verzi� 
select top 1 with ties kor, count(*) as ennyien
from tagsag
group by kor
order by 2 
-- amennyiben az a k�r is v�lasz lehet, aminek nincs tagja, akkor a kiindul� l�p�s:
select k.kor, count(azon) as ennyien
from kor k left outer join tagsag g on g.kor=k.kor
group by k.kor

--Melyik h�napra ki kapta a legnagyobb �sszeget?
-- azaz minden h�napra jelenjen meg a legt�bbet kap�: 
select honap, s.azon 
from segely s inner join tanulo t on s.azon=t.azon 
where osszeg=(select max(osszeg) from segely where honap=s.honap)

-- nem ez: melyik h�napra fizett�k ki �s kinek a legnagyobb �sszeget?
select honap, s.azon 
from segely s inner join tanulo t on s.azon=t.azon 
where osszeg=(select max(osszeg) from segely)

--Ki kapott seg�lyt t�bb mint egyszer?
select azon, count(*)
from segely
group by azon
having count(*)>1
--Ki kapott seg�lyt eddig a legt�bbsz�r?
select top 1 with ties azon, count(*)
from segely
group by azon
order by 2 desc
--Ki kapott seg�lyt mindig, amikor volt kifizet�s?
select azon, count(*)
from segely
group by azon
having count(*)=(select count(distinct honap) from segely)

--Mekkora az oszt�lyoknak �sszesen kifizetett seg�lyek �tlaga?
select avg(B.osszesen) as �tlag
from (
select osztaly, sum(osszeg) as osszesen
from segely s inner join tanulo t on s.azon=t.azon
group by osztaly
) B

--N�v szerint kik j�rnak sportk�rre �s nyelvk�rre, de szakk�rre nem?
-- klasszikusan:
select azon from tanulo
where azon in (select azon from tagsag where kor like 'SP%') 
and azon in (select azon from tagsag where kor like 'NY%')
and azon not in (select azon from tagsag where kor like 'SZ%')
-- �jabb halmazm�veletekkel:
select azon from tagsag where kor like 'SP%'
intersect
select azon from tagsag where kor like 'NY%'
except
select azon from tagsag where kor like 'SZ%'

--Melyik k�rnek ki a tagja a legt�bb �ve?
select kor, azon
from tagsag K
where hany_eve = (select max(hany_eve) from tagsag B where B.kor=K.kor)

-- k�ls� param�teres bels� lek�rdez�s n�lk�l 2 l�p�sben:
create view korevek as
select kor, max(hany_eve) as leg
from tagsag 
group by kor
-- a 2. l�p�s szint�n elmenthet� n�zetk�nt...
select e.kor, azon
from korevek e inner join tagsag g on e.kor=g.kor
where hany_eve=leg

--Az egyes oszt�lyok tanul�i �tlagosan heti h�ny �r�t t�ltenek szak-, nyelv- vagy sportk�ri foglalkoz�ssal?
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
-- vagy a 3. l�p�s a 0 �tlaggal rendelk. oszt�lyok megjelen�t�s�vel egy�tt:
select l.osztaly, isnull(osszora*1.0/letszam*1.0,0) 
from osszora o right outer join letszam l on o.osztaly=l.osztaly

-- figyelem, ha a f�t�bla a tagsag az �tlagol�skor, az �tlag hamis lesz! 
-- mert akkor nem az oszt�lyl�tsz�mmal osztjuk a tagok �ltal hozott heti �rasz�mok �sszeg�t:
select osztaly, avg(heti_oraszam*1.0) as hamis_�tlag
from tagsag g 
	inner join tanulo t on g.azon=t.azon
	inner join kor k on g.kor=k.kor
group by osztaly

--Az egyes oszt�lyokban n�v szerint ki t�lti a legt�bb id�t szak-, nyelv- vagy sportk�ri foglalkoz�ssal?
-- 1.l�p�sben egy k�nyelmes lek�rdez�st csin�lunk �s ment�nk el az egy�ni hozott �r�kra:
create view egyeni_orak as 
select g.azon, max(osztaly) as t_osztaly, max(nev) as t_nev, sum(heti_oraszam) as egyeni
from tagsag g 
	inner join tanulo t on g.azon=t.azon
	inner join kor k on g.kor=k.kor
group by g.azon
-- megj. az azont�l f�gg� oszt�ly �s n�v minden csoporton bel�l egyforma, amiknek a legnagyobbika/legkisebbike �nmaga

-- 2.l�p�sben a k�nyelmes t�bl�b�l lek�rdezz�k minden oszt�ly legakt�vabb tanul�j�t:
select * 
from egyeni_orak K
where egyeni=(select max(egyeni) from egyeni_orak where t_osztaly=K.t_osztaly)

--Melyik oszt�lyban nem volt seg�lykifizet�s?
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


--Minden oszt�lyra jelenjen meg, h�ny tanul� j�r sportk�rre!  

select osztaly, count(distinct g.azon)
from tagsag g right outer join tanulo t on g.azon=t.azon AND kor like 'SP%'
--where kor like 'SP%' -- itt nem helyes sz�rni, ha l�tni akrjuk a 0 tagl�tsz�m� oszt�lyokat is
group by osztaly

-- vagy Selectben elhelyezett alSelecttel (csak �ppen nincs oszt�ly-t�rzst�bla):
select distinct osztaly
	   , (select count(distinct g.azon) from tagsag g inner join tanulo t on g.azon=t.azon 
			where osztaly=tanulo.osztaly and kor like 'SP%') as ennyien
from tanulo 


-- javaslat: minden esetben tov. tesztadatok k�sz�t�s�vel vagy a meglev�k m�dos�t�s�val ellen�rizz�k a lek�rdez�seket!
