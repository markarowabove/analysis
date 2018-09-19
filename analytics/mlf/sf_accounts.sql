use mlf;

alter table sf_opportunities alter column CloseDate date;
alter table sf_opportunities alter column Amount float;
alter table sf_opportunities add rownum int identity(1,1);

-- get a unique list of SF Account Ids
if object_id('dbo.sf_accounts','U') is not null
	drop table sf_accounts;
	create table dbo.sf_accounts(  
		id int identity not null primary key
		,name nvarchar(255) not null
	); 
insert into sf_accounts (name)
	select distinct rtrim(left(sfname,charindex('$',sfname,1)-1)) as name 
	from opportunities_sf

/***
select name, count(*)
from sf_accounts
group by name
having (count(*) > 1);
***/
