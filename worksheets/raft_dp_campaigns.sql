-- dp campaigns
use dp;

update a
set a.campaign = b.campaign
from dpgift a
left join dpidscampaigns b on a.gift_id = b.id
where a.gift_id = 4;

select b.campaign, a.*
from dpgift a
left join dpidscampaigns b on a.gift_id = b.id
--where a.gift_id = 4
order by a.campaign;

if (object_id('tempdb..#campaigns') is not null) begin drop table #campaigns end;
select distinct a.campaign as id into #campaigns
from dpgift a 
where a.campaign != ''
order by a.campaign;

--select * from #campaigns order by id;

-- create a new local db table to used later
if (object_id('dbo.DPCAMPAIGNS') is not null) begin drop table dbo.DPCAMPAIGNS end;
-- dump campaigns
-- Donor_Perfect_Id__c,Name,Status,Type,IsActive,RecordTypeId
select a.id as Donor_Perfect_Id__c
	, isnull(b.description,a.id) as Name
	, 'Completed' as Status
	, 'Fundraising' as Type
	, '1' as IsActive
	, '012f4000000iS0Z' as RecordTypeId
into DPCAMPAIGNS
from #campaigns a
inner join dpcodes b on a.id = b.code
where b.field_name = 'CAMPAIGN'
order by a.id;

select * from dpcampaigns order by name;


