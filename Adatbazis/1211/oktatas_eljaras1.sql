use oktatas
CREATE PROCEDURE tt_generalas
	--nem lesz ennek param�tere

AS
BEGIN	
	IF 0 = (select COUNT(*) from tanit)
	--IF not exist (select 1 from tanit) --M�sikverzi� ez es j�
		Insert into tanit
			Select o.evf, o.betu, v.tant, null
			from tanterv v
				inner join osztaly o on v.evf=o.evf
	ELSE
		print 'M�r fel van t�ltve...'

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
--exec jegyadas

GO
CREATE PROCEDURE jegyadas2
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
