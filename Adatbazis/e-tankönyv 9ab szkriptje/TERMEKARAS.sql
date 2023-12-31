-- 2020 jan. 2-án nyitó bolt termékárainak a nyomonkövetése 3 verzióban

-- ÁR0: rosszul kezelhető, ui. több megszorítással ellenőrizhető, h minden terméknek minden nap legyen ára, de pont 1 ára legyen
-- ÁR: a sávosan tárolt árváltozások táblája
-- VÁLT: csak a változások naplózása történik, de ekkor az akt_ár kötelezően ott kell legyen a Termék-törzsben


--CREATE DATABASE Termékáras
--GO

--USE Termékáras
--GO


CREATE TABLE TERMÉK
(
	tkód int IDENTITY(101,1),
	elnev char(30) NOT NULL,
	akt_ár money NOT NULL,
 PRIMARY KEY (tkód)
 )

CREATE TABLE ÁR0 
(
	termék int,
	dtól date,
	dig date,
	ár money NOT NULL,
 PRIMARY KEY (termék, dtól)
 )

CREATE TABLE ÁR
(
	termék int,
	dtól date,
	új_ár money NULL,
PRIMARY KEY (termék, dtól)
)

CREATE TABLE VÁLT
(
	termék int,
	dig date,
	régi_ár money NOT NULL,
 PRIMARY KEY (termék, dig)
 ) 
 

-- kapcsolatok
ALTER TABLE ÁR
ADD FOREIGN KEY(termék) REFERENCES TERMÉK (tkód)

ALTER TABLE ÁR0
ADD FOREIGN KEY(termék) REFERENCES TERMÉK (tkód)

ALTER TABLE VÁLT  
ADD  FOREIGN KEY(termék) REFERENCES TERMÉK (tkód)


-- tesztadatok (a 3 verzió eseményei szinkronban vannak)
-- 1 terméknek már a 4. ára van, 1-nek a 2. és 3-nak az első, a nyitóára érvényes még mindig 

SET IDENTITY_INSERT TERMÉK ON 
INSERT TERMÉK (tkód, elnev, akt_ár) VALUES (101, N'szánkó                        ', 2000.0000)
INSERT TERMÉK (tkód, elnev, akt_ár) VALUES (103, N'korcsolya                     ', 3000.0000)
INSERT TERMÉK (tkód, elnev, akt_ár) VALUES (104, N'sál                           ', 2000.0000)
INSERT TERMÉK (tkód, elnev, akt_ár) VALUES (105, N'kesztyű                       ', 1100.0000)
INSERT TERMÉK (tkód, elnev, akt_ár) VALUES (106, N'kabát                         ', 9500.0000)
SET IDENTITY_INSERT TERMÉK OFF

INSERT ÁR0 VALUES (101, '20200102', '20200331', 1500.0000)
INSERT ÁR0 VALUES (101, '20200401', '20200407', 1000.0000)
INSERT ÁR0 VALUES (101, '20200408', '20200501', 1500.0000)
INSERT ÁR0 VALUES (101, '20200502', NULL, 2000.0000)
INSERT ÁR0 VALUES (103, '20200102', '20200501', 2500.0000)
INSERT ÁR0 VALUES (103, '20200502', NULL, 3000.0000)
INSERT ÁR0 VALUES (104, '20200102', NULL, 2000.0000)
INSERT ÁR0 VALUES (105, '20200102', NULL, 1100.0000)
INSERT ÁR0 VALUES (106, '20200102', NULL, 9500.0000)

INSERT ÁR VALUES (101, '20200102', 1500.0000)
INSERT ÁR VALUES (101, '20200401', 1000.0000)
INSERT ÁR VALUES (101, '20200408', 1500.0000)
INSERT ÁR VALUES (101, '20200502', 2000.0000)
INSERT ÁR VALUES (103, '20200102', 2500.0000)
INSERT ÁR VALUES (103, '20200502', 3000.0000)
INSERT ÁR VALUES (104, '20200102', 2000.0000)
INSERT ÁR VALUES (105, '20200102', 1100.0000)
INSERT ÁR VALUES (106, '20200102', 9500.0000)

