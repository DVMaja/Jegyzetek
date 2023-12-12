
--- 4 t�bl�s Munka ab. l�trehoz�sa
create database munka
go

use munka
go

create table megrendel�
(
azon integer,
n�v varchar(40),
ir_sz�m char(4),
helys�g varchar(30),
utca_hsz varchar(40),
telefon char(12),
primary key (azon)
)
go


create table dolgoz�
(
k�d integer IDENTITY(1001,1),
neve varchar(40),
bel�p_�ve smallint,
sz�l_�ve smallint,
primary key (k�d)
)
go

create table munka
(
m_sz�m char(9),
megrendel� int,
vezet� int,
�rasz�m smallint,
�rad�j money,
elnevez�s varchar(40),
ind_kelt date,
hat�rid� date,
primary key (m_sz�m)
)
go

create table csoport
(
m_sz�m char(9),
k�d int,
primary key (m_sz�m, k�d)
)
go


alter table munka
add foreign key (megrendel�) references Megrendel� (azon)
alter table munka
add foreign key (vezet�) references Dolgoz� (k�d)
go

alter table csoport
add foreign key (m_sz�m) references Munka (m_sz�m)
alter table csoport
add foreign key (k�d) references Dolgoz� (k�d)
go

--- adatok
insert into megrendel� values 
(1,'Kincskeres� Rt.','2121', 'Budapest', 'F� u. 22.', null),
(2,'ABC Kft.','6767', 'P�cs', null, null),
(3,'Kov�cs �s tsa BT','1212', 'Budapest', 'Tej�t u. 122.', null)
go

insert into dolgoz� (neve, bel�p_�ve, sz�l_�ve) values 
('Feh�r M�ria', 1998, 1960),
('Fekete �d�m', 2001, 1979),
('Brassai Istv�n', 1998, 1976),
('Kiss P�ter', 2001, 1970),
('Nagy P�ter', 2010, 1980),
('Nagy P�l', 2010, 1988),
('Varga �va', 2005, 1990)
go

insert into munka values 
('2003/123',2, 1003, 30, 4500, 'weboldal m�dos�t�s', '20030105', '20040206'),
('2003/125',1, 1005, 120, 8000, 'betan�t�s', '20030120', '20030130'),
('2003/203',1, 1005, 15, 6000, 'tananyag fejleszt�s', '20030120', '20040206'),
('2003/204',2, 1007, 120, 5000, 'lek�rdez�sek', '20031123', '20031218'),
('2003/111',3, 1005, 25, 8000, 'szak�rt�s', '20040120', '20040206')
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


-- Lek�rdez�sek
--1.	H�ny munka k�sz�lt P�csre?
SELECT COUNT(*) AS H�NY
FROM MUNKA
WHERE MEGRENDEL� IN (SELECT AZON FROM megrendel� WHERE HELYS�G Like '%P�cs%');
--vagy
SELECT COUNT(*) AS H�NY
FROM megrendel�, MUNKA
WHERE MEGRENDEL�=AZON And HELYS�G Like '%P�cs%';

--2.	Ma kiknek j�r le a hat�ridej�k?
SELECT  VEZET� AS K�D
FROM MUNKA
WHERE HAT�RID�=getdate()
UNION 
SELECT K�D
FROM MUNKA, CSOPORT
WHERE MUNKA.M_SZ�M=CSOPORT.M_SZ�M And HAT�RID�=getdate();

--3.	Nagy P�l milyen munk�kban vett r�szt az elm�lt �vben?
SELECT M.M_SZ�M
FROM CSOPORT C, DOLGOZ� D, MUNKA M
WHERE C.K�D=D.K�D And C.M_SZ�M=M.M_SZ�M And NEVE='Nagy P�l' And YEAR(IND_KELT)=YEAR(GETDATE())-1;

--4.	Az egyes munk�k h�ny napig tartanak?
SELECT M_SZ�M, datediff(day, IND_KELT, HAT�RID�) AS NAPOS
FROM MUNKA;

--5.	Naponta h�ny munka indult el eddig?
SELECT IND_KELT, COUNT(*) as ennyi
FROM MUNKA
WHERE ind_kelt<getdate()
GROUP BY IND_KELT;

--6.	Csoportl�tsz�mok
SELECT M_SZ�M, COUNT(K�D) AS L�TSZ�M
FROM CSOPORT
GROUP BY M_SZ�M;

