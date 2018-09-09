-- dp gift to eventbrite ticket type
use dp;

-- diff - additional records
if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.Donor_Perfect_Id__c as Id into #ids from dpcampaigns a
left join dp_old.dbo.dpcampaigns b on a.Donor_Perfect_Id__c = b.gift_id
where b.gift_id is null;
--select * from #ids order by id;

-- Donor_Perfect_Id__c,EventbriteSync_Campaign_Donor_Perfect_Id__c,Name,EventbriteSync_FullName__c,Family,IsActive
select a.Donor_Perfect_Id__c as Donor_Perfect_Id__c
	, a.Donor_Perfect_Id__c as EventbriteSync_Campaign_Donor_Perfect_Id__c
	, a.name as Name
	, a.name as EventbriteSync_FullName__c
	, 'Ticket' as Family
	, '1' as IsActive
from dpcampaigns a
where a.Donor_Perfect_Id__c != ''
order by a.Donor_Perfect_Id__c;


