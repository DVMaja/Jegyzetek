--use DALOKJO
create function megjelenhet
(
@dal int,
@datum date
)
returns bit
begin
	declare @ret bit = 0
	declare @keletkezes date = (select keletkezes from dal where azon = @dal)
	if (select min(datum) from megjelent where datum=@datum and dal=@dal) >= @keletkezes
			set @ret = 1
return @ret
end
go

select *, dbo.megjelenhet(dal, datum) from megjelent


go
create function eredeti
(
@azon int
)
returns bit

begin
	declare @ret bit=0
	-- set @ret=0
	if (select eredeti from dal where azon=@azon) is null
		set @ret=1
	return @ret

end

select *, dbo.eredeti(azon) from dal

alter table dal
add check (dbo.eredeti(eredeti)=1)

go

create function jelzese
(
@kod int
)
returns char(1)
begin
	return (select jelzes from szem_egy where kod=@kod)
end

-- select *, dbo.jelzese(kod) from szem_egy

alter table tagja
add check (dbo.jelzese(egyuttes)='E')

alter table tagja
add check (dbo.jelzese(szemely)='S')

go
create function jogdijas
(
@szerep int
)
returns bit
begin
	return(select jogdijas  from szerep where id = @szerep)
end

go
--select dbo.jogdijas(51)

alter table alkotja 
add check(dbo.jelzese(szemely) = 'S')
-- a megszor. felt.: ha jogdíjas a szerep, akkor eredeti a dal
-- a felt. standard log. mûveletekkel: nem jogdíjas vagy eredetei
alter table alkotja 
add check(dbo.jogdijas(szerep) = 0 or dbo.eredeti(dal) = 1)

go
alter function alkothatta
(
@szerzo int,
@dal int
)
returns bit
begin
declare @ret bit = 0
declare @keletkezes date = (select keletkezes from dal where azon = @dal)
if (select kezd_ev from szem_egy where kod = @szerzo) <= year(@keletkezes)
and isnull((select vege_ev from szem_egy where kod = @szerzo), year(GETDATE())) >= year(@keletkezes)
set @ret = 1
return @ret
end
select * from dbo.alkothatta


alter table alkotja
add check (dbo.alkothatta(szemely, dal)=1)

--ki volt ott személyesen
go
create view szemelyesen as

select dal, szemely -- az elõadó együttes tagjai...
from eloadja 
	inner join tagja on szem_egy=egyuttes
	inner join dal on dal=azon
where keletkezes between datumtol and isnull(datumig, getdate())
UNION all
select dal, szem_egy  -- az elõadó személyek...
from eloadja		
	inner join szem_egy on szem_egy=kod
where jelzes='S'


-- ellenõrzéses lek. (ha nincs benne a megszor.)

select dal, szemely, count(*) as ennyiszer
from szemelyesen
group by dal, szemely
having count(*)>1

select dal, szemely, count(*) as ennyiszer
from
(
select dal, szemely -- az elõadó együttes tagjai...
from eloadja 
	inner join tagja on szem_egy=egyuttes
	inner join dal on dal=azon
where keletkezes between datumtol and isnull(datumig, getdate())
UNION all
select dal, szem_egy  -- az elõadó személyek...
from eloadja		
	inner join szem_egy on szem_egy=kod
where jelzes='S'
) as szemes
group by dal, szemely
having count(*)>1

go
create view zeneszerzok as
-- melyik dalnak ki az eredeti zeneszerzõje?

select dal, szemely as zeneszerzoje 
from  alkotja 
	inner join dal on DAL=azon
	inner join szerep on szerep=id
where eredeti is null and megnevezes like 'zeneszerz%'
union
select dal, szemely
from alkotja 
	inner join dal on EREDETI=azon
	inner join szerep on szerep=id
where eredeti is not null and megnevezes like 'zeneszerz%'

select * from dbo.zeneszerzok
go
create view nezet1 as 
-- minden dal tözsadata az eredetijének törzsadataival:
select dal.cim as dalcime, orig.cim as eredeticime 
from dal
	left outer join dal orig on dal.eredeti=orig.azon

-- adott dal elõadói között szereplõ zeneszerzõk?

