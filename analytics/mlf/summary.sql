use mlf;

set nocount on

declare @sfoppid nvarchar(18)
declare @sfamount float
declare @sfclosedate date
declare @sfname nvarchar(255)
declare @sfchecknumber int
declare @sfclassynumber int

--select count(*) from opportunities; -- 5259
--select * from sf_opportunities where name like '%Lubbers%'; -- 116,329
--select * from opportunities where name like '%Corroa%'
--select count(*) from sf_accounts where name like 'Corroa%';
--select count(*) from sf_accounts where name like '%Corroa Jr.%'

-- create a temp table of unique QB names
if (object_id('tempdb..#qbnames') is not null) begin drop table #qbnames end;
select distinct name, lastname into #qbnames from opportunities;
update #qbnames set lastname = name where lastname is null;
--select * from #qbnames where name like '%YourCause, LLC-Medtronic%' order by name;

-- find opportunities only found in SF
/***************** OPPORTUNITIES *************/
if object_id('dbo.opportunities_sf_qb','U') is not null
	drop table opportunities_sf_qb;
create table opportunities_sf_qb (
	ID int identity(1,1) not null
	, QBID int not null
	, QBDate date not null
	, QBCredit float not null
	, QBName nvarchar(255) not null
	, SFCloseDate date not null
	, SFOppId nvarchar(18) not null
	, SFName nvarchar(255) not null
	, SFAmount float not null
	, SFCheckNumber int
	, SFClassyNumber int
);

--if (object_id('tempdb..#sfopps') is not null) begin drop table #sfopps end;
--select id as SFOppId, closedate as SFCloseDate, name as SFName, amount as SFAmount into #sfopps from sf_opportunities where stagename in ('Received','Pledged') and closedate >= '2018-01-01';
--select count(*) from #sfopps;
--select * from opportunities_sf;

DECLARE db_cursor CURSOR FOR
select id as SFOppId
	, closedate as SFCloseDate
	, name as SFName, amount as SFAmount 
	, check_number__c as SFCheckNumber
	, classy_payment_num__c as SFClassyNumber
	from sf_opportunities 
	where stagename = 'Received' 
		and closedate >= '2018-01-01';
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @sfoppid, @sfclosedate, @sfname, @sfamount, @sfchecknumber, @sfclassynumber

declare @found int = 0
declare @rownum int = 0
WHILE @@FETCH_STATUS = 0
BEGIN

	set @found = 0;
	print N' SF Name: ' + @sfname + ' SF Opportunity Id: ' + @sfoppid + ' SF Amount: ' + cast(@sfamount as nvarchar(10)) + ' SF Close Date: ' + cast(@sfclosedate as nvarchar(10));
	set @found = (select count(*) from #qbnames where @sfname like '%' + lastname + '%');
	if @found = 0
	begin
		print N' NOT found: ' + cast(@found as nvarchar(10)) + ' SF Name: ' + @sfname;
		insert into opportunities_sf (sfoppid, sfclosedate, sfname, sfamount, sfchecknumber, sfclassynumber)
			select @sfoppid, @sfclosedate, @sfname, @sfamount;
	end
	
	FETCH NEXT FROM db_cursor INTO @sfoppid, @sfclosedate, @sfname, @sfamount, @sfchecknumber, @sfclassynumber
	set @rownum = @rownum + 1

END
CLOSE db_cursor
DEALLOCATE db_cursor
set nocount off