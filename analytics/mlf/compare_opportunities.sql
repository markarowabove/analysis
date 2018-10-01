use mlf;

set nocount on

declare @r int
declare @f int
declare @m int
declare @rcnt int
declare @fcnt int
declare @mcnt int
declare @accountcnt int
declare @qboppname nvarchar(255)
declare @qbopptype nvarchar(255)
declare @accountid nvarchar(18)

--select count(*) from opportunities; -- 5259
--select * from sf_opportunities where name like '%Lubbers%'; -- 116,329
--select * from opportunities where name like '%Corroa%'
--select count(*) from sf_accounts where name like 'Corroa%';
--select count(*) from sf_accounts where name like '%Corroa Jr.%'

-- create a temp table of unique SF account names
if (object_id('tempdb..#sfaccountnames') is not null) begin drop table #sfaccountnames end;
select distinct name into #sfaccountnames from sf_accounts ;

-- find opportunities shared by QB and SF

set @m = 1;
select @mcnt = count(*) from opportunities;
print N',,Records found in Both Salesforce and Quick Books,' + 'Total QB Record count: ' + cast(@mcnt as nvarchar(10)) + ',';
print N',,,,,';
print N'Group Number,System,Opportunity Name,Opportunity ID,Close Date,Amount';

declare @sfoppid nvarchar(18)
declare @sfamount float
declare @sfclosedate date
declare @sfname nvarchar(255)
declare @qboppid nvarchar(18)
declare @qbaccountid nvarchar(18)
declare @qbcredit float
declare @qbdate date
declare @qbname nvarchar(255)

DECLARE db_cursor CURSOR FOR
select QBID, QBDate, QBCredit, QBName, SFCloseDate, SFOppId, SFName, SFAmount from opportunities_sf_qb
--select QBID, QBDate, QBCredit, QBName, SFCloseDate, SFOppId, SFName, SFAmount from opportunities_sf_qb where QBCredit = SFAmount
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @qboppid, @qbdate, @qbcredit, @qbname, @sfclosedate, @sfoppid, @sfname, @sfamount

declare @rownum int = 0
WHILE @@FETCH_STATUS = 0
BEGIN

	--print N' SF Name: ' + @sfname + ' SF Opportunity Id: ' + @sfoppid + ' SF Account Id: ' + @sfaccountid + ' SF Amount: ' + cast(@sfamount as nvarchar(10)) + ' SF Close Date: ' + cast(@sfclosedate as nvarchar(10));
	print N'' + cast(@rownum as nvarchar(10)) + ',QB,' + quotename(@qbname,'"') + ',' + @qboppid + ',' + cast(@qbdate as nvarchar(12)) + ',' + cast(@qbcredit as nvarchar(50));
	print N'' + cast(@rownum as nvarchar(10)) + ',SF,' + quotename(@sfname,'"') + ',' + @sfoppid + ',' + cast(@sfclosedate as nvarchar(50)) + ',' + cast(@sfamount as nvarchar(10));
				
	FETCH NEXT FROM db_cursor INTO @qboppid, @qbdate, @qbcredit, @qbname, @sfclosedate, @sfoppid, @sfname, @sfamount
	set @rownum = @rownum + 1
END
CLOSE db_cursor
DEALLOCATE db_cursor


set nocount off