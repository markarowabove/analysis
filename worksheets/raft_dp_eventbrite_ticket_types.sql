-- dp gift to eventbrite ticket type
use dp;

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


