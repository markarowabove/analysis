use mlf;

-- get a unique list of SF Account Ids
if object_id('dbo.sf_accounts','U') is not null
	drop table sf_accounts;
	create table dbo.sf_accounts(  
		id int identity not null primary key
		, name nvarchar(255) not null
		, namekey nvarchar(255) not null
	); 
insert into sf_accounts (name, namekey)
	select distinct rtrim(left(sfname,charindex('$',sfname,1)-1)) as name 
		, rtrim(replace(replace(replace(left(sfname,charindex('$',sfname,1)-1),' ',''),',',''),'.','')) as namekey
	from opportunities_sf

update a 
set namekey = rtrim(replace(replace(replace(left(b.name,charindex('$',b.name,1)-1),' ',''),',',''),'.',''))
from sf_opportunities a 
inner join sf_opportunities b on a.id = b.id;

set nocount off

--select * from sf_accounts order by name;
--select name, namekey from sf_opportunities where namekey != '';
--select * from opportunities_sf;