INSERT VÁLT VALUES (101, '20200331', 1500.0000)
INSERT VÁLT VALUES (101, '20200407', 1000.0000)
INSERT VÁLT VALUES (101, '20200501', 1500.0000)
INSERT VÁLT VALUES (103, '20200501', 2500.0000)


-- a 3 verzóban elkészített hasznos nézet:
go
create view árlista0
as
select * from ár0 
go

create view árlista1
as 
-- az ÁRból egy teljes árlista
select	termék, 
		dtól, 
		(select dateadd(day, -1,MIN(dtól)) from ár where termék=K.termék and dtól>K.dtól ) as dig,	
		új_ár
from ÁR K
go

create view árlista2
as
-- a VÁLTból egy teljes árlista (a legfrissebb meddig-ek a mai nappal vannak kitöltve)
select	termék, 
		(select isnull(dateadd(day, +1,MAX(dig)), '20200102') from vált where termék=K.termék and dig<K.dig ) as dtól,	
		dig,
		régi_ár as ár
from VÁLT K
UNION
select tkód, '20200102', cast(getdate() as date), akt_ár
from termék
where tkód NOT IN (select termék from vált)
UNION
select tkód, (select dateadd(day,+1,max(dig)) from vált where termék=tkód), cast(getdate() as date), akt_ár
from termék
where  tkód IN (select termék from vált)

go

-- a 3 verzióban elkészített hasznos függvény (2 verzióban a hasznos nézetet is felhasználva):

CREATE function termékára0
-- az ÁR0 táblából való keresés: adott termék adott napon mennyibe kerül
(
	@termék int,
	@mikor date
)
returns money
as
begin
	-- return (select ár from ÁR0 where termék=@termék and dtól<=@mikor and dig>=@mikor)
	return (select ár from ÁR0 where termék=@termék and @mikor between dtól and isnull(dig, getdate()))

end
--select dbo.termékára0(101,'20200217')

go

CREATE function termékára1
-- az ÁR táblából való keresés helyett a kényelmes nézetből: adott termék adott napon mennyibe kerül
(
	@termék int,
	@mikor date
)
returns money
as
begin
	
	return (select új_ár from árlista1 where termék=@termék and @mikor between dtól and isnull(dig, getdate()))

end
--select dbo.termékára1(101,'20200217')

go

CREATE function termékára11
-- az ÁR táblából való keresés: adott termék adott napon mennyibe kerül
(
	@termék int,
	@mikor date
)
returns money
as
begin
	declare @datum date
	select @datum=MAX(dtól) from ÁR where termék=@termék and dtól<=@mikor
	return (select új_ár from ÁR where termék=@termék and dtól=@datum)

end
 --select dbo.termékára11(101,'20200217')

go
CREATE function termékára2
-- a VÁLT táblából való keresés helyett a kényelmes nézetből: adott termék adott napon mennyibe kerül
(
	@termék int,
	@mikor date
)
returns money
as
begin
	return (select ár from ÁRlista2 where termék=@termék and @mikor between dtól and dig)

end
 --select dbo.termékára2(101,'20200217')
go

CREATE function termékára22
-- a VÁLT táblás esetben való keresés: adott termék adott napon mennyibe kerül
(
	@termék int,
	@mikor date
)
returns money
as
begin
	declare @dátum date, @vissza money
	select @dátum=MIN(dig) from vált where termék=@termék and @mikor<=dig 
	if @dátum is not null
		select @vissza=régi_ár from VÁLT where termék=@termék and @dátum=dig
	else
		select @vissza=akt_ár from termék where tkód=@termék
	-- az if vége...
	return @vissza
end
 --select dbo.termékára22(101,'20200217')

go


