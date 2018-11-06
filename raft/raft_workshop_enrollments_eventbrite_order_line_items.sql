-- workshop enrollments to event brite order line item
use raftdb2den;

if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.Id as Id into #ids from WorkshopEnrollment a
left join raftdb2den_old.dbo.WorkshopEnrollment b on a.Id = b.Id
where b.Id is null;
--select * from #ids order by id;

--select * from WorkshopEnrollment order by id;

-- dump workshop enrollments
-- Enrollment_Id__c,EventbriteSync__TicketType__c,EventbriteSync__Campaign__c,EventBriteSync_Opportunity_r_Enrollment__c,EventbriteSync__AttendeeContact_Raft_Db2_Id__c
select a.ID as Enrollment_Id__c
	, a.workshopID as EventbriteSync__TicketType__c
	, a.workshopID as EventbriteSync__Campaign__c
	, a.ID as EventBriteSync_Opportunity_r_Enrollment__c
	, b.id as EventbriteSync__AttendeeContact_Raft_Db2_Id__c
	, 'DB2 Import 20180725' as Import_Tag__c
from WorkshopEnrollment a
left join Names b on a.NameID = b.ID
inner join #ids c on a.id = c.id
order by a.Id;