--7.	Az egyes csoportok �tlag�letkora?
SELECT M_SZ�M, AVG(YEAR(getdate())-SZ�L_�VE) AS �TLAGKOR
FROM DOLGOZ� D, CSOPORT C
WHERE D.K�D=C.K�D
GROUP BY M_SZ�M;
-- pontosabban nem id�n, hanem a munk�k indul�s�nak �v�ben:
SELECT c.M_SZ�M, AVG(YEAR(ind_kelt)-SZ�L_�VE) AS �TLAGKOR
FROM DOLGOZ� D, CSOPORT C, MUNKA M
WHERE D.K�D=C.K�D and M.m_sz�m=C.m_sz�m
GROUP BY c.M_SZ�M;

-- 8.	�rbev�telek megrendel�nk�nt?
SELECT MEGRENDEL�, SUM(�RAD�J*�RASZ�M) as �rbev
FROM MUNKA
GROUP BY MEGRENDEL�;

--9.	Munka�r�k �sszege vezet�nk�nt?
SELECT VEZET�, SUM(�RASZ�M) as �ssz�ra
FROM MUNKA
GROUP BY VEZET�;

--10.	A legnagyobb �rasz�m� munka?
SELECT *
FROM MUNKA
WHERE �RASZ�M = (SELECT MAX(�RASZ�M) FROM MUNKA);
-- vagy a megfelel� rendez�st k�vet� holtverseny kezel�s�vel
SELECT top 1 with ties *
FROM MUNKA
order by �RASZ�M desc;

--11.	A legr�videbb hat�ridej� munka?
SELECT *, datediff(day, IND_KELT, HAT�RID�) AS NAPOS
FROM MUNKA
WHERE datediff(day, IND_KELT, HAT�RID�)=(SELECT MIN(datediff(day, IND_KELT, HAT�RID�)) FROM MUNKA);
-- 2 d�tum k�l�nbs�ge �jra haszn�lhat�, ami alap�rtelmezetten napokban adja vissza az eltelt id�t:
SELECT *, HAT�RID�-IND_KELT AS NAPOS 
FROM MUNKA
WHERE HAT�RID�-IND_KELT=(SELECT MIN(HAT�RID�-IND_KELT) FROM MUNKA);

--12.	Kik dolgoztak a legnagyobb �rad�jas munk�n?
SELECT DISTINCT K�D
FROM MUNKA M, CSOPORT C
WHERE M.M_SZ�M=C.M_SZ�M 
AND
�RAD�J=(SELECT  MAX(�RAD�J)  FROM MUNKA);
-- ha n�v szerint k�rik, kik azok:
SELECT DISTINCT c.k�d, neve
FROM MUNKA M, CSOPORT C, dolgoz� d
WHERE M.M_SZ�M=C.M_SZ�M and d.k�d=c.k�d
AND
�RAD�J=(SELECT  MAX(�RAD�J)  FROM MUNKA);

--13.	Hova k�sz�lt a legkisebb �rad�jas munka?
SELECT ir_sz�m, helys�g, utca_hsz
FROM MEGRENDEL�, MUNKA
WHERE MEGRENDEL�=AZON
AND �RAD�J = (SELECT MIN(�RAD�J) FROM MUNKA);
-- vagy
SELECT *
FROM MEGRENDEL�
WHERE AZON IN (SELECT MEGRENDEL� FROM MUNKA WHERE  �RAD�J = (SELECT MIN(�RAD�J) FROM MUNKA));

--14.	Ki nem volt m�g soha vezet�?
SELECT *
FROM DOLGOZ�
WHERE K�D not IN (SELECT VEZET� FROM MUNKA);
-- esetleg t�rzsadatok n�lk�l megv�laszolva, halmazm�veleti k�l�nbs�g seg�ts�g�vel
SELECT k�d FROM DOLGOZ�
except
SELECT VEZET� FROM MUNKA;

--15.	Ki dolgozott eddig csak vezet�k�nt?
SELECT *
FROM DOLGOZ�
WHERE K�D  in (SELECT VEZET� FROM MUNKA)
AND K�D NOT IN (SELECT K�D FROM CSOPORT);

