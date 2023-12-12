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
-- a fel�leten raktuk hozz�... (h�tha nem akartuk valid�lni azt a megl�v� adatokra)


create table valt
(
alk_id int, --identity (1,1),
datumig datetime not null,
r_szemely int,
r_dal int,
r_szerep int,
primary key (alk_id, datumig)
-- ak�r PK �s FK is felesleges
-- lesz neki 1 triggere; ne lehessen k�zvetlen�l ide felvenni sort
)

select * from  alkotja
go 



--create trigger <tr_nev>
--on <tabla>
--after/for <m�velet: ins/upd/del>
-- m�r van: instead of <m�velet>
--as
--begin
	aut. l�trej�n az OLD (deleted) �s NEW (inserted) t�bla a fenti t�bl�hoz uolyan oszlopokkal �sa r�gi ill. �j sorral
	m�velet is itt lesz, ha nem after esem�ny
--end


create trigger naplozas
ON alkotja
after update
as
begin
-- plusz adatb�zism�velet vagy hiba�zenet 
-- sort vigyen fel a v�lt-ba
-- felt�tel is lehet hozz�...
--IF update(mez�) akkor legyen csak napl�z�s
	insert into valt
	select alk_id, getdate(), szemely, dal, szerep from deleted

end
-- itt kaptam magamt�l 3 fekete pontot!



--select * from alkotja
--update alkotja
--set szerep=50
--where alk_id=500


--select * from valt
---- a napl�z�sba ne vihessek bele kzvtlen�l adatsort
--insert into valt
--values (500, getdate(), 101, 1000, 50)


create trigger tiltas
on valt
for insert
as
begin
	if @@nestlevel=1 --rendszerv�ltoz�
		rollback
end

-- szorg. lek�rdez�sek?

