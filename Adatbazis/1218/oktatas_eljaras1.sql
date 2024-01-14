use oktatas
CREATE PROCEDURE tt_generalas
	--nem lesz ennek paramétere

AS
BEGIN	
	IF 0 = (select COUNT(*) from tanit)
	--IF not exist (select 1 from tanit) --Másikverzió ez es jó
		Insert into tanit
			Select o.evf, o.betu, v.tant, null
			from tanterv v
				inner join osztaly o on v.evf=o.evf
	ELSE
		print 'MÁr fel van töltve...'

END
GO
exec tt_generalas

select * from tanit

use oktatas
GO
CREATE PROCEDURE jegyadas
	@diak int,
	@tant char(5),
	@jegy tinyint

AS
BEGIN	
	Declare @evf tinyint
	select @evf=evf from diak where azon=@diak
	if exists (select 1 from tanterv where evf=@evf and tant=@tant)
		INSERT INTO jegy values(@diak, GETDATE(), @tant, @jegy)
	else 
		print 'NOPE'

END
GO
--lefuttatni
--exec jegyadas


--alter table jegytipus
--add jegy int

GO
create PROCEDURE jegyadas2
	@diak int,
	@tant char(5),
	@jegy tinyint,
	@tip int

AS
BEGIN	
	--amennyiben mined párhuzamos osztályban  uyanazokat tanítják
	--
	Declare @evf tinyint, @betu tinyint
	select @evf=evf, @betu=betu from diak where azon=@diak
	if exists (select 1 from tanit where evf=@evf and betu=@betu and tant=@tant)
	--if exists (select 1 from tanterv where evf=@evf and tant=@tant)
		INSERT INTO jegy values(@diak, GETDATE(), @tant, @jegy, @tip)
	else 
		print 'NOPE'
END
--insertel felveszi
-- de exec kel nem veheti fel

exec jegyadas2 100, 'MAT3', 4, 2