--16.	Melyik munk�n dolgozott egy�tt Kiss P�ter �s Nagy P�l?
SELECT M_SZ�M
FROM CSOPORT AS C, DOLGOZ� AS D
WHERE C.K�D=D.K�D And NEVE='Kiss P�ter';
-- a lek�rdez�s mentve m_KP n�ven
SELECT M_SZ�M
FROM CSOPORT AS C, DOLGOZ� AS D
WHERE C.K�D=D.K�D And NEVE='Nagy P�l';
-- a lek�rdez�s mentve m_NP n�ven
-- 3. l�p�sben a 2 E-t�bl�t �sszekapcsoljuk:
SELECT *
FROM m_KP, m_NP
WHERE m_KP.m_sz�m=m_NP.m_sz�m;

-- ilyenkor a 2 E-t�bla k�zvetlen�l k�sz�l el a 3. lek�rdez�s Fromj�ban, teh�t �gy is megval�s�that�:
SELECT * -- a k�z�s m_sz�mok egyik�t el�g ki�rni
FROM 
	(SELECT M_SZ�M
	FROM CSOPORT AS C, DOLGOZ� AS D
	WHERE C.K�D=D.K�D And NEVE='Kiss P�ter') m_KP, 
	(SELECT M_SZ�M
	FROM CSOPORT AS C, DOLGOZ� AS D
	WHERE C.K�D=D.K�D And NEVE='Nagy P�l') m_NP
WHERE m_KP.m_sz�m=m_NP.m_sz�m;

-- figyelem: b�rmely szerveren n�zetk�nt menthet�k a lek�rdez�sek! pl.
	CREATE VIEW m_KP
	as 
	SELECT M_SZ�M
	FROM CSOPORT C, DOLGOZ� D
	WHERE C.K�D=D.K�D And NEVE='Kiss P�ter';
go

--17.	Kik dolgoztak eddig csak egyetlen vezet� alatt?
create view lek17_1 as
SELECT DISTINCT K�D, VEZET�
FROM munka M, csoport C
WHERE M.M_SZ�M=C.M_SZ�M;
-- mentve lek17_1 n�ven
SELECT K�D, COUNT(*) AS H�NY_VEZ
FROM LEK17_1
GROUP BY K�D
HAVING COUNT(*)=1;
-- szerveren egyszer�bben is megoldhat�:
SELECT K�D, COUNT(distinct vezet�) AS H�NY_VEZ
FROM LEK17_1
GROUP BY K�D
HAVING COUNT(*)=1;

-- 18.	Melyik munk�n dolgoztak a legnagyobb l�tsz�mban?
-- a 6. lek�rdez�s E-t�bl�j�t haszn�lva a) megold�s:
SELECT *
FROM LEK6
WHERE L�TSZ�M=(SELECT MAX(L�TSZ�M) FROM LEK6);
-- vagy b) megold�s:
SELECT top 1 with ties M_SZ�M, COUNT(K�D) AS L�TSZ�M
FROM CSOPORT
GROUP BY M_SZ�M
ORDER BY 2 desc;

--19.	Ki rendelt munk�t a legr�gebben utolj�ra?
CREATE VIEW LEK19_1 as
SELECT MEGRENDEL�, MAX(IND_KELT) AS UTOLS�
FROM MUNKA
GROUP BY MEGRENDEL�;

SELECT *
FROM LEK19_1
WHERE UTOLS�=(SELECT MIN(UTOLS�) FROM LEK19_1);

-- esetleg: 
SELECT top 1 with ties MEGRENDEL�, MAX(IND_KELT) AS UTOLS�
FROM MUNKA
GROUP BY MEGRENDEL�
ORDER BY 2

--20.	Adott dolgoz� kinek a vezet�se alatt dolgozott a legt�bbsz�r?
-- az adott dolgoz�k�d beolvas�s�hoz a v�ltoz�t deklar�ljuk el�bb
declare @mk�d int
set @mk�d=1004
SELECT top 1 with ties VEZET�, COUNT(*) AS H�NYSZOR
FROM MUNKA M, CSOPORT C
WHERE M.M_SZ�M=C.M_SZ�M AND K�D=@MK�D
GROUP BY VEZET�
ORDER BY 2 desc;

