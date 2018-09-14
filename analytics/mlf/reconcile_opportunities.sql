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
print N'System,Opportunity Name,Opportunity ID,Close Date,Amount';
while (@m <= @mcnt)
--while (@m <= 5)
begin
	
	set @accountcnt = 0;
	set @accountid = '';
	
	-- get QB opportunity type and name
	set @qbopptype = (select type from opportunities where id = @m);
	if @qbopptype != 'Deposit'
	begin

		set @qboppname = (select name from opportunities where id = @m);
		set @accountcnt = (select count(*) from sf_accounts where name like @qboppname + '%');
		if @accountcnt = 0
		begin
			set @qboppname = (select lastname from opportunities where id = @m);
			set @accountcnt = (select count(*) from sf_accounts where name like '%' + @qboppname + '%');
		end
		--print N' --------------------account cnt: ' + rtrim(cast(@accountcnt as nvarchar(10)));
		if @accountcnt > 0
		begin
			
			if (object_id('tempdb..#opps') is not null) begin drop table #opps end;
			select a.Id as QBID, a.Date as QBDate, a.Credit as QBCredit, a.Name as QBName, b.CloseDate as SFCloseDate, b.Id as SFOppId, b.Name as SFName, b.Amount as SFAmount into #opps
			from opportunities a
			inner join sf_opportunities b on a.Date = b.CloseDate
			where a.Id = @m
				and StageName IN ('Pledged','Received') 
				and (b.Name like '%' + @qboppname + '%')
			--select QBID, QBDate, QBCredit, QBName, SFCloseDate, SFOppId, SFName, SFAmount from #opps;

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
			--SELECT Id, AccountId, Amount, CloseDate, Name FROM sf_opportunities WHERE Amount = @qbamount AND CloseDate = @qbdate AND Name like '%' + @qboppname + '%';
			--SELECT Id, AccountId, Amount, CloseDate, Name FROM sf_opportunities WHERE StageName IN ('Pledged','Received') AND CloseDate = @qbdate AND Name like @qboppname + '%';
			select QBID, QBDate, QBCredit, QBName, SFCloseDate, SFOppId, SFName, SFAmount from #opps;
			OPEN db_cursor
			FETCH NEXT FROM db_cursor INTO @qboppid, @qbdate, @qbcredit, @qbname, @sfclosedate, @sfoppid, @sfname, @sfamount

			WHILE @@FETCH_STATUS = 0
			BEGIN

				--print N' SF Name: ' + @sfname + ' SF Opportunity Id: ' + @sfoppid + ' SF Account Id: ' + @sfaccountid + ' SF Amount: ' + cast(@sfamount as nvarchar(10)) + ' SF Close Date: ' + cast(@sfclosedate as nvarchar(10));
				print N'QB,' + quotename(@qbname,'"') + ',' + @qboppid + ',' + cast(@qbdate as nvarchar(12)) + ',' + cast(@qbcredit as nvarchar(50));
				print N'SF,' + quotename(@sfname,'"') + ',' + @sfoppid + ',' + cast(@sfclosedate as nvarchar(50)) + ',' + cast(@sfamount as nvarchar(10));
				
				FETCH NEXT FROM db_cursor INTO @qboppid, @qbdate, @qbcredit, @qbname, @sfclosedate, @sfoppid, @sfname, @sfamount

			END
			CLOSE db_cursor
			DEALLOCATE db_cursor

		end

	end

	set @m = @m + 1
end

set nocount off