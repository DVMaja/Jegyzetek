
-- egy taxis vállalkozás autóit tartjuk nyilván az autó tulajdonosának és üzemeltetõjének személyes adataival együtt

create database taxis
GO

use taxis
GO

CREATE TABLE személy
(
kód int,
név varchar(40) NOT NULL,
ir_szám char(4),
helység varchar(30),
utca_hsz varchar(40),
PRIMARY KEY (kód)
)

CREATE TABLE autó
(
rend_szám char(7),
évjárat smallint NOT NULL,
márka char(12) not null,
tulaj int not null,
üzem int not null,
PRIMARY KEY (rend_szám),
Foreign key (tulaj) references Személy (kód),
Foreign key (üzem) references Személy (kód)
)

insert into személy values (1, 'Walaki', '1111', 'Budapest', null)
insert into személy values (2, 'Valaki', '1221', 'Budapest', null)
insert into személy values (3, 'más vlki', '1031', 'Budapest', null)
insert into személy values (4, 'XY', '2211', 'Vác', null)
insert into személy values (5, 'Zé', '1034', 'Budapest', null)
insert into személy values (6, 'Korm Ányos', '6221', 'Pécs', null)

insert into autó values ('ABC-123', 1999, 'BMW', 1, 1)
insert into autó values ('CBA-321', 2001, 'Audi', 2, 2)
insert into autó values ('EFG-456', 2010, 'Opel', 2, 3)
insert into autó values ('HIJ-789', 2014, 'BMW', 2, 4)
insert into autó values ('KLM-999', 2014, 'Suzuki', 5, 5)
insert into autó values ('SQL-555', 2020, 'Audi', 1, 2)


-- Jelenjen meg az autók minden adata (a párhuzamos kapcsolatok alapján elérve a szem. adatokat)
select autó.*, tulajdonos.*, uzemelteto.*
from autó 
	inner join személy Tulajdonos on tulaj=tulajdonos.kód 
	inner join személy Uzemelteto on üzem=uzemelteto.kód


--Hány darab legfeljebb 3 éves autó van az egyes márkákból?
SELECT márka, count(rend_szám) AS számláló
FROM autó
WHERE year(getdate())-évjárat <= 3
GROUP BY márka;

--Név szerint ki a tulajdonosa a legöregebb BMW autónak?
SELECT név
FROM AUTÓ, SZEMÉLY
WHERE tulaj=kód
and márka='BMW' and évjárat=(select min(évjárat) from autó where márka='BMW');
-- vagy 
SELECT név
FROM AUTÓ inner join SZEMÉLY on tulaj=kód
and márka='BMW' and évjárat=(select min(évjárat) from autó where márka='BMW');

--Ki nem üzemeltet egy autót sem?
SELECT *
FROM személy
WHERE kód not in (select üzem from autó);
-- vagy
SELECT kód FROM személy
except 
select üzem from autó;

--Mennyi a budapesti tulajdonban lévõ autók évjáratának alsó-felsõ határa?
SELECT min(évjárat) AS alsó, max(évjárat) AS felsõ
FROM autó INNER JOIN személy ON tulaj=kód 
WHERE helység='Budapest';

--Ki üzemelteti a legtöbb autót?
SELECT top 1 with ties üzem, count(*) AS hány
FROM autó
GROUP BY üzem
order by 2 desc
-- esetleg:
SELECT üzem, count(*) AS hány
FROM autó
GROUP BY üzem
HAVING count(*)=(select max(B.hány) from (SELECT count(*) AS hány FROM autó GROUP BY üzem) B)

-- Kik azok a tulajdonosok, akik kizárólag a saját autójukat üzemeltetik?
SELECT *
FROM személy
WHERE kód IN  (select tulaj from autó where tulaj=üzem)
and kód not in (SELECT üzem from autó where tulaj<>üzem);
-- vagy 
select tulaj from autó 
where tulaj=üzem and tulaj not in (SELECT üzem from autó where tulaj<>üzem);
-- vagy
select tulaj from autó where tulaj=üzem
except
SELECT üzem from autó where tulaj<>üzem;





