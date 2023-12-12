use DALOK_jo
go
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

--alter table megjelent
--add check (dbo.megjelenhet(dal, datum)=1) -- with nocheck ?
-- a felületen raktuk hozzá... (hátha nem akartuk validálni azt a meglévõ adatokra)


create table valt
(
alk_id int, --identity (1,1),
datumig datetime not null,
r_szemely int,
r_dal int,
r_szerep int,
primary key (alk_id, datumig)
-- akár PK és FK is felesleges
-- lesz neki 1 triggere; ne lehessen közvetlenül ide felvenni sort
)

select * from  alkotja
go 



--create trigger <tr_nev>
--on <tabla>
--after/for <mûvelet: ins/upd/del>
-- már van: instead of <mûvelet>
--as
--begin
	aut. létrejön az OLD (deleted) és NEW (inserted) tábla a fenti táblához uolyan oszlopokkal ésa régi ill. új sorral
	mûvelet is itt lesz, ha nem after esemény
--end


create trigger naplozas
ON alkotja
after update
as
begin
-- plusz adatbázismûvelet vagy hibaüzenet 
-- sort vigyen fel a vált-ba
-- feltétel is lehet hozzá...
--IF update(mezõ) akkor legyen csak naplózás
	insert into valt
	select alk_id, getdate(), szemely, dal, szerep from deleted

end
-- itt kaptam magamtól 3 fekete pontot!



--select * from alkotja
--update alkotja
--set szerep=50
--where alk_id=500


--select * from valt
---- a naplózásba ne vihessek bele kzvtlenül adatsort
--insert into valt
--values (500, getdate(), 101, 1000, 50)


create trigger tiltas
on valt
for insert
as
begin
	if @@nestlevel=1 --rendszerváltozó
		rollback
end

-- szorg. lekérdezések?

