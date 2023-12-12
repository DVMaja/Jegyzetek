
--- 4 táblás Munka ab. létrehozása
create database munka
go

use munka
go

create table megrendelõ
(
azon integer,
név varchar(40),
ir_szám char(4),
helység varchar(30),
utca_hsz varchar(40),
telefon char(12),
primary key (azon)
)
go


create table dolgozó
(
kód integer IDENTITY(1001,1),
neve varchar(40),
belép_éve smallint,
szül_éve smallint,
primary key (kód)
)
go

create table munka
(
m_szám char(9),
megrendelõ int,
vezetõ int,
óraszám smallint,
óradíj money,
elnevezés varchar(40),
ind_kelt date,
határidõ date,
primary key (m_szám)
)
go

create table csoport
(
m_szám char(9),
kód int,
primary key (m_szám, kód)
)
go


alter table munka
add foreign key (megrendelõ) references Megrendelõ (azon)
alter table munka
add foreign key (vezetõ) references Dolgozó (kód)
go

alter table csoport
add foreign key (m_szám) references Munka (m_szám)
alter table csoport
add foreign key (kód) references Dolgozó (kód)
go

--- adatok
insert into megrendelõ values 
(1,'Kincskeresõ Rt.','2121', 'Budapest', 'Fõ u. 22.', null),
(2,'ABC Kft.','6767', 'Pécs', null, null),
(3,'Kovács és tsa BT','1212', 'Budapest', 'Tejút u. 122.', null)
go

insert into dolgozó (neve, belép_éve, szül_éve) values 
('Fehér Mária', 1998, 1960),
('Fekete Ádám', 2001, 1979),
('Brassai István', 1998, 1976),
('Kiss Péter', 2001, 1970),
('Nagy Péter', 2010, 1980),
('Nagy Pál', 2010, 1988),
('Varga Éva', 2005, 1990)
go

insert into munka values 
('2003/123',2, 1003, 30, 4500, 'weboldal módosítás', '20030105', '20040206'),
('2003/125',1, 1005, 120, 8000, 'betanítás', '20030120', '20030130'),
('2003/203',1, 1005, 15, 6000, 'tananyag fejlesztés', '20030120', '20040206'),
('2003/204',2, 1007, 120, 5000, 'lekérdezések', '20031123', '20031218'),
('2003/111',3, 1005, 25, 8000, 'szakértés', '20040120', '20040206')
go

insert into csoport values 
('2003/123',1001),
('2003/123',1002),
('2003/125',1004),
('2003/125',1006),
('2003/125',1007),
('2003/203',1007),
('2003/204',1003),
('2003/204',1004),
('2003/111',1007)
go


-- Lekérdezések
--1.	Hány munka készült Pécsre?
SELECT COUNT(*) AS HÁNY
FROM MUNKA
WHERE MEGRENDELÕ IN (SELECT AZON FROM megrendelõ WHERE HELYSÉG Like '%Pécs%');
--vagy
SELECT COUNT(*) AS HÁNY
FROM megrendelõ, MUNKA
WHERE MEGRENDELÕ=AZON And HELYSÉG Like '%Pécs%';

--2.	Ma kiknek jár le a határidejük?
SELECT  VEZETÕ AS KÓD
FROM MUNKA
WHERE HATÁRIDÕ=getdate()
UNION 
SELECT KÓD
FROM MUNKA, CSOPORT
WHERE MUNKA.M_SZÁM=CSOPORT.M_SZÁM And HATÁRIDÕ=getdate();

--3.	Nagy Pál milyen munkákban vett részt az elmúlt évben?
SELECT M.M_SZÁM
FROM CSOPORT C, DOLGOZÓ D, MUNKA M
WHERE C.KÓD=D.KÓD And C.M_SZÁM=M.M_SZÁM And NEVE='Nagy Pál' And YEAR(IND_KELT)=YEAR(GETDATE())-1;

--4.	Az egyes munkák hány napig tartanak?
SELECT M_SZÁM, datediff(day, IND_KELT, HATÁRIDÕ) AS NAPOS
FROM MUNKA;

--5.	Naponta hány munka indult el eddig?
SELECT IND_KELT, COUNT(*) as ennyi
FROM MUNKA
WHERE ind_kelt<getdate()
GROUP BY IND_KELT;

