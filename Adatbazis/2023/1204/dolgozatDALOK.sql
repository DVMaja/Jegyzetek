use DALOK_jo

--Adott producer az adott zeneszerz�vel miket alkotott? //hangszerel� itt 50 51
//nem n�v alapj�n keres�nk
//nem a sz�mra keres�nk r�, de a szerep megnevez�se ne �gesd be a a sz�mokat

Select d.cim from alkotja a
	inner join szerep s on a.szerep=s.id
	inner join dal d on d.azon=a.dal
	inner join szem_egy sz on sz.kod= a.szemely
	where sz.nev LIKE '%Damiano David%' and  s.id=50--s.megnevezes= 

	union 
	Select * from alkotja a
	inner join szerep s on a.szerep=s.id
	inner join dal d on d.azon=a.dal
	inner join szem_egy sz on sz.kod= a.szemely
	where sz.kod = 111 and  s.id=51-

go
create function alkottak_eggyutt
(
@egyik nvarchar(30),
@masik nvarchar(30)
)
returns table

return
(
	(Select d.cim from alkotja a
		inner join szerep s on a.szerep=s.id
		inner join dal d on d.azon=a.dal
		inner join szem_egy sz on sz.kod= a.szemely
	where sz.nev LIKE @egyik and  s.id= 50)

	Intersect 

	(Select d.cim from alkotja a
		inner join szerep s on a.szerep=s.id
		inner join dal d on d.azon=a.dal
		inner join szem_egy sz on sz.kod= a.szemely
	where sz.nev LIKE @masik and  s.id= 51)
)
select * from alkottak_eggyutt('Damiano David', 'Ethan Torchio')


--Adott szerep h�ny dal feldolgoz�s�ban fordul el�?
select sz.megnevezes, count(*) from alkotja a
	inner join dal d on a.dal= d.azon
	inner join szerep sz on sz.id= a.szerep
where a.szerep = 50  and  d.eredeti is not null--sz.megnevezes = '%zeneszerz�%'
group by sz.megnevezes

go
create function szerep_hanyszor
(
@szerep nvarchar(30)
)
returns table
return
(
	select sz.megnevezes, count(distinct d.eredeti) as ennyi_feldogban
		from alkotja a
		inner join dal d on a.dal= d.azon
		inner join szerep sz on sz.id= a.szerep
	where sz.megnevezes = @szerep and  d.eredeti is not null
	group by sz.megnevezes
)




--Ki volt a tagja a legr�videbb ideig a Q egy�ttesnek?

Select sz.nev, DATEDIFF(DAY, datumig , datumtol)
	from tagja t
		inner join szem_egy sz on t.egyuttes = sz.kod
	where t.egyuttes = 105 and t.datumig is not null
	group by sz.nev
	


select datumig from tagja
				where datumig is not null)
go
create function tagja_rovid_ideig
(
@eggyutes nvarchar(30)
)
returns table
	return(
	Select sz.nev, DATEDIFF(DAY, datumig , datumtol)
	from tagja t
		inner join szem_egy sz on t.egyuttes = sz.kod
	where sz.nev=@eggyutes  and t.datumig is not null
	)
	Union
	Select * from tagja t
		inner join szem_egy sz on t.egyuttes = sz.kod
	where sz.nev = @eggyutes 
	Group by 
	
	


--Ki h�nyszor adta el� a C� c�m� dal feldolgoz�s�t?
--d.cim='Gossip'
select * from dal
select * from eloadja

select e.szem_egy, count(*) as ennyiszer from dal d inner join eloadja e on d.azon=e.dal
 where d.eredeti =(select azon from dal where cim='Gossip')
 group by e.szem_egy
 

go
create function feldolg_eload
(
@dcim nvarchar(30)
)
returns table
	return
	(
	Select e.szem_egy, count(*) as ennyiszer
	from dal d
		inner join eloadja e on d.azon=e.dal
	where d.eredeti =(select azon from dal where cim=@dcim)
	group by e.szem_egy
	)	


select * from dbo.feldolg_eload('Gossip')