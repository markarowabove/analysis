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
		if @accountcnt > 0
			print rtrim(cast(@m as nvarchar(10))) + ': QB Account Name: ' + @qboppname;
		else
		begin
			set @qboppname = (select lastname from opportunities where id = @m);
			set @accountcnt = (select count(*) from sf_accounts where name like '%' + @qboppname + '%');
			if @accountcnt > 0
				print rtrim(cast(@m as nvarchar(10))) + ': QB Account Name: ' + @qboppname;
		end
		print N' --------------------account cnt: ' + rtrim(cast(@accountcnt as nvarchar(10)));
		if @accountcnt > 0
		begin
			
			declare @qboppid nvarchar(18)
			declare @qbdate date
			declare @qbamount float
			declare @qbname nvarchar(255)
			declare @outstring nvarchar(max)

			DECLARE db_cursor_2 CURSOR FOR
			SELECT Id, Date, Credit, Name FROM opportunities WHERE Id = @m;
			OPEN db_cursor_2
			FETCH NEXT FROM db_cursor_2 INTO @qboppid, @qbdate, @qbamount, @qbname

			WHILE @@FETCH_STATUS = 0
			BEGIN

				--print N' QB Name: ' + @qbname + ' QB Opportunity Id: ' + @qboppid + ' QB Date: ' + cast(@qbdate as nvarchar(12)) + ' QB Amount: ' + cast(@qbamount as nvarchar(10));
				declare @sfoppid nvarchar(18)
				declare @sfaccountid nvarchar(18)
				declare @sfamount float
				declare @sfclosedate date
				declare @sfname nvarchar(255)

				DECLARE db_cursor CURSOR FOR
				--SELECT Id, AccountId, Amount, CloseDate, Name FROM sf_opportunities WHERE Amount = @qbamount AND CloseDate = @qbdate AND Name like '%' + @qboppname + '%';
				SELECT Id, AccountId, Amount, CloseDate, Name FROM sf_opportunities WHERE StageName IN ('Pledged','Received') AND CloseDate = @qbdate AND Name like @qboppname + '%';
				OPEN db_cursor
				FETCH NEXT FROM db_cursor INTO @sfoppid, @sfaccountid, @sfamount, @sfclosedate, @sfname

				WHILE @@FETCH_STATUS = 0
				BEGIN

					--print N' SF Name: ' + @sfname + ' SF Opportunity Id: ' + @sfoppid + ' SF Account Id: ' + @sfaccountid + ' SF Amount: ' + cast(@sfamount as nvarchar(10)) + ' SF Close Date: ' + cast(@sfclosedate as nvarchar(10));
					print N'QB,' + quotename(@qbname,'"') + ',' + @qboppid + ',' + cast(@qbdate as nvarchar(12)) + ',' + cast(@qbamount as nvarchar(50));
					print N'SF,' + quotename(@sfname,'"') + ',' + @sfoppid + ',' + cast(@sfclosedate as nvarchar(50)) + ',' + cast(@sfamount as nvarchar(10));
				
					FETCH NEXT FROM db_cursor INTO @sfoppid, @sfaccountid, @sfamount, @sfclosedate, @sfname

				END
				CLOSE db_cursor
				DEALLOCATE db_cursor
				
				
				FETCH NEXT FROM db_cursor_2 INTO @qboppid, @qbdate, @qbamount, @qbname

			END
			CLOSE db_cursor_2
			DEALLOCATE db_cursor_2

		end

	end

	set @m = @m + 1
end

set nocount off





