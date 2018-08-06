-- dp gift to eventbrite order line items
use dp;

select solicit_code, count(*) 
from dpgift
group by solicit_code
order by solicit_code;

-- diff - additional records
if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.gift_id as Id into #ids from dpgift a
left join dp_old.dbo.dpgift b on a.gift_id = b.gift_id
where b.gift_id is null;
--select * from #ids order by id;

select a.solicit_code, count(*) 
from dpgift a
inner join #ids b on a.gift_id = b.id
group by a.solicit_code
order by a.solicit_code;

-- Donor_Perfect_Id__c,EventBriteSync_Opportunity_r_Enrollment_Donor_Perfect_Id__c,EventbriteSync_Ticket_Type_Donor_Perfect_Id__c,EventbriteSync_Campaign_Donor_Perfect_Id__c,EventbriteSync__AttendeeContact_Donor_Perfect_Id__c
select a.gift_id as Donor_Perfect_Id__c
	, a.gift_id as EventBriteSync_Opportunity_r_Enrollment_Donor_Perfect_Id__c
	, a.campaign as EventbriteSync_TicketType__c	
	, a.campaign as EventbriteSync_Campaign_Donor_Perfect_Id__c
	, b.donor_id as EventbriteSync__AttendeeContact_Donor_Perfect_Id__c
	, a.solicit_code 
from dpgift a
left join dp b on a.donor_id = b.donor_id
inner join #ids c on a.gift_id = c.id
where 1 = 1 
	--and a.solicit_code = 'TICKE6'
	--and a.solicit_code != ''
	and a.campaign != ''
	and a.record_type in ('G','P','M')
order by a.gift_id;

select * from dpgift where gift_id = 2922;
select * from dp where donor_id = 1779;