create function ottvolt
(
@dal int
)
returns table

	return
	(
	(
	select szemely as ki 
	from  alkotja 
		inner join dal on DAL=azon
		inner join szerep on szerep=id
	where eredeti is null and megnevezes like 'zeneszerz%' and dal=@dal
	union
	select szemely
	from alkotja 
		inner join dal on EREDETI=azon
		inner join szerep on szerep=id
	where eredeti is not null and megnevezes like 'zeneszerz%' and dal=@dal
	)
	intersect
	(
	select szemely -- az elõadó együttes tagjai...
	from eloadja 
		inner join tagja on szem_egy=egyuttes
		inner join dal on dal=azon
	where keletkezes between datumtol and isnull(datumig, getdate()) and dal=@dal
	UNION all
	select szem_egy  -- az elõadó személyek...
	from eloadja		
		inner join szem_egy on szem_egy=kod 
	where jelzes='S' and dal=@dal
	)
	)

	select * from dbo.ottvolt(1016)


--1. Ki hány Zé által szerzett dalt adtott elõ?
CREATE VIEW ZesDalokEloadok AS
SELECT se.nev AS eloado, COUNT(DISTINCT a.dal) AS dalok_szama
FROM szem_egy se
inner JOIN alkotja a ON se.kod = a.szemely
inner  JOIN dal d ON a.dal = d.azon
WHERE EXISTS (
    SELECT 1
    FROM alkotja az
    inner JOIN szem_egy sz ON az.szemely = sz.kod
    WHERE sz.nev = 'Zé' AND az.dal = a.dal
)
GROUP BY se.nev;
select * from ZesDalokEloadok






--2. Név szerint ki adott elõ Zé szerzeményt?
CREATE VIEW Zeszerzemenyek AS
SELECT DISTINCT se.nev AS eloado
FROM szem_egy se
JOIN alkotja a ON se.kod = a.szemely
JOIN dal d ON a.dal = d.azon
WHERE EXISTS (
    SELECT 1
    FROM alkotja az
    JOIN szem_egy sz ON az.szemely = sz.kod
    WHERE sz.nev = 'Zé' AND az.dal = a.dal
);

--3. mely dalnak melyik alkotója van az elõadói között?
SELECT 
    d.cim AS dal_cime,
    se.nev AS eloado,
    sz.megnevezes AS szerep
FROM alkotja a
JOIN dal d ON a.dal = d.azon
JOIN szem_egy se ON a.szemely = se.kod
JOIN szerep sz ON a.szerep = sz.id
WHERE EXISTS (
    SELECT 1
    FROM eloadja e
    WHERE e.dal = d.azon AND e.szem_egy = a.szemely
);
külsõ paraméteresként: 
CREATE FUNCTION DalAlkotokEloadok
(
    @dalId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        d.cim AS dal_cime,
        se.nev AS eloado,
        sz.megnevezes AS szerep
    FROM alkotja a
    JOIN dal d ON a.dal = d.azon
    JOIN szem_egy se ON a.szemely = se.kod
    JOIN szerep sz ON a.szerep = sz.id
    WHERE 
        d.azon = @dalId
        AND EXISTS (
            SELECT 1
            FROM eloadja e
            WHERE e.dal = d.azon AND e.szem_egy = a.szemely
        )
);

--4. Mely dalnak melyik elõadója van az alkotói között?
SELECT 
        d.cim AS dal_cime,
        se.nev AS eloado,
        sz.megnevezes AS szerep
    FROM eloadja e
    JOIN dal d ON e.dal = d.azon
    JOIN szem_egy se ON e.szem_egy = se.kod
    JOIN alkotja a ON e.dal = a.dal AND e.szem_egy = a.szemely
    JOIN szerep sz ON a.szerep = sz.id
Küsõ paraméterként: 
CREATE FUNCTION DalnakElodoi
(
    @dalId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        d.cim AS dal_cime,
        se.nev AS eloado,
        sz.megnevezes AS szerep
    FROM eloadja e
    JOIN dal d ON e.dal = d.azon
    JOIN szem_egy se ON e.szem_egy = se.kod
    JOIN alkotja a ON e.dal = a.dal AND e.szem_egy = a.szemely
    JOIN szerep sz ON a.szerep = sz.id
    WHERE d.azon = @dalId
);

5. Hány naponta készültek az egyes dal megoldásai?
CREATE FUNCTION NapokKozott
(
    @SelectedDal INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        d1.azon AS dal_azonosito,
        d1.cim AS dal_cime,
        d1.keletkezes,
        DATEDIFF(day, ISNULL(MAX(d2.keletkezes), d1.keletkezes), d1.keletkezes) AS napok_kozott
    FROM
        dal d1
    LEFT JOIN
        dal d2 ON d1.keletkezes > d2.keletkezes
    WHERE
        d1.azon = @SelectedDal
    GROUP BY
        d1.azon, d1.cim, d1.keletkezes
);