--6.	Csoportlétszámok
SELECT M_SZÁM, COUNT(KÓD) AS LÉTSZÁM
FROM CSOPORT
GROUP BY M_SZÁM;

--7.	Az egyes csoportok átlagéletkora?
SELECT M_SZÁM, AVG(YEAR(getdate())-SZÜL_ÉVE) AS ÁTLAGKOR
FROM DOLGOZÓ D, CSOPORT C
WHERE D.KÓD=C.KÓD
GROUP BY M_SZÁM;
-- pontosabban nem idén, hanem a munkák indulásának évében:
SELECT c.M_SZÁM, AVG(YEAR(ind_kelt)-SZÜL_ÉVE) AS ÁTLAGKOR
FROM DOLGOZÓ D, CSOPORT C, MUNKA M
WHERE D.KÓD=C.KÓD and M.m_szám=C.m_szám
GROUP BY c.M_SZÁM;

-- 8.	Árbevételek megrendelõnként?
SELECT MEGRENDELÕ, SUM(ÓRADÍJ*ÓRASZÁM) as árbev
FROM MUNKA
GROUP BY MEGRENDELÕ;

--9.	Munkaórák összege vezetõnként?
SELECT VEZETÕ, SUM(ÓRASZÁM) as összóra
FROM MUNKA
GROUP BY VEZETÕ;

--10.	A legnagyobb óraszámú munka?
SELECT *
FROM MUNKA
WHERE ÓRASZÁM = (SELECT MAX(ÓRASZÁM) FROM MUNKA);
-- vagy a megfelelõ rendezést követõ holtverseny kezelésével
SELECT top 1 with ties *
FROM MUNKA
order by ÓRASZÁM desc;

--11.	A legrövidebb határidejû munka?
SELECT *, datediff(day, IND_KELT, HATÁRIDÕ) AS NAPOS
FROM MUNKA
WHERE datediff(day, IND_KELT, HATÁRIDÕ)=(SELECT MIN(datediff(day, IND_KELT, HATÁRIDÕ)) FROM MUNKA);
-- 2 dátum különbsége újra használható, ami alapértelmezetten napokban adja vissza az eltelt idõt:
SELECT *, HATÁRIDÕ-IND_KELT AS NAPOS 
FROM MUNKA
WHERE HATÁRIDÕ-IND_KELT=(SELECT MIN(HATÁRIDÕ-IND_KELT) FROM MUNKA);

--12.	Kik dolgoztak a legnagyobb óradíjas munkán?
SELECT DISTINCT KÓD
FROM MUNKA M, CSOPORT C
WHERE M.M_SZÁM=C.M_SZÁM 
AND
ÓRADÍJ=(SELECT  MAX(ÓRADÍJ)  FROM MUNKA);
-- ha név szerint kérik, kik azok:
SELECT DISTINCT c.kód, neve
FROM MUNKA M, CSOPORT C, dolgozó d
WHERE M.M_SZÁM=C.M_SZÁM and d.kód=c.kód
AND
ÓRADÍJ=(SELECT  MAX(ÓRADÍJ)  FROM MUNKA);

--13.	Hova készült a legkisebb óradíjas munka?
SELECT ir_szám, helység, utca_hsz
FROM MEGRENDELÕ, MUNKA
WHERE MEGRENDELÕ=AZON
AND ÓRADÍJ = (SELECT MIN(ÓRADÍJ) FROM MUNKA);
-- vagy
SELECT *
FROM MEGRENDELÕ
WHERE AZON IN (SELECT MEGRENDELÕ FROM MUNKA WHERE  ÓRADÍJ = (SELECT MIN(ÓRADÍJ) FROM MUNKA));

--14.	Ki nem volt még soha vezetõ?
SELECT *
FROM DOLGOZÓ
WHERE KÓD not IN (SELECT VEZETÕ FROM MUNKA);
-- esetleg törzsadatok nélkül megválaszolva, halmazmûveleti különbség segítségével
SELECT kód FROM DOLGOZÓ
except
SELECT VEZETÕ FROM MUNKA;

