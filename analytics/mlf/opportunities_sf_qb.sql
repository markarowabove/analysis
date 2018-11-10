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

--select count(*) from opportunities; --7751
--select count(*) from sf_opportunities where closedate >= '2018-01-01' and closedate < '2018-10-01'; --10,296
--select count(*) from opportunities_sf_qb;
--select * from sf_accounts;
--select * from opportunities_sf where SFName like '%Truck%'

-- create a temp table of unique SF account names
if (object_id('tempdb..#sfaccountnames') is not null) begin drop table #sfaccountnames end;
select distinct name into #sfaccountnames from sf_accounts;

-- find opportunities shared by QB and SF
/***************** OPPORTUNITIES *************/
if object_id('dbo.opportunities_sf_qb','U') is not null
	drop table opportunities_sf_qb;
create table opportunities_sf_qb (
	ID int identity(1,1) not null
	, QBID int not null
	, QBDate date not null
	, QBCredit float not null
	, QBName nvarchar(255) not null
	, QBType nvarchar(100) not null
	, SFCloseDate date not null
	, SFOppId nvarchar(18) not null
	, SFName nvarchar(255) not null
	, SFAmount float not null
	, SFCheckNumber nvarchar(100)
	, SFClassyNumber nvarchar(100)
	, SFClassyAnonymous int
	, SFCampaignId nvarchar(18)
);

set @m = 1;
select @mcnt = count(*) from opportunities;
while (@m <= @mcnt)
--while (@m <= 5)
begin
	
	set @accountcnt = 0;
	set @accountid = '';
	
	-- get QB opportunity type and name
	--set @qbopptype = (select type from opportunities where id = @m);
	--if @qbopptype != 'Deposit'
	--begin

		set @qboppname = (select name from opportunities where id = @m);
		set @accountcnt = (select count(*) from sf_accounts where name like '%' + @qboppname + '%');
		if @accountcnt = 0
		begin
			set @qboppname = (select lastname from opportunities where id = @m);
			set @accountcnt = (select count(*) from sf_accounts where name like '%' + @qboppname + '%');
		end
		--print N' --------------------account cnt: ' + rtrim(cast(@accountcnt as nvarchar(10)));
		if @accountcnt > 0
		begin
			
			insert into opportunities_sf_qb (QBID, QBDate, QBCredit, QBName, QBType, SFCloseDate, SFOppId, SFName, SFAmount, SFCheckNumber, SFClassyNumber, SFClassyAnonymous, SFCampaignId)
			select a.Id as QBID
				, a.Date as QBDate
				, a.Credit as QBCredit
				, a.Name as QBName
				, a.Type as QBType
				, b.SFCloseDate
				, b.SFOppId
				, b.SFName
				, b.SFAmount
				, b.SFCheckNumber
				, b.SFClassyNumber
				, b.SFClassyAnonymous 
				, b.SFCampaignId
			from opportunities a
			inner join opportunities_sf b on a.Date = b.SFCloseDate
			where a.Id = @m
				and b.SFName like'%' + @qboppname + '%'
				--and a.Credit = b.Amount

		end

	--end

	set @m = @m + 1
end

set nocount off

--select * from opportunities_sf_qb order by qbdate; 