-- workshop enrollments to event brite order line item
use raftdb2den;

--select * from WorkshopEnrollment order by id;

-- dump workshop enrollments
-- Enrollment_Id__c,EventbriteSync__TicketType__c,EventbriteSync__Campaign__c,EventBriteSync_Opportunity_r_Enrollment__c,EventbriteSync__AttendeeContact_Raft_Db2_Id__c
select a.ID as Enrollment_Id__c
	, a.workshopID as EventbriteSync__TicketType__c
	, a.workshopID as EventbriteSync__Campaign__c
	, a.ID as EventBriteSync_Opportunity_r_Enrollment__c
	, b.id as EventbriteSync__AttendeeContact_Raft_Db2_Id__c
from WorkshopEnrollment a
left join Names b on a.NameID = b.ID
order by a.Id;
