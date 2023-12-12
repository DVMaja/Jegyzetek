use dalok_jo
use csomagkuldoB

select * from rend_t�tel
select * from cikk
select * from rendel�s
--ezek rosszak
--update rend_t�tel
--set
--csomag = 'cs01'
--where rend_sz�m='2008/002' and cikksz�m= 'c0002'

--update rend_t�tel
--set
--csomag = 'cs01'
--where rend_sz�m='2008/002' and cikksz�m= 'c0003'

--update rend_t�tel
--set
--csomag = 'cs03'
--where rend_sz�m='2008/601' and cikksz�m= 'c0002'

--ez j� volt els� lefuttat�sra, 
update rend_t�tel
set
csomag = 'cs02'
where rend_sz�m='2008/601' and cikksz�m= 'c0002'

--trigger
go
create trigger k�szletCs�kkent�s
on rend_t�tel
after update
as
begin
	declare @csom char(12),
			@cikk char(10),
			@rsz char(12),
			@ujcsom char(12),
			@menny smallint
	select @csom =csomag, @rsz=rend_sz�m, @cikk=cikksz�m from deleted
	select @ujcsom= csomag, @menny = menny from inserted
	if UPDATE(csomag) AND @csom is null-- itt �rdemes lenne megbontati, mert logikai gebasz van benne
		if @menny <= (select akt_k�szlet from cikk where cikksz�m=@cikk)
			if 1 = (select count(distinct vk�d)
					from rend_t�tel rt inner join rendel�s r  on rt.rend_sz�m=r.rend_sz�m
					where csomag=@ujcsom)
				update cikk set
				akt_k�szlet = akt_k�szlet- @menny
				where cikksz�m=@cikk
			else
			 begin
				print 'A vev�je rossz.'
				rollback
			 end
		else
			begin
			print 'Ehhez kev�s a k�szlet.'
			rollback
			end
	else
		begin
		print 'A csomag m�r teljes�tett.'
		rollback
		end
end