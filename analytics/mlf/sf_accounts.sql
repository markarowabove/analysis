use mlf;

-- get a unique list of SF Account Ids
if object_id('dbo.sf_accounts','U') is not null
	drop table sf_accounts;
	create table dbo.sf_accounts(  
		id int identity not null primary key
		,accountid varchar(18) not null
		,name nvarchar(255) not null
	); 
insert into sf_accounts (accountid, name)
	select distinct accountid as accountid
		, rtrim(left(name,charindex('$',name,1)-1)) as accountname 
	from sf_opportunities

/***
select accountname, count(*)
from sf_accounts
group by accountname
having (count(*) > 1);
***/
