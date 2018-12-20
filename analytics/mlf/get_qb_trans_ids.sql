use mlf;

set nocount on

declare @date date
declare @type nvarchar(255)
declare @num nvarchar(255)
declare @memo nvarchar(255)
declare @amount float
declare @qbid nvarchar(255)

declare @date2 date
declare @type2 nvarchar(255)
declare @num2 nvarchar(255)
declare @memo2 nvarchar(255)
declare @amount2 float
declare @qbtransid nvarchar(255)

declare @idstring nvarchar(255);

print 'QBID,QBTransID';

DECLARE db_cursor CURSOR FOR
select date, type, num, memo, credit as amount, id from opportunities
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @date, @type, @num, @memo, @amount, @qbid

declare @rownum int = 0
WHILE @@FETCH_STATUS = 0
BEGIN
	
	--print N'xxxx' + cast(@rownum as nvarchar(10)) + ' date: ' + cast(@date as nvarchar(12)) + ' type: ' + @type + ' num: ' + @num + ' memo: ' + @memo + ' amount: ' + cast(@amount as nvarchar(50)) + ' qb id: ' + cast(@qbid as nvarchar(50));
	set @idstring = '';
		
	DECLARE db_cursor2 CURSOR FOR
	select date, type, num, memo, amount, qbtransid
	from mlf_opps_with_trans_jan_sep_18
	where date = @date 
		and type = @type
		and num = @num
		and memo = @memo
		and amount = @amount
	OPEN db_cursor2
	FETCH NEXT FROM db_cursor2 INTO @date2, @type2, @num2, @memo2, @amount2, @qbtransid

	set @qbtransid = '';

	declare @rownum2 int = 0
	WHILE @@FETCH_STATUS = 0
	BEGIN

		--print N'----' + cast(@rownum2 as nvarchar(10)) + ' date: ' + cast(@date2 as nvarchar(12)) + ' type: ' + @type2 + ' num: ' + @num2 + ' memo: ' + @memo2 + ' amount: ' + cast(@amount2 as nvarchar(50)) + ' qb trans id: ' + @qbtransid;

		if (@qbid != '' and @qbtransid != '') 
		begin
			set @idstring = @qbid + ',' + @qbtransid;
			print @idstring;
		end

		FETCH NEXT FROM db_cursor2 INTO @date2, @type2, @num2, @memo2, @amount2, @qbtransid
		set @rownum2 = @rownum2 + 1

	END
	CLOSE db_cursor2
	DEALLOCATE db_cursor2

	FETCH NEXT FROM db_cursor INTO @date, @type, @num, @memo, @amount, @qbid
	set @rownum = @rownum + 1

END
CLOSE db_cursor
DEALLOCATE db_cursor


set nocount off