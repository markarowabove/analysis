-- dp gift to eventbrite order line items
use dp;

-- Donor_Perfect_Id__c,EventBriteSync_Opportunity_r_Enrollment_Donor_Perfect_Id__c,EventbriteSync_Ticket_Type_Donor_Perfect_Id__c,EventbriteSync_Campaign_Donor_Perfect_Id__c,EventbriteSync__AttendeeContact_Donor_Perfect_Id__c
select a.gift_id as Donor_Perfect_Id__c
	, a.gift_id as EventBriteSync_Opportunity_r_Enrollment_Donor_Perfect_Id__c
	, a.campaign as EventbriteSync_TicketType__c	
	, a.campaign as EventbriteSync_Campaign_Donor_Perfect_Id__c
	, b.donor_id as EventbriteSync__AttendeeContact_Donor_Perfect_Id__c
from dpgift a
left join dp b on a.donor_id = b.donor_id
where a.solicit_code = 'TICKE6'
	and a.record_type in ('G','P')
order by a.gift_id;

