use dalok_jo
use csomagkuldoB

select * from rend_tétel
select * from cikk
select * from rendelés
--ezek rosszak
--update rend_tétel
--set
--csomag = 'cs01'
--where rend_szám='2008/002' and cikkszám= 'c0002'

--update rend_tétel
--set
--csomag = 'cs01'
--where rend_szám='2008/002' and cikkszám= 'c0003'

--update rend_tétel
--set
--csomag = 'cs03'
--where rend_szám='2008/601' and cikkszám= 'c0002'

--ez jó volt elsõ lefuttatásra, 
update rend_tétel
set
csomag = 'cs02'
where rend_szám='2008/601' and cikkszám= 'c0002'

--trigger
go
create trigger készletCsökkentés
on rend_tétel
after update
as
begin
	declare @csom char(12),
			@cikk char(10),
			@rsz char(12),
			@ujcsom char(12),
			@menny smallint
	select @csom =csomag, @rsz=rend_szám, @cikk=cikkszám from deleted
	select @ujcsom= csomag, @menny = menny from inserted
	if UPDATE(csomag) AND @csom is null-- itt érdemes lenne megbontati, mert logikai gebasz van benne
		if @menny <= (select akt_készlet from cikk where cikkszám=@cikk)
			if 1 = (select count(distinct vkód)
					from rend_tétel rt inner join rendelés r  on rt.rend_szám=r.rend_szám
					where csomag=@ujcsom)
				update cikk set
				akt_készlet = akt_készlet- @menny
				where cikkszám=@cikk
			else
			 begin
				print 'A vevõje rossz.'
				rollback
			 end
		else
			begin
			print 'Ehhez kevés a készlet.'
			rollback
			end
	else
		begin
		print 'A csomag már teljesített.'
		rollback
		end
end