--15.	Ki dolgozott eddig csak vezetõként?
SELECT *
FROM DOLGOZÓ
WHERE KÓD  in (SELECT VEZETÕ FROM MUNKA)
AND KÓD NOT IN (SELECT KÓD FROM CSOPORT);

--16.	Melyik munkán dolgozott együtt Kiss Péter és Nagy Pál?
SELECT M_SZÁM
FROM CSOPORT AS C, DOLGOZÓ AS D
WHERE C.KÓD=D.KÓD And NEVE='Kiss Péter';
-- a lekérdezés mentve m_KP néven
SELECT M_SZÁM
FROM CSOPORT AS C, DOLGOZÓ AS D
WHERE C.KÓD=D.KÓD And NEVE='Nagy Pál';
-- a lekérdezés mentve m_NP néven
-- 3. lépésben a 2 E-táblát összekapcsoljuk:
SELECT *
FROM m_KP, m_NP
WHERE m_KP.m_szám=m_NP.m_szám;

-- ilyenkor a 2 E-tábla közvetlenül készül el a 3. lekérdezés Fromjában, tehát így is megvalósítható:
SELECT * -- a közös m_számok egyikét elég kiírni
FROM 
	(SELECT M_SZÁM
	FROM CSOPORT AS C, DOLGOZÓ AS D
	WHERE C.KÓD=D.KÓD And NEVE='Kiss Péter') m_KP, 
	(SELECT M_SZÁM
	FROM CSOPORT AS C, DOLGOZÓ AS D
	WHERE C.KÓD=D.KÓD And NEVE='Nagy Pál') m_NP
WHERE m_KP.m_szám=m_NP.m_szám;

-- figyelem: bármely szerveren nézetként menthetõk a lekérdezések! pl.
	CREATE VIEW m_KP
	as 
	SELECT M_SZÁM
	FROM CSOPORT C, DOLGOZÓ D
	WHERE C.KÓD=D.KÓD And NEVE='Kiss Péter';
go

--17.	Kik dolgoztak eddig csak egyetlen vezetõ alatt?
create view lek17_1 as
SELECT DISTINCT KÓD, VEZETÕ
FROM munka M, csoport C
WHERE M.M_SZÁM=C.M_SZÁM;
-- mentve lek17_1 néven
SELECT KÓD, COUNT(*) AS HÁNY_VEZ
FROM LEK17_1
GROUP BY KÓD
HAVING COUNT(*)=1;
-- szerveren egyszerûbben is megoldható:
SELECT KÓD, COUNT(distinct vezetõ) AS HÁNY_VEZ
FROM LEK17_1
GROUP BY KÓD
HAVING COUNT(*)=1;

-- 18.	Melyik munkán dolgoztak a legnagyobb létszámban?
-- a 6. lekérdezés E-tábláját használva a) megoldás:
SELECT *
FROM LEK6
WHERE LÉTSZÁM=(SELECT MAX(LÉTSZÁM) FROM LEK6);
-- vagy b) megoldás:
SELECT top 1 with ties M_SZÁM, COUNT(KÓD) AS LÉTSZÁM
FROM CSOPORT
GROUP BY M_SZÁM
ORDER BY 2 desc;

--19.	Ki rendelt munkát a legrégebben utoljára?
CREATE VIEW LEK19_1 as
SELECT MEGRENDELÕ, MAX(IND_KELT) AS UTOLSÓ
FROM MUNKA
GROUP BY MEGRENDELÕ;

SELECT *
FROM LEK19_1
WHERE UTOLSÓ=(SELECT MIN(UTOLSÓ) FROM LEK19_1);

-- esetleg: 
SELECT top 1 with ties MEGRENDELÕ, MAX(IND_KELT) AS UTOLSÓ
FROM MUNKA
GROUP BY MEGRENDELÕ
ORDER BY 2

--20.	Adott dolgozó kinek a vezetése alatt dolgozott a legtöbbször?
-- az adott dolgozókód beolvasásához a változót deklaráljuk elõbb
declare @mkód int
set @mkód=1004
SELECT top 1 with ties VEZETÕ, COUNT(*) AS HÁNYSZOR
FROM MUNKA M, CSOPORT C
WHERE M.M_SZÁM=C.M_SZÁM AND KÓD=@MKÓD
GROUP BY VEZETÕ
ORDER BY 2 desc;

