-- eventbrite ticket types
use raftdb2den;

-- test queries
-- Workshop_Id__c,Name,EventBriteSync__FullName__c,Member_Cost__c,Non_Member_Cost__c,Family__c,IsActive__c,EventbriteSync__Campaign__c
select top 20 a.ID as Workshop_Id__c
	, isnull(left(a.Title,80),'') as Name
	, isnull(left(a.Title,80),'') as EventBriteSync__FullName__c
	, a.MemberCost as Member_Cost__c
	, a.NonMemberCost as Non_Member_Cost__c
	, 'Ticket' as Family__c
	, '1' as IsActive__c
	, '' as EventbriteSync__Campaign__c
from workshops a
order by a.ID;

-- Workshop_Id__c,Name,EventBriteSync__FullName__c,Member_Cost__c,Non_Member_Cost__c,Family__c,IsActive__c,EventbriteSync__Campaign__c
select a.ID as Workshop_Id__c
	, isnull(left(a.Title,80),'') as Name
	, isnull(left(a.Title,80),'') as EventBriteSync__FullName__c
	, a.MemberCost as Member_Cost__c
	, a.NonMemberCost as Non_Member_Cost__c
	, 'Ticket' as Family__c
	, '1' as IsActive__c
	, '' as EventbriteSync__Campaign__c
	, '' as EventbriteSync__Opportunity__c
from workshops a
order by a.ID;
