
-- egy taxis v�llalkoz�s aut�it tartjuk nyilv�n az aut� tulajdonos�nak �s �zemeltet�j�nek szem�lyes adataival egy�tt

create database taxis
GO

use taxis
GO

CREATE TABLE szem�ly
(
k�d int,
n�v varchar(40) NOT NULL,
ir_sz�m char(4),
helys�g varchar(30),
utca_hsz varchar(40),
PRIMARY KEY (k�d)
)

CREATE TABLE aut�
(
rend_sz�m char(7),
�vj�rat smallint NOT NULL,
m�rka char(12) not null,
tulaj int not null,
�zem int not null,
PRIMARY KEY (rend_sz�m),
Foreign key (tulaj) references Szem�ly (k�d),
Foreign key (�zem) references Szem�ly (k�d)
)

insert into szem�ly values (1, 'Walaki', '1111', 'Budapest', null)
insert into szem�ly values (2, 'Valaki', '1221', 'Budapest', null)
insert into szem�ly values (3, 'm�s vlki', '1031', 'Budapest', null)
insert into szem�ly values (4, 'XY', '2211', 'V�c', null)
insert into szem�ly values (5, 'Z�', '1034', 'Budapest', null)
insert into szem�ly values (6, 'Korm �nyos', '6221', 'P�cs', null)

insert into aut� values ('ABC-123', 1999, 'BMW', 1, 1)
insert into aut� values ('CBA-321', 2001, 'Audi', 2, 2)
insert into aut� values ('EFG-456', 2010, 'Opel', 2, 3)
insert into aut� values ('HIJ-789', 2014, 'BMW', 2, 4)
insert into aut� values ('KLM-999', 2014, 'Suzuki', 5, 5)
insert into aut� values ('SQL-555', 2020, 'Audi', 1, 2)


-- Jelenjen meg az aut�k minden adata (a p�rhuzamos kapcsolatok alapj�n el�rve a szem. adatokat)
select aut�.*, tulajdonos.*, uzemelteto.*
from aut� 
	inner join szem�ly Tulajdonos on tulaj=tulajdonos.k�d 
	inner join szem�ly Uzemelteto on �zem=uzemelteto.k�d


--H�ny darab legfeljebb 3 �ves aut� van az egyes m�rk�kb�l?
SELECT m�rka, count(rend_sz�m) AS sz�ml�l�
FROM aut�
WHERE year(getdate())-�vj�rat <= 3
GROUP BY m�rka;

--N�v szerint ki a tulajdonosa a leg�regebb BMW aut�nak?
SELECT n�v
FROM AUT�, SZEM�LY
WHERE tulaj=k�d
and m�rka='BMW' and �vj�rat=(select min(�vj�rat) from aut� where m�rka='BMW');
-- vagy 
SELECT n�v
FROM AUT� inner join SZEM�LY on tulaj=k�d
and m�rka='BMW' and �vj�rat=(select min(�vj�rat) from aut� where m�rka='BMW');

--Ki nem �zemeltet egy aut�t sem?
SELECT *
FROM szem�ly
WHERE k�d not in (select �zem from aut�);
-- vagy
SELECT k�d FROM szem�ly
except 
select �zem from aut�;

--Mennyi a budapesti tulajdonban l�v� aut�k �vj�rat�nak als�-fels� hat�ra?
SELECT min(�vj�rat) AS als�, max(�vj�rat) AS fels�
FROM aut� INNER JOIN szem�ly ON tulaj=k�d 
WHERE helys�g='Budapest';

--Ki �zemelteti a legt�bb aut�t?
SELECT top 1 with ties �zem, count(*) AS h�ny
FROM aut�
GROUP BY �zem
order by 2 desc
-- esetleg:
SELECT �zem, count(*) AS h�ny
FROM aut�
GROUP BY �zem
HAVING count(*)=(select max(B.h�ny) from (SELECT count(*) AS h�ny FROM aut� GROUP BY �zem) B)

-- Kik azok a tulajdonosok, akik kiz�r�lag a saj�t aut�jukat �zemeltetik?
SELECT *
FROM szem�ly
WHERE k�d IN  (select tulaj from aut� where tulaj=�zem)
and k�d not in (SELECT �zem from aut� where tulaj<>�zem);
-- vagy 
select tulaj from aut� 
where tulaj=�zem and tulaj not in (SELECT �zem from aut� where tulaj<>�zem);
-- vagy
select tulaj from aut� where tulaj=�zem
except
SELECT �zem from aut� where tulaj<>�zem;





