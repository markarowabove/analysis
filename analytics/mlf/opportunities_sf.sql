use mlf;

set nocount on

declare @sfoppid nvarchar(18)
declare @sfamount float
declare @sfclosedate date
declare @sfname nvarchar(255)
declare @sfchecknumber nvarchar(100)
declare @sfclassynumber nvarchar(100)

--select count(*) from opportunities; -- 5259
--select * from sf_opportunities where name like '%Lubbers%'; -- 116,329
--select * from opportunities where name like '%Corroa%'
--select count(*) from sf_accounts where name like 'Corroa%';
--select count(*) from sf_accounts where name like '%Corroa Jr.%'
-- select top 100 * from opportunities_sf order by sfname;
--select * from opportunities_sf where found = 0 order by SFName;

-- create a temp table of unique QB names
if (object_id('tempdb..#qbnames') is not null) begin drop table #qbnames end;
select distinct name, lastname into #qbnames from opportunities 
where 1 = 1
	and name != '' 
	--and type in ('Sales Receipt','General Journal')
;
update #qbnames set lastname = name where lastname is null;
--select * from #qbnames where name like '%YourCause, LLC-Medtronic%' order by name;

-- find opportunities only found in SF
/***************** OPPORTUNITIES *************/
if object_id('dbo.opportunities_sf','U') is not null
	drop table opportunities_sf;
create table opportunities_sf (
	ID int identity(1,1) not null
	, SFCloseDate date not null
	, SFOppId nvarchar(18) not null
	, SFName nvarchar(255) not null
	, SFAmount float not null
	, SFCheckNumber nvarchar(100)
	, SFClassyNumber nvarchar(100)
	, found int
);

--if (object_id('tempdb..#sfopps') is not null) begin drop table #sfopps end;
--select id as SFOppId, closedate as SFCloseDate, name as SFName, amount as SFAmount into #sfopps from sf_opportunities where stagename in ('Received','Pledged') and closedate >= '2018-01-01';
--select count(*) from #sfopps;
--select * from opportunities_sf;

DECLARE db_cursor CURSOR FOR
select id as SFOppId
	, closedate as SFCloseDate
	, name as SFName
	, amount as SFAmount 
	, stayclassy__check_number__c as SFCheckNumber
	, stayclassy__sc_order_id__c as SFClassyNumber
from sf_opportunities 
where stagename = 'Received' 
	and closedate >= '2018-01-01';
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @sfoppid, @sfclosedate, @sfname, @sfamount, @sfchecknumber, @sfclassynumber

declare @found int = 0
declare @rownum int = 0
WHILE @@FETCH_STATUS = 0
BEGIN

	/****
	set @found = 0;
	print N' SF Name: ' + @sfname + ' SF Opportunity Id: ' + @sfoppid + ' SF Amount: ' + cast(@sfamount as nvarchar(10)) + ' SF Close Date: ' + cast(@sfclosedate as nvarchar(10));
	set @found = (select count(*) from #qbnames where @sfname like '%' + lastname + '%');
	if @found > 1
	begin
		print N' found SF Name: ' + @sfname;
		insert into opportunities_sf (sfoppid, sfclosedate, sfname, sfamount, sfchecknumber, sfclassynumber)
			select @sfoppid, @sfclosedate, @sfname, @sfamount, @sfchecknumber, @sfclassynumber;
	end
	****/
	set @found = 0;
	print N' SF Name: ' + @sfname + ' SF Opportunity Id: ' + @sfoppid + ' SF Amount: ' + cast(@sfamount as nvarchar(10)) + ' SF Close Date: ' + cast(@sfclosedate as nvarchar(10));
	set @found = (select count(*) from #qbnames where @sfname like '%' + lastname + '%');
	insert into opportunities_sf (sfoppid, sfclosedate, sfname, sfamount, sfchecknumber, sfclassynumber, found)
		select @sfoppid, @sfclosedate, @sfname, @sfamount, @sfchecknumber, @sfclassynumber, @found;

	FETCH NEXT FROM db_cursor INTO @sfoppid, @sfclosedate, @sfname, @sfamount, @sfchecknumber, @sfclassynumber
	set @rownum = @rownum + 1

END
CLOSE db_cursor
DEALLOCATE db_cursor
set nocount off