-- ilyenkor 1 param�teres, t�bl�t visszaad� fgv. �r�sa lenne c�lszer�:
create function lek20
(
@mk�d int
)
returns table
as
return
(
	SELECT top 1 with ties VEZET�, COUNT(*) AS H�NYSZOR
	FROM MUNKA M, CSOPORT C
	WHERE M.M_SZ�M=C.M_SZ�M AND K�D=@MK�D
	GROUP BY VEZET�
	ORDER BY 2 desc
)
-- h�v�sa:
select * from dbo.lek20(1004)

--21.	Melyik vezet� melyik megrendel�nek dolgozott a legnagyobb �rasz�mban?
-- create view lek21_1 as
SELECT VEZET�, MEGRENDEL�, SUM(�RASZ�M) AS �SSZESEN
FROM MUNKA
GROUP BY VEZET�, MEGRENDEL�;
-- mentve lek21_1 n�ven, majd abb�l a 2. l�p�sben:
SELECT *
FROM LEK21_1 AS K
WHERE �SSZESEN=(SELECT MAX(�SSZESEN) 
                                   FROM LEK21_1
                                   WHERE  VEZET�=K.VEZET�);

--22.	Nagy P�ter vezet�se alatt h�nyan [�s mekkora �rasz�mban] dolgoztak?
-- a h�nyan dolgoztak vlki vezet�se alatt f�t�bl�ja a csoport, de az �sszesen h�ny �r�ban f�t�bl�ja nem a csoport, hanem a munka. 
-- ez�rt 2 lek�rdez�s egyes�t�s�vel:
SELECT 'F�:' AS SZ�VEG, COUNT(*) AS MENNYI
FROM DOLGOZ� D, MUNKA M, CSOPORT C
WHERE D.K�D=VEZET� AND M.M_SZ�M=C.M_SZ�M
AND NEVE='Nagy P�ter'
UNION 
SELECT '�RA:', SUM(�RASZ�M)
FROM DOLGOZ� D, MUNKA M
WHERE D.K�D=VEZET� 
AND NEVE='Nagy P�ter';

--23.	A legr�gebben itt dolgoz� ember legels� munk�ja hova k�sz�lt?
-- 1.l�p�sben a legr�gebben bel�p� dolgoz�kat k�rdezz�k le:
create view lek23_1 as 
SELECT k�d
FROM dolgoz�
WHERE bel�p_�ve= (select MIN(BEL�P_�VE) FROM DOLGOZ�);
-- 2.l�p�sben az el�bbi dolgoz�k munk�i indul�ssal �s megrendel�vel:
create view lek23_2 as 
SELECT s.k�d, megrendel�, ind_kelt
FROM LEK23_1 S, CSOPORT C, MUNKA M
WHERE S.K�D=C.K�D AND C.M_SZ�M=M.M_SZ�M;
-- 3.l�p�sben minden dolgoz�ra a saj�t munk�inak a legels�j�t jelen�tj�k meg (amit szint�n �rdemes elmenteni n�zetk�nt):
create view lek23 as
SELECT m.*, k�d
FROM megrendel� m, lek23_2 ss
WHERE azon=megrendel� and ind_kelt=(select MIN(ind_kelt) from lek23_2 where ss.k�d=lek23_2.k�d);

-- a v�gleges n�zet lek�rdez�se: select * from lek23

-- vagy ak�r 1 l�p�sben kivitelezve:
SELECT c.k�d, r.*
FROM Dolgoz� D
	inner join Csoport C on D.K�D=C.K�D
	inner join Munka M on C.M_SZ�M=M.M_SZ�M
	inner join megrendel� R on M.megrendel�=R.azon
where bel�p_�ve=(select min(bel�p_�ve) from dolgoz�)
	and ind_kelt=(select MIN(ind_kelt) from munka inner join csoport on csoport.m_sz�m=munka.m_sz�m where csoport.k�d=c.k�d)

--24.	Mely munk�k k�sz�ltek valamelyest egyid�ben?
-- azaz mely munk�k id�tartam�nak (indul�st�l a hat�rid� napj�ig) van metszete:
SELECT E.M_SZ�M, M.M_SZ�M
FROM MUNKA E, MUNKA M
WHERE E.M_SZ�M<M.M_SZ�M 
and (E.ind_kelt>=M.ind_kelt and E.ind_kelt<=M.hat�rid� or M.ind_kelt>=E.ind_kelt and M.ind_kelt<=E.hat�rid�);