-- ilyenkor 1 paraméteres, táblát visszaadó fgv. írása lenne célszerû:
create function lek20
(
@mkód int
)
returns table
as
return
(
	SELECT top 1 with ties VEZETÕ, COUNT(*) AS HÁNYSZOR
	FROM MUNKA M, CSOPORT C
	WHERE M.M_SZÁM=C.M_SZÁM AND KÓD=@MKÓD
	GROUP BY VEZETÕ
	ORDER BY 2 desc
)
-- hívása:
select * from dbo.lek20(1004)

--21.	Melyik vezetõ melyik megrendelõnek dolgozott a legnagyobb óraszámban?
-- create view lek21_1 as
SELECT VEZETÕ, MEGRENDELÕ, SUM(ÓRASZÁM) AS ÖSSZESEN
FROM MUNKA
GROUP BY VEZETÕ, MEGRENDELÕ;
-- mentve lek21_1 néven, majd abból a 2. lépésben:
SELECT *
FROM LEK21_1 AS K
WHERE ÖSSZESEN=(SELECT MAX(ÖSSZESEN) 
                                   FROM LEK21_1
                                   WHERE  VEZETÕ=K.VEZETÕ);

--22.	Nagy Péter vezetése alatt hányan [és mekkora óraszámban] dolgoztak?
-- a hányan dolgoztak vlki vezetése alatt fõtáblája a csoport, de az összesen hány órában fõtáblája nem a csoport, hanem a munka. 
-- ezért 2 lekérdezés egyesítésével:
SELECT 'FÕ:' AS SZÖVEG, COUNT(*) AS MENNYI
FROM DOLGOZÓ D, MUNKA M, CSOPORT C
WHERE D.KÓD=VEZETÕ AND M.M_SZÁM=C.M_SZÁM
AND NEVE='Nagy Péter'
UNION 
SELECT 'ÓRA:', SUM(ÓRASZÁM)
FROM DOLGOZÓ D, MUNKA M
WHERE D.KÓD=VEZETÕ 
AND NEVE='Nagy Péter';

--23.	A legrégebben itt dolgozó ember legelsõ munkája hova készült?
-- 1.lépésben a legrégebben belépõ dolgozókat kérdezzük le:
create view lek23_1 as 
SELECT kód
FROM dolgozó
WHERE belép_éve= (select MIN(BELÉP_ÉVE) FROM DOLGOZÓ);
-- 2.lépésben az elõbbi dolgozók munkái indulással és megrendelõvel:
create view lek23_2 as 
SELECT s.kód, megrendelõ, ind_kelt
FROM LEK23_1 S, CSOPORT C, MUNKA M
WHERE S.KÓD=C.KÓD AND C.M_SZÁM=M.M_SZÁM;
-- 3.lépésben minden dolgozóra a saját munkáinak a legelsõjét jelenítjük meg (amit szintén érdemes elmenteni nézetként):
create view lek23 as
SELECT m.*, kód
FROM megrendelõ m, lek23_2 ss
WHERE azon=megrendelõ and ind_kelt=(select MIN(ind_kelt) from lek23_2 where ss.kód=lek23_2.kód);

-- a végleges nézet lekérdezése: select * from lek23

-- vagy akár 1 lépésben kivitelezve:
SELECT c.kód, r.*
FROM Dolgozó D
	inner join Csoport C on D.KÓD=C.KÓD
	inner join Munka M on C.M_SZÁM=M.M_SZÁM
	inner join megrendelõ R on M.megrendelõ=R.azon
where belép_éve=(select min(belép_éve) from dolgozó)
	and ind_kelt=(select MIN(ind_kelt) from munka inner join csoport on csoport.m_szám=munka.m_szám where csoport.kód=c.kód)

--24.	Mely munkák készültek valamelyest egyidõben?
-- azaz mely munkák idõtartamának (indulástól a határidõ napjáig) van metszete:
SELECT E.M_SZÁM, M.M_SZÁM
FROM MUNKA E, MUNKA M
WHERE E.M_SZÁM<M.M_SZÁM 
and (E.ind_kelt>=M.ind_kelt and E.ind_kelt<=M.határidõ or M.ind_kelt>=E.ind_kelt and M.ind_kelt<=E.határidõ);

