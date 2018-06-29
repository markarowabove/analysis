-- dp campaigns
use dp;

-- create a new local db table to used later
if (object_id('dbo.DPCAMPAIGNS') is not null) begin drop table dbo.DPCAMPAIGNS end;

if (object_id('tempdb..#campaigns') is not null) begin drop table #campaigns end;
select distinct a.campaign as id into #campaigns
from dpgift a 
where a.campaign != ''
order by a.campaign;

--select * from #campaigns order by id;

-- dump campaigns
-- Donor_Perfect_Id__c,Name,Status,Type,IsActive,RecordTypeId
select a.id as Donor_Perfect_Id__c
	, isnull(b.description,a.id) as Name
	, 'Completed' as Status
	, 'Event' as Type
	, '1' as IsActive
	, '012f4000000iS0Z' as RecordTypeId
into DPCAMPAIGNS
from #campaigns a
inner join dpcodes b on a.id = b.code
where b.field_name = 'CAMPAIGN'
order by a.id;


