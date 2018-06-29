-- dp gift to opportunity
use dp;

-- dump gifts
-- Donor_Perfect_Id__c,Donor_Perfect_Contact_Id__c,Donor_Perfect_Account_Id__c,StageName,CloseDate,Amount,Donor_Perfect_Campaign_Id__c,Description
select top 5 a.gift_id as Donor_Perfect_Id__c
	, a.donor_id as Donor_Perfect_Contact_Id__c
	, a.donor_id as Donor_Perfect_Account_Id__c
	, case
		when a.record_type = 'G' then 'Posted'
		when a.record_type = 'P' then 'Pledged'
	  end as StageName
	, isnull(convert(nvarchar,a.gift_date,126),'') as CloseDate
	, a.amount as Amount
	, a.campaign as Donor_Perfect_Campaign_Id__c
	, isnull(a.gift_narrative,'') as Description
from dpgift a
where a.record_type in ('P','G')
order by a.gift_id;