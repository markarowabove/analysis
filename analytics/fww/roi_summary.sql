use fww;

set nocount on

-- segment variables
declare @begindate date
declare @enddate date
declare @segmentcountmax int
declare @segmentcount int
declare @segmentdays int
declare @segmentnumberbegin int
declare @segmentnumberend int
declare @segmentotaldays int

set @segmentdays = 91; -- 365 days / 4 = 91.25

/****************** change these two values for each run ************/
-- use this to set the max @segmentnumberbegin value for the 36 months and greater run
-- select (year(getdate()) - min(year(closedate)))*4 from opportunities; (2018-2007)*4=44
--select (datediff(day,dateadd(yy,datediff(yy,0,getdate()),0),getdate()))/91;
-- select min(closedate) from opportunities; -- 2007-01-09
set @segmentnumberbegin = 1;
set @segmentnumberend = 0;

set @segmentotaldays = @segmentdays*(@segmentnumberbegin-@segmentnumberend);
set @begindate = format(dateadd(day,-@segmentdays*@segmentnumberbegin,getdate()),'yyyy-MM-dd');
set @enddate = format(dateadd(day,-@segmentdays*@segmentnumberend,getdate()),'yyyy-MM-dd');

print N'Row,Source Channel,Source Type,0-3 Months,3-6 Months,6-9 Months,9-12 Months,12-24 Months,24-36 Months,36+ Months';
print N',,,,,,,,,';

declare @channel nvarchar(255)
declare @type nvarchar(255)
declare @amount nvarchar(255)
declare @deltadays nvarchar(255)

DECLARE db_cursor CURSOR FOR
select channel
	, type
	, amount
	, deltadays 
from opportunities_delta 
where 1 = 1
	and deltadays >= @segmentnumberend*@segmentdays
	and deltadays <  @segmentnumberbegin*@segmentdays
	and deltadays > 0
order by channel, type, amount;
	--and deltadays >= 0
	--and deltadays < 91 -- 269,989
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @channel, @type, @amount, @deltadays

declare @rownum int = 0
WHILE @@FETCH_STATUS = 0
BEGIN

	set @rownum = @rownum + 1
	print cast(@rownum as nvarchar(10)) + ',' + @channel + ',' + @type + ',' + cast(@amount as nvarchar(18));
	FETCH NEXT FROM db_cursor INTO @channel, @type, @amount, @deltadays
	

END
CLOSE db_cursor
DEALLOCATE db_cursor

set nocount off