-- vagyis nem igaz, h nincs metszetük:
SELECT E.M_SZÁM, M.M_SZÁM
FROM MUNKA E, MUNKA M
WHERE E.M_SZÁM<M.M_SZÁM and not (E.HATÁRIDÕ<M.IND_KELT or E.IND_KELT>M.HATÁRIDÕ);

-- 25.	Ki kivel dolgozott már egy csoportban?
SELECT E.KÓD, M.KÓD
FROM CSOPORT E, CSOPORT M
WHERE E.KÓD > M.KÓD AND E.M_SZÁM = M.M_SZÁM;

--26.	Ki kinek a vezetése alatt nem dolgozott még?
-- a nevük nem fontos, csak az ellenõrzést segíti...
-- bárki bármely dolgozó vezetése alatt dolgozhatott egy munkaszámmal definiált csoportban.
-- lekérdezve a tényeket, majd azokat kihagyva az összes lehetséges párosból
create view tény as
SELECT KÓD, VEZETÕ
FROM MUNKA M, CSOPORT C
WHERE M.M_SZÁM=C.M_SZÁM;

-- a) eset: NOT IN predikátummal az összevont párost alkotó kifejezések között
SELECT D.KÓD, D.NEVE, V.KÓD, V.NEVE
FROM DOLGOZÓ D, DOLGOZÓ V
WHERE STR(D.KÓD)+STR(V.KÓD) NOT IN  (SELECT STR(KÓD)+STR(VEZETÕ)  FROM TÉNY);

-- b) eset: not exists peredikátummal, ami külsõ paraméteres alSelecttel kivitelezhetõ:
SELECT D.KÓD, D.NEVE, V.KÓD, V.NEVE
FROM DOLGOZÓ AS D, DOLGOZÓ AS V
WHERE NOT EXISTS (SELECT 1 FROM TÉNY WHERE KÓD=D.KÓD AND VEZETÕ=V.KÓD)
-- ORDER BY 1, 3;

--27.  Név szerint ki hány munkát vezetett?
-- rossz megoldás (ui. a név sohasem egyedi):
SELECT neve, COUNT(*)
FROM MUNKA, DOLGOZÓ
WHERE KÓD=VEZETÕ
GROUP BY neve;
-- helyes megoldás:
SELECT vezetõ, neve, COUNT(*)
FROM MUNKA, DOLGOZÓ
WHERE KÓD=VEZETÕ
GROUP BY vezetõ, neve;
-- elegáns megoldás (ui. a dolgozó neve függ a kódjától, nem kell dupla kontroll a csoportosításhoz):
SELECT VEZETÕ, MAX(NEVE), COUNT(*)
FROM MUNKA, DOLGOZÓ
WHERE KÓD=VEZETÕ
GROUP BY VEZETÕ;

-- megj. 
-- a természetes összekapcsolás (kapcsolatban álló táblák megfelelõ sorainak az illesztése) elfogadható 
-- a direkt szorzat összekapcsolási feltétel szerinti szûrésével: FROM gyerektábla gy, szülõtábla sz WHERE gy.külsõkulcs=sz.kulcs
-- vagy a belsõ összekapcsolással, ami korszerûbb: FROM gyerektábla gy INNER JOIN szülõtábla sz ON gy.külsõkulcs=sz.kulcs
-- de a külsõ összekapcsolás a kifejezetten hasznos, amivel a tényadatok nélküli sorok könnyen megjelenítendõk: 
-- FROM gyerektábla gy <LEFT/RIGHT> OUTER JOIN szülõtábla sz ON gy.külsõkulcs=sz.kulcs
-- pl. melyik munkán hányan fognak majd dolgozni (és a 0 is kell):
select m.m_szám, count(c.m_szám)
from csoport c right outer join munka m on c.m_szám=m.m_szám
where getdate()<ind_kelt
group by m.m_szám
-- a pl. másik megoldása a Select-be írható alSelect segítségével:
select m_szám, (select count(*) from csoport where csoport.m_szám=munka.m_szám)
from munka
--where getdate()<ind_kelt