-- vagyis nem igaz, h nincs metszet�k:
SELECT E.M_SZ�M, M.M_SZ�M
FROM MUNKA E, MUNKA M
WHERE E.M_SZ�M<M.M_SZ�M and not (E.HAT�RID�<M.IND_KELT or E.IND_KELT>M.HAT�RID�);

-- 25.	Ki kivel dolgozott m�r egy csoportban?
SELECT E.K�D, M.K�D
FROM CSOPORT E, CSOPORT M
WHERE E.K�D > M.K�D AND E.M_SZ�M = M.M_SZ�M;

--26.	Ki kinek a vezet�se alatt nem dolgozott m�g?
-- a nev�k nem fontos, csak az ellen�rz�st seg�ti...
-- b�rki b�rmely dolgoz� vezet�se alatt dolgozhatott egy munkasz�mmal defini�lt csoportban.
-- lek�rdezve a t�nyeket, majd azokat kihagyva az �sszes lehets�ges p�rosb�l
create view t�ny as
SELECT K�D, VEZET�
FROM MUNKA M, CSOPORT C
WHERE M.M_SZ�M=C.M_SZ�M;

-- a) eset: NOT IN predik�tummal az �sszevont p�rost alkot� kifejez�sek k�z�tt
SELECT D.K�D, D.NEVE, V.K�D, V.NEVE
FROM DOLGOZ� D, DOLGOZ� V
WHERE STR(D.K�D)+STR(V.K�D) NOT IN  (SELECT STR(K�D)+STR(VEZET�)  FROM T�NY);

-- b) eset: not exists peredik�tummal, ami k�ls� param�teres alSelecttel kivitelezhet�:
SELECT D.K�D, D.NEVE, V.K�D, V.NEVE
FROM DOLGOZ� AS D, DOLGOZ� AS V
WHERE NOT EXISTS (SELECT 1 FROM T�NY WHERE K�D=D.K�D AND VEZET�=V.K�D)
-- ORDER BY 1, 3;

--27.  N�v szerint ki h�ny munk�t vezetett?
-- rossz megold�s (ui. a n�v sohasem egyedi):
SELECT neve, COUNT(*)
FROM MUNKA, DOLGOZ�
WHERE K�D=VEZET�
GROUP BY neve;
-- helyes megold�s:
SELECT vezet�, neve, COUNT(*)
FROM MUNKA, DOLGOZ�
WHERE K�D=VEZET�
GROUP BY vezet�, neve;
-- eleg�ns megold�s (ui. a dolgoz� neve f�gg a k�dj�t�l, nem kell dupla kontroll a csoportos�t�shoz):
SELECT VEZET�, MAX(NEVE), COUNT(*)
FROM MUNKA, DOLGOZ�
WHERE K�D=VEZET�
GROUP BY VEZET�;

-- megj. 
-- a term�szetes �sszekapcsol�s (kapcsolatban �ll� t�bl�k megfelel� sorainak az illeszt�se) elfogadhat� 
-- a direkt szorzat �sszekapcsol�si felt�tel szerinti sz�r�s�vel: FROM gyerekt�bla gy, sz�l�t�bla sz WHERE gy.k�ls�kulcs=sz.kulcs
-- vagy a bels� �sszekapcsol�ssal, ami korszer�bb: FROM gyerekt�bla gy INNER JOIN sz�l�t�bla sz ON gy.k�ls�kulcs=sz.kulcs
-- de a k�ls� �sszekapcsol�s a kifejezetten hasznos, amivel a t�nyadatok n�lk�li sorok k�nnyen megjelen�tend�k: 
-- FROM gyerekt�bla gy <LEFT/RIGHT> OUTER JOIN sz�l�t�bla sz ON gy.k�ls�kulcs=sz.kulcs
-- pl. melyik munk�n h�nyan fognak majd dolgozni (�s a 0 is kell):
select m.m_sz�m, count(c.m_sz�m)
from csoport c right outer join munka m on c.m_sz�m=m.m_sz�m
where getdate()<ind_kelt
group by m.m_sz�m
-- a pl. m�sik megold�sa a Select-be �rhat� alSelect seg�ts�g�vel:
select m_sz�m, (select count(*) from csoport where csoport.m_sz�m=munka.m_sz�m)
from munka
--where getdate()<ind_kelt


